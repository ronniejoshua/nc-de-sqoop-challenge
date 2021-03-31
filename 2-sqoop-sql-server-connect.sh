#!/bin/bash

# SQOOP USER GUIDE
# https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html


# Setting up SQOOP for interacting with SQL Server
# ------------------------------------------------
# Here we use curl, before we used wget
# https://www.digitalocean.com/community/tutorials/workflow-downloading-files-curl

# Sqoop requires a JDBC connector jar files to interact with the database
# https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server
# https://docs.cloudera.com/documentation/enterprise/5-9-x/topics/cdh_ig_jdbc_driver_install.html


# Download the Microsoft SQL Server JDBC driver from and copy it to the /var/lib/sqoop/ directory. 
# Use the following command from inside /var/lib/sqoop/

# Method 1
# Because it is a redirect link first check the header to find the redirect url
curl -I https://go.microsoft.com/fwlink/?linkid=2155949

# Use curl on the located file
curl https://download.microsoft.com/download/4/c/3/4c31fbc1-62cc-4a0b-932a-b38ca31cd410/sqljdbc_9.2.1.0_enu.tar.gz


# unzip and un-archive the file
sudo gzip -d sqljdbc_9.2.1.0_enu.tar.gz
sudo tar -xf sqljdbc_9.2.1.0_enu.tar

# copy the following jar file to /var/lib/sqoop/
sudo cp sqljdbc_9.2/enu/mssql-jdbc-9.2.1.jre8.jar .


# Method 2 [does the same thing but using other command options]
sudo curl -L -o sqljdbc_9.2.1.0_enu.tar.gz https://go.microsoft.com/fwlink/?linkid=2155949 | tar -xz



# -------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------



# Connecting SQOOP to SQL Server

# References
# https://medium.com/@achir.youssef97/a-step-by-step-guide-for-loading-oracle-data-into-hadoop-using-docker-containers-c4bc5c0cb3d2

# https://sqoop.apache.org/docs/1.4.6/SqoopUserGuide.html#_connecting_to_a_database_server

# for what goes into the -- driver use the following reference
# https://stackoverflow.com/questions/19597328/sqoop-sqlserver-failed-to-load-driver-appropriate-connection-manager-is-not-be


# This is the key
# 172.18.0.3 : This is the SQL Server container’s IP Address 
# (By default every docker container newly set up is connected to the same bridge network.)
# To find out the ip address of the container use
docker inspect <docker-container-id>


# Testing if the connection works 
sqoop list-tables \
--connect "jdbc:sqlserver://172.18.0.3:1433;instanceName=data-engr-sql-svr;databaseName=AdventureWorks2019" \
--driver com.microsoft.sqlserver.jdbc.SQLServerDriver \
--username sa \
--password MY_MS_SQL_PW

