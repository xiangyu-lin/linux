#!/bin/bash

. $sc_pa/common

#most time to wait until tomcat died
WAIT=16

#$1 = wait seconds
waittomcatdie() {
	w=$1
	while [ $w -gt 0 ] >/dev/null && gettomcat >/dev/null ; do
		echo -n '.'
		w=`expr $w - 1`
		sleep 1
	done
	unset w
}

quietly() {
	echo "$SPECIAL_CATALINA_HOME/bin/shutdown.sh"
	sh $SPECIAL_CATALINA_HOME/bin/shutdown.sh > /dev/null 2>&1
	waittomcatdie $WAIT
	killme
}

killme(){
if gettomcat >/dev/null;then
	echo -n " killing "
	gettomcat|gawk '{print $2}' | xargs -n 1 kill
	waittomcatdie 1024
fi
echo
}		

case $# in
1) setENV $1
   quietly
   ;;
*) echo "what do you mean?"
   Usage
   ;;
esac
