#!/bin/bash

. $sc_pa/common

starttomcat(){
	if gettomcat >/dev/null;then
		echo "$1 is  still working!!!"
		exit
	fi
	echo "Exec $SPECIAL_CATALINA_HOME/bin/startup.sh..."
	sh $SPECIAL_CATALINA_HOME/bin/startup.sh > /dev/null 2>&1
}

case $# in 
1) setENV $1
   starttomcat $1
   ;;
*) echo "what do you mean?"
   Usage
   ;;
esac
