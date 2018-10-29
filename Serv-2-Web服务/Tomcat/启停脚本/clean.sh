#!/bin/bash

. $sc_pa/common

cleantomcat(){
	if gettomcat >/dev/null ;then
		echo "$1 is still working!!!"
		exit
	fi

echo "now cleaning  $SPECIAL_CATALINA_HOME useless file(s)..."
#mv    $SPECIAL_CATALINA_HOME/logs/catalina.out $SPECIAL_CATALINA_HOME/logs/tomcat.out.`date +%F-%H%M%S`
#rm -f $SPECIAL_CATALINA_HOME/logs/catalina.*
#>     $SPECIAL_CATALINA_HOME/logs/catalina.out
find  $SPECIAL_CATALINA_HOME/webapps -maxdepth 1 -mindepth 1 -not -name '*.war' -exec rm -rf {} \;
if [ -d $SPECIAL_CATALINA_HOME/secured ]; then
find  $SPECIAL_CATALINA_HOME/secured -maxdepth 1 -mindepth 1 -type d -not -name '*.war' -exec rm -rf {} \;
fi
find  $SPECIAL_CATALINA_HOME/work -maxdepth 1 -mindepth 1 -exec rm -rf {} \;
}

case $# in 
1) setENV $1
   cleantomcat $1
   ;;
*) echo "what do you mean?"
   Usage
   ;;
esac
