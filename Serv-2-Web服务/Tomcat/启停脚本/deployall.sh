#!/bin/bash

. $sc_pa/common

deployALL(){
	    length=${#AL[@]}
        for ((i=0;i<length;i++))
        do
                p=${AL[i]}
                name=`echo $p | cut -d ':' -f1`
				$scripts_pa/deploy.sh $1 $name
        done
}


case $# in 
1) deployALL $1
   ;;
*) echo "what do you mean?"
   echo "$0 VERSION"
   echo "eg. $0 20171128"
   ;;
esac

