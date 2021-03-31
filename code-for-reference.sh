#!/bin/bash


sudo -u hdfs sqoop import  \
-Dorg.apache.sqoop.splitter.allow_text_splitter=true  \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW  \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver  \
--warehouse-dir "/user/hive/warehouse/AdventureWorks2019.db"  \
--hive-import  \
--create-hive-table  \
--fields-terminated-by ',' \
--hive-table AdventureWorks2019.Production.TransactionHistory  \
--table Production.TransactionHistory  \
--split-by TransactionID  \
-- --schema Production



# Import SOME the AdventureWorks2019 database tables from SQL SERVER to Hive

# Setting up the Hive Database

# STEP 1
# Create a database named AdventureWorks2019 in hive (verify on HDFS)
sudo -u hdfs hive -e 'CREATE DATABASE AdventureWorks2019;'

# STEP 2
# Prepare a variable (array) to hold some AdventureWorks2019 tables in a OS variable

tblList=("Production.TransactionHistory")
echo ${tblList[@]}
for tbl in ${tblList[@]}; do echo $tbl; done



# STEP 3
# Prepare a variable to hold the SQOOP command to run dynamically with the $tblList variable

sqoopCmd='sudo -u hdfs sqoop import
-Dorg.apache.sqoop.splitter.allow_text_splitter=true
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;databaseName=AdventureWorks2019"
--username sa
--password MY_MS_SQL_PW
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver
--warehouse-dir "/user/hive/warehouse/AdventureWorks2019.db"
--hive-import
--create-hive-table
--hive-table AdventureWorks2019.$tbl
--table $tbl
--split-by TransactionID'



--autoreset-to-one-mapper


# STEP 4
# (Run the process using for loop and capture all process lines to a log file for each table (stdout + stderr)

for tbl in ${tblList[@]}; do eval $sqoopCmd 2>&1 | tee ./sqoop_$tbl.log; done

# ERROR tool.ImportTool: Import failed: No primary key could be found for table Production.TransactionHistory. Please specify one with --split-by or perform a sequential import with '-m 1'


# Clean up and start again
sudo -u hdfs hive -e 'DROP DATABASE IF EXISTS AdventureWorks2019;'
unset tblList
unset sqoopCmd
rm *.java
rm *.log
hdfs dfs -rm -r /user/hive/warehouse/AdventureWorks2019.db

# To Check for database
hdfs dfs -ls /user/hive/warehouse/
# STEP 5
# Connect to CM and open the YARN Application screen (CM > Clusters > YARN Applications)
    # Monitor the process progress (you may need to refresh the web page between iterations)


# STEP 6
# Verify that all tables were imported into Hive classicmodels database with Hue / HDFS
    # Using HUE GUI
    sudo -u hdfs hive -e 'show tables in AdventureWorks2019' 
    

    # Are there any tables missing? NO
    # Check for errors in the log file
    cat ./sqoop*.log | grep ERROR -a5 -b5

