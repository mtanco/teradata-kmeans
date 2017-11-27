--Table to hold our results
DROP TABLE test_db.mt_kmeans_withinness;
CREATE TABLE test_db.mt_kmeans_withinness (
	run_id VARCHAR(40)				--for identifying runs
	,number_of_clusters INT 		--k to be passed to the K-Means function
	,cluster_id INT 				--a number between 1 and k inclusive
	,cluster_size INT 				--number of items in each cluster
	,withinness DECIMAL(13,4) 		--sum of squared error for each cluster
	,covergence_info VARCHAR(10000)	--output from kmeans
) NO PRIMARY INDEX;

--Run for various K
DELETE FROM test_db.mt_kmeans_withinness;

CALL test_db.cluster_sum_error_squared('Initial Test K = 1','test_db','mt_household_power_consumption',1);
CALL test_db.cluster_sum_error_squared('Initial Test K = 2','test_db','mt_household_power_consumption',2);
CALL test_db.cluster_sum_error_squared('Initial Test K = 3','test_db','mt_household_power_consumption',3);
CALL test_db.cluster_sum_error_squared('Initial Test K = 4','test_db','mt_household_power_consumption',4);
CALL test_db.cluster_sum_error_squared('Initial Test K = 5','test_db','mt_household_power_consumption',5);
CALL test_db.cluster_sum_error_squared('Initial Test K = 6','test_db','mt_household_power_consumption',6);
CALL test_db.cluster_sum_error_squared('Initial Test K = 7','test_db','mt_household_power_consumption',7);
CALL test_db.cluster_sum_error_squared('Initial Test K = 8','test_db','mt_household_power_consumption',8);
CALL test_db.cluster_sum_error_squared('Initial Test K = 9','test_db','mt_household_power_consumption',9);
CALL test_db.cluster_sum_error_squared('Initial Test K = 10','test_db','mt_household_power_consumption',10);

SELECT * FROM test_db.mt_kmeans_withinness

--Look at withinness of each cluster
WITH TSES AS (
	SELECT 
		run_id
		, number_of_clusters
		, covergence_info
		, SUM(withinness) AS total_withinness
	FROM test_db.mt_kmeans_withinness
	GROUP BY 1,2,3
)
SELECT 
	A.run_id
	,A.number_of_clusters
	,A.total_withinness
	,A.total_withinness / B.total_withinness as improvement
	,A.covergence_info
FROM TSES AS A
LEFT OUTER JOIN TSES AS B
	ON A.number_of_clusters = B.number_of_clusters + 1
ORDER BY A.number_of_clusters

--run_id				number_of_clusters	total_withinness	improvement
--Initial Test K = 1	1					1959417.7424		null
--Initial Test K = 2	2					1154822.9925		0.5894
--Initial Test K = 3	3					779852.5520			0.6753
--Initial Test K = 4	4					351525.9869			0.4508
--Initial Test K = 5	5					303204.2756			0.8625
--Initial Test K = 6	6					284086.6847			0.9369
--Initial Test K = 7	7					263506.9589			0.9276
--Initial Test K = 8	8					245786.6623			0.9328
--Initial Test K = 9	9					263443.5268			1.0718
--Initial Test K = 10	10					204543.7955			0.7764

/*Four Clusters looks like the way to go*/
