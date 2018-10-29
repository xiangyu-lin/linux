#!/bin/sh
. $sc_pa/common

for ((i=0;i<${#AL[@]};i++))
do
 serv=$(echo "${AL[$i]}"|cut -d ":" -f2)
 echo -e "\033[30;1;33m`ls --full-time $serv/webapps|grep -v "total"|grep "^l"`\033[0m"
 echo
done
