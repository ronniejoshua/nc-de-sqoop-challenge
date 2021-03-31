#!/bin/bash

# Step 1 Installing SQL Server using docker
# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker
sudo docker pull mcr.microsoft.com/mssql/server:2019-latest

# Step 2 Running the SQL Sever Docker container
# Make sure to use --network[Objective is to use the same network as de-course-vm]
# Run the docker container 
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=MY_MS_SQL_PW" \
   -p 1433:1433 --name data-engr-sql-svr -h data-engr-sql-svr \
   --network nc-de-network \
   -d mcr.microsoft.com/mssql/server:2019-latest

   
# Step 3
# Don't foget to add PORT 1433 add this port to the Google Compute Engine Firewall Rules


# Step 4 Setting up the database

# How to install wget
sudo yum search wget
sudo yum install wget

# Installing wget to download files from the internet
sudo yum install wget

# Download AdventureWorks2019.bak
wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak


# Placing the downloaded bak file into docker contianer running mssql server
sudo docker cp /home/ron_juden/AdventureWorks2019.bak data-engr-sql-svr:/var/opt/mssql/data/


# Step 5
# Restore the database
# I used the Azure data studio to restore the data
# It is very simple


# Other Information on SQL Server - Docker Container

# Persisting the data
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-configure?view=sql-server-ver15&pivots=cs1-bash#persist
