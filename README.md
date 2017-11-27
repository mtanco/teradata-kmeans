# Teradata K-Means - Calculate Cluster Withinness

Clustering can be in done in Teradatabe using the K-Means UDF. This function requires knowing a value of k. In this project we calculate the withinness of a cluster: The sum of the squared distance between each item and its cluster centroid. This can be done for various k and then plotted to observe the elbow effect of where withinness stops drastically decreasing as we add clusters. This allows for choosing a value for K. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

* The Teradata K-Means UDF which can be downloaded [here](https://developer.teradata.com/extensibility/articles/implementing-a-multiple-input-stream-teradata-15-0-table-operator-for-k-means)
* Details and testing examples on the k-means function can be found [here](http://developer.teradata.com/extensibility/articles/k-means-clustering-and-teradata-14-10-table-operators-0)

### Installing

Use Teradata Studio, SQL Assistant, BTEQ, or another SQL interface tool to install the stored procedure by running [this replace statement](sum_error_squared_sp.sql) while connected to a Teradata system. You must have create procedure permissions. 

## Testing the Stored Procedure

Download [this sample dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00235/) to run the sample demos.

1. Load this data set to Teradata using Teradata Studio or FastLoad
2. [Prepare a sample of this data by formatting nulls and alterning data types](test_data_set_up.sql)
3. [Run the procedure for various values of K to see the decrease in withinness](run_and_interpret_results.sql)
4. Use excel (or an equivalent) to plot withinness as a line chart and more easily see the elbow effect 
5. Choose a value of K for your clustering model

## Authors

* [**Michelle Tanco**](https://github.com/mtanco) - *Initial work* - 

## Acknowledgments

* Props to [Mike Watzke](http://downloads.teradata.com/user/watzke) for work on the K-Means UDF


