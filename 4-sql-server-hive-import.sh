#!/bin/bash

# Importing a table from SQL Server to HIVE

# https://stackoverflow.com/questions/66884281/importing-data-from-sql-server-to-hive-using-sqoop
# https://stackoverflow.com/questions/66871467/how-to-connect-import-data-from-sql-server-to-hdfs-using-sqoop-via-docker-contai

# Clean Up Operations
sudo -u hdfs hive -e 'DROP DATABASE IF EXISTS AdventureWorks2019;'
hdfs dfs -rm -r /user/hive/warehouse/AdventureWorks2019.db
unset tblList
unset sqoopCmd
rm *.java
rm *.log

sudo -u hdfs hive -e 'CREATE DATABASE AdventureWorks2019;'
sudo -u hdfs hive -e 'SHOW databases;'



# Import Table: AdventureWorks2019.Production.TransactionHistory
sudo -u hdfs sqoop import  \
-Dorg.apache.sqoop.splitter.allow_text_splitter=true  \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW  \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver  \
--warehouse-dir "/user/hive/warehouse/AdventureWorks2019.db"  \
--hive-import  \
--fields-terminated-by ',' \
--hive-table AdventureWorks2019.TransactionHistory  \
--table Production.TransactionHistory  \
--split-by TransactionID  \
-- --schema Production

# Import Table: AdventureWorks2019.Sales.SalesOrderDetail
sudo -u hdfs sqoop import  \
-Dorg.apache.sqoop.splitter.allow_text_splitter=true  \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;  databaseName=AdventureWorks2019"  \
--username sa  \
--password MY_MS_SQL_PW  \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver  \
--warehouse-dir "/user/hive/warehouse/AdventureWorks2019.db"  \
--hive-import  \
--fields-terminated-by ',' \
--hive-table AdventureWorks2019.SalesOrderDetail  \
--table Sales.SalesOrderDetail  \
--split-by SalesOrderID  \
-- --schema Sales