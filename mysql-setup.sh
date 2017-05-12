#!/bin/bash

# Check if the database is configured
#####################################

function configure_database() {
# Give me a moment before I begin....
sleep 30

echo "START CONFIGURATION PROCESS" >>/supervisord.log

if [ ! -f "/database_configured" ]; then 

		# Stop the database if it's running
		echo "Stopping MysQL" >>/supervisord.log
		/etc/init.d/mysql stop
		
		echo "Going to Execute MySql With Skip Grant Tables" >>/supervisord.log
		sleep 4

		/usr/bin/mysqld_safe --skip-grant-tables &
		sleep 4

		echo "Going to Execute the SQL File to Set Perm For Root" >>/supervisord.log
		/usr/bin/mysql < /tmp/mysql-script.sql
		echo "done" >>/supervisord.log

		echo "Going to Start Mysql" >>/supervisord.log
		# Stop the process running with --skip-grant-tables
	
		/etc/init.d/mysql stop
		sleep 2

		# Start the service with new configuration
		/etc/init.d/mysql start

		#Create the control file so it's not configured again next time 
		# the container is started.
		echo "Creating Control File" >>/supervisord.log
		touch /database_configured

		echo "Done..."
else
		echo "Database Already Configured.." >>/supervisord.log

fi

}

# Import data into database.
function import_data() {

   # Create a temp directory
   mkdir /tmp/importdb
   cd /tmp/importdb

   # Clone the repo
   git clone https://github.com/datacharmer/test_db 

   # Import the data
   cd /tmp/importdb/test_db
   mysql -uroot -ppassword  < employees.sql

}


#### Main #####
configure_database
import_data


