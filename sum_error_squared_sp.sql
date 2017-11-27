REPLACE PROCEDURE test_db.cluster_sum_error_squared ( 
	 IN run_id VARCHAR(40)		--for identifying runs
	,IN schema_name VARCHAR(40)	--schema that input table is in
	,IN input_table VARCHAR(40) --input table
	,IN k_clusters INT			--k to be passed to the K-Means function
) 
BEGIN 
	
	DECLARE dyn_sql VARCHAR(10000);
	DECLARE rvalue VARCHAR(10000); 
	DECLARE cluster_info_table CHAR(15);
	DECLARE cluster_table CHAR(15);
	
	SET dyn_sql = '';	
	SET cluster_info_table = 'info_table';
	SET cluster_table = 'results_table';
	
	--1. Run k-means
	CALL udf.run_kmeans_1_0(
		  :schema_name
		, :input_table
		, cluster_info_table
		, cluster_table
		, :k_clusters
		, 1000
		, 0.005
		, rvalue
	);
	
	--2. Create perm tables from the volatile so we can look up in DBC.Columns
	CALL dbc.sysexecsql ( 
		'CREATE TABLE ' || schema_name || '.' || cluster_info_table || 
		' AS (SELECT * FROM ' || cluster_info_table || 
		') WITH DATA NO PRIMARY INDEX;'
	);
	CALL dbc.sysexecsql ( 
		'CREATE TABLE ' || schema_name || '.' || cluster_table || 
		' AS (SELECT * FROM ' || cluster_table || 
		') WITH DATA NO PRIMARY INDEX;'
	);
	

	--3. Calculate the distance squared between each item and the cluster centroid
	FOR iCur AS IndexCursor CURSOR FOR
		SELECT 
			'SELECT i.clusterid, i.cnt,' ||
			CASE WHEN info.r > 2 THEN
				'(i.' || info.ColumnName || ' - c.' || clust.ColumnName || ')**2 AS Dist_Squrd'
				END ||
			' FROM ' || info.DatabaseName || '.' || info.TableName || ' AS i ' ||
			'JOIN ' || clust.DatabaseName || '.' || clust.TableName || ' as c ' ||
			'ON i.clusterid = c.clusterid ' || 
			CASE WHEN info.r <> 3 THEN ' UNION ALL ' ELSE '' END AS q
		FROM (
			SELECT 
				DatabaseName
				,TableName
				,ColumnName
				,RANK() OVER (ORDER BY columnid) AS r
			FROM dbc.columnsv
			WHERE TableName = cluster_info_table
			QUALIFY RANK() OVER (ORDER BY columnid) <> 2
		
		) AS info
		JOIN (
			SELECT 
				DatabaseName
				,TableName
				,ColumnName
				,RANK() OVER (ORDER BY columnid) AS r
			FROM dbc.columnsv
			WHERE TableName = cluster_table
			QUALIFY RANK() OVER (ORDER BY columnid) <> 2
		) AS clust
			on info.ColumnName = clust.ColumnName
		WHERE q is not null
		ORDER BY info.r DESC
		 DO
		 	SET dyn_sql = dyn_sql || iCur.q;
	END FOR;

	SET dyn_sql = 	'INSERT INTO ' || schema_name || '.mt_kmeans_withinness ' || 
		'SELECT ''' || run_id || ''',' || k_clusters || ', clusterid, cnt as cluster_size, sum(Dist_Squrd) as withinness, ''' || rvalue || ''' FROM ( ' ||dyn_sql ||
		' ) AS X GROUP BY 1,2,3,4;';
					
	CALL dbc.sysexecsql ( :dyn_sql) ;
	
	--4. Drop perm tables
	CALL dbc.sysexecsql ('DROP TABLE ' || schema_name || '.' || cluster_info_table || ';');
	CALL dbc.sysexecsql ('DROP TABLE ' || schema_name || '.' || cluster_table || ';');
	
END;