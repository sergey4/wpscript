#!/bin/bash
# TODO: deny access to .git dirs via .htaccess
#HOME=/root
MYSQL="/usr/bin/mysql -u root"
PHP=/usr/bin/php
GIT=/usr/bin/git

# parameters: $1 - database, $2 - user, $3 - password
create_database(){
	echo "create database $1; grant all privileges on $1.* to '$2'@'localhost' identified by '$3'; flush privileges;" | $MYSQL
}


# parameters: $1 - database
database_exists(){
	echo "use $1;" | $MYSQL 
	return $?
}



genpasswd() {
    local l=$1
    [ "$l" == "" ] && l=16
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l}
}

#print_usage(){
#	echo "Usage: install_wp.sh <project_name>"
#	exit 1
#}

# parameters: $1 - project name, $2 - type ('dev' or 'uat')
normalize_db_name(){
	echo -n $1 | tr \. _
	echo _wp_$2
}

# parameters: $1 - project name, $2 - type ('dev' or 'uat')
# cuts to fit 16 character limit
normalize_db_user(){
	local NAME1=`echo -n $1 | tr \. _ | cut -c-12`
	echo $NAME1'_'$2
}



# check that script can connect to mysql as root
# very simplified check - just compares username
# More "advanced" option is do "SHOW GRANTS" and look for "GRANT ALL PRIVILEGES ON *.*"
check_mysql_access(){
	echo "Checking mysql access..."
	echo "select user();" | $MYSQL | grep 'root@localhost'
	if [ $? -ne 0 ]; 
	then
		echo "Error: script can't connect to mysql / don't have mysql root privileges. Edit globals.sh and try again"	
		exit 1
	fi
	return
}

# check that binary exists
# parameters: $1 - full path to binary, $2 - binary "human name"
check_binary(){
	echo -n "Checking that $2 is installed: "
   if [ -x $1 ];
   then
	echo "yes"	
   else
	echo "not found!"
	exit 1
   fi
}

# checks that all required tools/utilities are installed
check_prerequisites(){
	echo "Checking required tools and prerequisites..."
   local TOOLS_OK=false
	check_binary /usr/bin/curl "CURL"
	check_binary "$PHP" "Command-line php"
	check_binary "$GIT" "Git"
	check_mysql_access
	echo "### Check completed ###"
}

# parameters: $1 - document root dir
set_wp_chmod(){
	# echo set appropriate chmod for upload dirs
	[ -z "$1" ] && [ ! -d "$1" ] && echo "set_wp_chmod: ERROR: Docroot not set/incorrect" && exit 1
	[ ! -d "$1/wp-content/uploads" ] && mkdir $1/wp-content/uploads
#	this operation requires root privileges...
#	chgrp $APACHE_USER $1/wp-content/uploads
	chmod 777 $1/wp-content/uploads

}
#
#if [ $# -ne 1 ];
#then
#	print_usage
#fi

##### checks #####
check_prerequisites

###### create database #####
#DBPASS=`genpasswd 10`
#DBNAME=`normalize_db_name $1`
#DBUSER=$DBNAME
#
#if database_exists $DBNAME; then
#  echo "DB $DBNAME already exists, skipping..."
#else
#  echo "DB $DBNAME doesn't exist, creating..."
#  create_database "$DBUSER" "$DBNAME" "$DBPASS"
#fi
#
##### install wordpress #####



##### add to git #####

