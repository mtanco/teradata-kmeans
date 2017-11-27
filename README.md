# teradata-kmeans
Dynamically calculate the sum of error squared for each cluster based on the output of the Teradata K-Means UDF.

A User Defined Function to run K-Means in Teradata can be found here: https://developer.teradata.com/extensibility/articles/implementing-a-multiple-input-stream-teradata-15-0-table-operator-for-k-means

A clustering test data set can be found here: [test](https://archive.ics.uci.edu/ml/machine-learning-databases/00235/)

[Prepare Demo Datasets](test_data_set_up.sql): create the base table for test data set loading and for cleansing and sampling this data set

[Withinness Stored Procedure](sum_error_squared_sp.sql): stored procedure code for calculating the sum of error squared in each cluster

[Demo](run_and_interpret_results.sql): sample of how to use the stored procedure on our sample data set
