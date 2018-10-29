#!/bin/sh
pa=("/home/tomcat/rpc-19083/conf/context.xml" "/home/tomcat/sfs-19084/conf/context.xml")
user=tomcat
chapasswd(){
process=`ps -ef|grep java|grep -v "job"|grep $user|head -n -1|cut -d " " -f1`
if [[ "$process" == "" ]];then
	for ((i=0;i<${#pa[@]};i++))
		do
			local_ip=`ifconfig|grep "inet addr"|grep -v "127"|cut -d ":" -f2|cut -d " " -f1`
			echo "now start change password to ${pa[i]} for $local_ip"
			sum=0
			p=`cat ${pa[i]}|grep password|wc -l`
                        for j in `cat ${pa[i]}|grep password|cut -d '"' -f2`
				do
					if [[ "$1" == "$j" ]];then
						n="haha"
				       	
					else
						echo "the old password is wrong!"
						exit
					fi
				done
                sed -i "s/password=\"$1\"/password=\"$2\"/g" ${pa[i]}
			for m in `cat ${pa[i]}|grep password|cut -d '"' -f2`
				do
					if [[ "$m" == "$2" ]];then
						sum=$(($sum+1))
					else
						echo "The password change failed, do not start the web service, please check the password first!"
						exit
                                        fi
				done
			if [[ "$sum" == "$p" ]];then
				echo "the password has been changed!"
			fi
		cat ${pa[i]}|grep -A 1 username|grep -v "\--"

		done
else
	echo " The java process is still running in `/sbin/ifconfig|grep "inet addr"|grep -v "127"|cut -d ":" -f2|cut -d " " -f1` and do not modify the password!"
fi
}
case $# in
2)
	chapasswd $1 $2
;;
*)
	echo "wrong!"
        exit
;;
esac
