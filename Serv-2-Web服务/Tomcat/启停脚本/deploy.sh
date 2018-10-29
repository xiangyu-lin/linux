#!/bin/bash
#war format:wars/portal-1.0.0.2.war     path/project-Version.war
#new format:/caapp/azt/wars/20170712/portal/8903
#war location: $WARS

#define servers

#make sure you are in a right environment & execute a right script
#ProjectName="FjDX"
. $sc_pa/common
#define WAR location
#WARS="/home/tomcat/war"

#get login username
#me=`whoami`

SPECIAL_CATALINA_HOME="~Nothing can be found~"
#init parameters
VERSION=""
SERVICES=""
PORTS=""
HAS=""


#uploads
uploads(){
	SOURCE="$WARS/$VERSION"
	echo -e "===================================`date`========================================\n"
	echo -e "\033[42;37mDeploying '$SERVICES' to server ...\033[0m"
	ws=$SOURCE/$SERVICES.war
echo "$ws"
	if [ -f "$ws" ] && [ -n "$(stat $ws | grep "regular file")" ]; then
		echo -e "removing unpacked war $SPECIAL_CATALINA_HOME/webapps/$SERVICES.war"
		/bin/rm -rf $SPECIAL_CATALINA_HOME/webapps/$SERVICES.war
		echo -e "====>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "making link : $SPECIAL_CATALINA_HOME/webapps/$SERVICES.war -> $SOURCE/$SERVICES.war "
		/bin/ln -sf $SOURCE/$SERVICES.war $SPECIAL_CATALINA_HOME/webapps/$SERVICES.war
		echo -e "====>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	else
		echo -e "\033[36;41m$ws:No such file ...\033[0m"
		echo -e "\033[36;41m$ws:ignore,please cheak later ...\033[0m"
	fi
	echo -e "\033[42;37m==========>$1 : $SPECIAL_CATALINA_HOME/webapps/$SERVICES.war done\033[0m"
	echo -e "\n===========================================================================================\n"
}

#setEnv version [WEBNAME]
setEnv(){
	VERSION=$2
        length=${#AL[@]}
        for ((i=0;i<length;i++))
        do
                p=${AL[i]}
                name=`echo $p | cut -d ':' -f1`
                if [[ "$1" = "$name" ]];then
                        SPECIAL_CATALINA_HOME=`echo $p | cut -d ':' -f2 `
						SERVICES=`echo $p | cut -d ':' -f1 | tr -cd "[a-z]"`
						PORTS=`echo $p | cut -d ':' -f1 | tr -cd "[0-9]"`
                fi
        done
        if [[ "$SPECIAL_CATALINA_HOME" = "~Nothing can be found~" ]];then
                Usage
        fi
}

case $# in
	2) 	setEnv $2 $1
		uploads
	;;
    *) Usages;;
esac
