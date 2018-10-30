#!/bin/bash

. /home/saferycom/scripts/common

healthcheckALL(){
	    length=${#AL[@]}
        for ((i=0;i<length;i++))
        do
                p=${AL[i]}
                name=`echo $p | cut -d ':' -f1`
				/home/saferycom/scripts/healthcheck.sh $name
        done
}


case $# in 
0) healthcheckALL
   ;;
*) echo "what do you mean?"
   Usage
   ;;
esac

