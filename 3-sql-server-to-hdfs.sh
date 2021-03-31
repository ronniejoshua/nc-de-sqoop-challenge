#!/bin/bash


# Importing a table from SQL Server to HDFS

# HDFS clean up
hdfs dfs -rm -r /user/sqoop/warehouse/AdventureWorks2019.db
rm *.java


# Command to import data from SQL Server to HDFS
sudo -u hdfs sqoop import  \
-Dorg.apache.sqoop.splitter.allow_text_splitter=true  \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW  \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver  \
--warehouse-dir "/user/sqoop/warehouse/AdventureWorks2019.db"  \
--table Production.TransactionHistory  \
--split-by TransactionID  \
-- --schema Production


# Validate
hdfs dfs -ls /user/sqoop/warehouse/AdventureWorks2019.db/Production.TransactionHistory


# Command to import data from SQL Server to HDFS
sudo -u hdfs sqoop import  \
-Dorg.apache.sqoop.splitter.allow_text_splitter=true  \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW  \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver  \
--warehouse-dir "/user/sqoop/warehouse/AdventureWorks2019.db"  \
--table Sales.SalesOrderDetail  \
--split-by SalesOrderID  \
-- --schema Sales


# Run SQL query using Sqoop (eval)
# Query is ran against the sql server db hosted on localhost

sqoop eval \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW \
--query "SELECT TOP 5 TransactionID FROM Production.TransactionHistory"

