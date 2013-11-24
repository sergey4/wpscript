#!/bin/sh
# TODO: dir-independent
# currently it is assumed that your run this script from "wpscript" dir and
# your WP installation dir is one level up ( "cd .." )
. ./globals.sh
if [ -f "../wp-config.php" ];
then
	# get newest version from repo
	echo "Pulling changes from git repo..."
	cd ..
	git pull origin
	[ $? -ne 0 ] && echo "Errors during fetch, exiting... Fix errors and run again." && exit 1
	set_wp_chmod .
	# check / create database
#	this line is unusable, because if db doesn't exist it will give 'db connection error' page
#	UAT_DBNAME=`$PHP -r "include('wp-config.php');print DB_NAME;"`
	# That is not bulletproof by any means, but ok for a start
	UAT_DBNAME=`grep DB_NAME wp-config.php | head -n 1 | cut -d\' -f4`

	if [ -n "$UAT_DBNAME" ] && database_exists "$UAT_DBNAME"; 
	then
		echo "MySQL database '$UAT_DBNAME' exists, skipping..."	
		echo "You have to manually sync it if needed"
		exit 0
	else
		echo "MySQL database '$UAT_DBNAME' not found, creating..."
		UAT_DBUSER=`grep DB_USER wp-config.php | head -n 1 | cut -d\' -f4`
		UAT_DBPASS=`grep DB_PASSWORD wp-config.php | head -n 1 | cut -d\' -f4`
		#UAT_DBUSER=`$PHP -r "include('wp-config.php');print DB_USER;"`
		#UAT_DBPASS=`$PHP -r "include('wp-config.php');print DB_PASSWORD;"`
		create_database "$UAT_DBNAME" "$UAT_DBUSER" "$UAT_DBPASS"			
		if database_exists "$UAT_DBNAME"; 
		then
			echo "#### Database successfully created.  ####"
			echo "#### Open uat site in browser, and do installation steps ####"
		else
			echo "Error creating database!"
			exit 1
		fi
	fi
else
	echo "Error: wp-config.php not found - WP not installed properly?"
	exit 1
fi
