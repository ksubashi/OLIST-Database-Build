# OLIST-Database-Build
## Installation
For this exercise, you will need to install on your local computer:
* SQL Server
* SQL Server Management Studio
* SQL Server Integration Services

You will also need to download Visual Studio as it will be the software where we are going to build the ETL Pipeline through SSIS.

## Project Overview
The data set on which you are going to work on is from Olist, the largest department store in 
Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without 
hassle and with a single contract. Those merchants are able to sell their products through the Olist 
Store and ship them directly to the customers using Olist logistics partners. There are 9 source csv 
files:
* olist_customers_dataset.csv
* olist_geolocation_dataset.csv
* olist_orders_dataset.csv
* olist_order_items_dataset.csv
* olist_order_payments_dataset.csv
* olist_order_reviews_dataset.csv
* olist_products_dataset.csv
* olist_sellers_dataset.csv
* product_category_name_translation.csv

This data set has been retrieved from kaggle.com -https://www.kaggle.com/olistbr/brazilianecommerce?select=olist_orders_dataset.csv (Olist and Sionek 2018) and it is protected by a 
Creative Commons licence - CC BY-NC-SA 4.0. This means that the data set can only be used for 
the purpose of this exercise in the context of data analysis and nothing more. Please refer to the 
license summary - https://creativecommons.org/licenses/by-nc-sa/4.0/.
Please download the files on your local computer from the URL provided in the previous paragraph 
and in there you can find detailed description of the data sources and the relationship between 
them

## Problem Statement
There are three main objectives to complete this task:
* Build the Source DB
* Build the DWH
* Create a stored procedure and schedule it through a job to run automatically at 10:00 am.

## Implementation and Solution
First of all I have created a database which will serve as a stage layer schema where all the data in the csv above will be stored as they are into tables with some minor transformations. After I have created all tables in this stage DB where the scripts for creating this tables can be found above in the files. After I have created another Database which will serve as the Data Warehouse for analytical and querying purposes. Scripts for creating tables in this layer may be found also above. Tables here will be stored in facts and dimensions and of course we have to define constraints like primary keys and foreign keys. As long as this layer of database will be used for analytical purposes we need to ensure its integrity, maintaining uniqueness in tables, automatic indexing and preventing duplicates. I have also created a dimension called calendar. The reason for that is for optimizing queries, by indexing delivery_day_id column (we index columns which we can later join or use in where conditions) we inner join with calendar date and we can play safer in where conditions as the quereies will be executed faster. 

Now in Visual Studio, we create a new SSIS Project where we can build the ETL Pipeline. I have in overall 5 steps in ETL Pipeline, 2 Execute SQL Task and 3 Data Flow task. 
I start first with Exectuing the first SQL Task, where I truncate all tables in stage layer. The reason why is that whenever I execute the ETL, we do not insert data multiple times and end up in duplicate values.
So first we connect with stage db and execute truncate table for all stage tables.
After I have created a data flow task, in which I connect with all csv files. 9 sources assitans used for 9 csv's and 9 destinations for 9 tables that we created in stage layer. During the extraction we do some transformations like replacing quotation marks in columns that might have quotations and blank cells in columns that have int datatype replacing with nulls. After we do some data types conversion so the extracted columns have the same data type as columns in destination. These two steps identify the ETL for loading data into stage layer.

After this Data Flow task we create another SQL task where we perform a deletion of all rows in Production / Data Warehouse tables. Same reason , we do not want to insert duplicate values each time we exectue the ETL procedure. This time we must be careful, we must delete rows from fact table before dimensions because it may raise an error which comes from foreign key constraints. The reason is that we must not have ids which are foreign keys in fact that do not exists in our dimension tables. 
After deleting all rows in production layer tables, we insert tables in dimension using as source the stage layer tables that we populated before by running sql scripts commnads. For customers,sellers and products we do it the same. After create another data flow task for loading rows in fact table using the same way, from stage layer tables with sql commands loading data into fact table in production layer.
The same reason stands for loading dimensions before fact.

After we have all the data set and ready in production we have created the stored procedure with two variables current year and previous year to get a YoY comparison for product revenue,shipping revenue and average review score by customer and sellers state.

After creating the stored procedure, we create a job which executes the stored procedure by giving variables a value and using EXEC command in sql command seciotn. Scheduled in 10:00 am daily.

