#!/bin/bash

. /home/saferycom/scripts/common

#init parameters
SERVICES=""
PORTS=""

healthcheck(){
	echo "Getting http://134.130.22.123:$PORTS/$SERVICES/health/check"
	curl --connect-timeout 10 -m 10 "http://134.130.22.123:$PORTS/$SERVICES/health/check"
	echo
}
setEnv(){
        length=${#AL[@]}
        for ((i=0;i<length;i++))
        do
                p=${AL[i]}
                name=`echo $p | cut -d ':' -f1`
                if [[ "$1" = "$name" ]];then
                        SPECIAL_CATALINA_HOME=`echo $p | cut -d ':' -f2 `
						SERVICES=`echo $p | cut -d ':' -f1 | tr -cd "[a-z]"`
						PORTS=`echo $p | cut -d ':' -f1 | tr -cd "[0-9]"`
						case $SERVICES in
						"portal") SERVICES="portal";;
						"signature") SERVICES="signature";;
                                                "rpc") SERVICES="rpc";;
                                                "sfs") SERVICES="sfs";;
                                                "saferycom") SERVICES="saferycom";;
                                                "job") SERVICES="job";;
								
						*)	echo "scripts runs error!!! I don't know $SERVICES ???"
							exit
							;;
						esac
						case $PORTS in
						19081 | 19082 | 19083 | 19084 | 19085 | 19086 ) ;;
						*)	echo "scripts runs error!!! I don't know $PORTS ???"
							exit
							;;
						esac
                        break
                fi
        done
        if [[ "$SPECIAL_CATALINA_HOME" = "~Nothing can be found~" ]];then
                Usage
        fi
}

case $# in 
1) setEnv $1
	healthcheck
   ;;
*) echo "what do you mean?"
   Usage
   ;;
esac

