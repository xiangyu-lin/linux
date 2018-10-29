#!/bin/bash

. $sc_pa/common

oper(){
	    length=${#AL[@]}
        for ((i=0;i<length;i++))
        do
                p=${AL[i]}
                name=`echo $p | cut -d ':' -f1`
				$scripts_pa/stop.sh $name
        done
}

case $# in 
0) oper
   ;;
*) echo "what do you mean?"
   echo "eg.. $0"
   ;;
esac


