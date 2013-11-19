#!/bin/bash
#HOME=/root
MYSQL="/usr/bin/mysql -u root"
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

print_usage(){
	echo "Usage: install_wp.sh <project_name>"
	exit 1
}

# parameters: $1 - domain name
normalize_db_name(){
	echo $1 | tr \. _
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

# checks that all required tools/utilities are installed
check_prerequisites(){
	echo -n "Checking required tools (curl etc)... "
   local TOOLS_OK=false
   if [ -x /usr/bin/curl ];
   then
	echo "OK!"	
   else
	echo "Failed!"
	exit 1
   fi
	check_mysql_access
}

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

