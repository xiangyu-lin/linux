#!/bin/bash
#所有边缘设备初始化
#

# ------function-----------
function f_check {
	echo "正在检查各项配置文件............................................."
	echo
	sleep 2
	#检查同步日志
	tail -n 1 /var/log/trafficserver/sync.log  |grep -E '(get list success|sync success)' &> /dev/null
	if [ $? -eq 0 ];then
		echo -e "/var/log/trafficserver/sync.log		  \e[1;42m正常\e[0m"
	else
		echo -e "/var/log/trafficserver/sync.log		  \e[1;31m异常\e[0m "
	fi

	#检查 /etc/trafficserver/records.config
	linerecords=$(cat /etc/trafficserver/records.config | wc -l)
	if [ $linerecords -gt 5 ];then
		echo -e "/etc/trafficserver/records.config  		  \e[1;42m正常\e[0m"
	else
		echo -e "/etc/trafficserver/records.config  		  \e[1;31m异常\e[0m	"
	fi

	#检查 /etc/trafficserver/ssl_multicert.config
	linessl=$(cat /etc/trafficserver/ssl_multicert.config |wc -l)
	if [ $linessl -gt 5 ];then
		echo -e "/etc/trafficserver/ssl_multicert.config 	  \e[1;42m正常\e[0m"
	else
		echo -e "/etc/trafficserver/ssl_multicert.config 	  \e[1;31m异常\e[0m 	"
	fi

	#检查 /etc/trafficserver/localdown/default.ini
	linedefault=$(cat /etc/trafficserver/localdown/default.ini | wc -l)
	if [ $linedefault -gt 5 ];then
	        echo -e "/etc/trafficserver/localdown/default.ini  	  \e[1;42m正常\e[0m"
	else
	        echo -e "/etc/trafficserver/localdown/default.ini 	  \e[1;31m异常\e[0m  "
	fi

	#检查 	cat /etc/trafficserver/localdown/localdown_edge.ini
	if cat /etc/trafficserver/localdown/localdown_edge.ini |grep origin &> /dev/null ;then
		echo -e "/etc/trafficserver/localdown/localdown_edge.ini  \e[1;42m正常\e[0m"
	else
	        echo -e "/etc/trafficserver/localdown/localdown_edge.ini  \e[1;31m异常\e[0m "
	fi
	#检查 /etc/trafficserver/localdown/remap.config
	lineremap=$(cat /etc/trafficserver/remap.config |wc -l)
	if [[ $lineremap -gt 10 ]];then
	        echo -e "/etc/trafficserver/remap.config  		  \e[1;42m正常\e[0m"
	else
	        echo -e "/etc/trafficserver/remap.config 		  \e[1;31m异常\e[0m 	"
	fi
	#检查 80端口
	#检查cache（diags.log）
	#检查traffic_top

}

function f_sync {
	chown nobody:nobody /etc/trafficserver/localdown/localdown_edge.ini
	echo "正在同步，请稍等................................................."
#	if echo $dev | grep '4c' > /dev/null ;then
#	echo 'regex_map http://^([a-z0-9\.\-_]+[a-z\.]$)/ http://$1 @plugin=localdown.so  @pparam=origin:127.0.0.1:8080' > /etc/trafficserver/remap.config
#	else
	echo 'regex_map http://^([a-z0-9\.\-_]+[a-z\.]$)/ http://$1 @plugin=localdown.so' > /etc/trafficserver/remap.config
#	fi

	touch -t 201212121212 /etc/trafficserver/remap.config
	touch -t 201212121212 /etc/trafficserver/logs_xml.config
	touch -t 201212121212 /etc/trafficserver/ssl_multicert.config
	sleep 2

	service trafficserver restart
	sleep 30

}

function f_nosync {
	if f_check | grep '异常' ;then
                echo "同步不成功，正在进行第2次同步，稍等........................................"
                f_sync
		sleep 30
		f_check
                if f_check | grep '异常' ;then
                        echo "同步不成功，正在第3次同步，稍等........................................"
                f_sync
		sleep 60
		fi

		f_check
		if f_check | grep '异常' ;then
			echo "同步失败！program exit.. 请到跳板机sync_conf -r 同步.................."
        		exit
		fi
	fi
	echo "初始化成功，检查服务开解析..........................................................."
}

function f_yum_ts_next {
	if [ $? -ne 0 ];then
		echo "初始化失败，可能yum源问题或者之前版本的ts未卸载，请排除以上问题重新运行此脚本....."
		exit 1
	fi

	echo
	echo "正在检查ts服务是否能正常启动..................................................."
	echo
	service trafficserver restart
	sleep 8
	pidcheck=$(pidof traffic_cop traffic_server traffic_manager | wc -w)
	if [ $pidcheck -ne 3 ];then
		echo "稍等 .............................."
		service trafficserver restart
		sleep 15
		pidcheck=$(pidof traffic_cop traffic_server traffic_manager | wc -w)
		if [ $pidcheck -ne 3 ];then
		echo "ts服务启动失败,请检查设备，手动初始化，程序退出..................................."
		exit
		fi
	fi

	echo
	echo "ts正常...请到boss上下发"
	read -p "boss 下发完成之后输入next继续:" next

	while [[ "$next" != "next" ]];do
	      read -p "确认下发完成输入next回车：" next
	done
}

function f_c111 {
	yum -y install ts ts-localdown ts-billing ts-refresh ts-config ts-verycdn ts-logput logput verydb nali knot-isp-db
	f_yum_ts_next
	sed -i '1!s/^billing/#billing/' /etc/trafficserver/plugin.config
	echo 'origin=221.228.69.36,153.35.48.69,221.131.105.25,61.160.250.73,223.68.160.48,112.82.240.201,60.191.30.252,101.71.13.190,112.17.39.78' > /etc/trafficserver/localdown/localdown_edge.ini

        f_sync
        f_check
        f_nosync

}

function f_c132 {
	yum -y install ts ts-localdown ts-billing ts-refresh ts-config ts-verycdn ts-logput logput verydb nali knot-isp-db

	f_yum_ts_next

	sed -i '1!s/^billing/#billing/' /etc/trafficserver/plugin.config
	echo 'origin=221.228.69.37,153.35.48.70,221.131.105.26,61.160.251.121,112.21.165.162,112.82.241.220,183.134.217.88,183.134.217.89,221.228.69.48,153.35.48.71,221.131.105.27,61.160.196.48,223.68.160.46,112.82.240.118,59.44.60.117,221.180.236.133,124.95.143.117,59.44.60.116,221.180.236.132,124.95.143.116' > /etc/trafficserver/localdown/localdown_edge.ini

	f_sync
	f_check
	f_nosync

}

function f_c232 {
		yum -y install ts ts-localdown ts-billing ts-refresh ts-config ts-verycdn ts-logput logput verydb nali knot-isp-db
		f_yum_ts_next
		sed -i '1!s/^billing/#billing/' /etc/trafficserver/plugin.config
		echo 'origin=61.160.249.24,219.83.160.30,223.68.160.39,221.228.69.35,153.35.48.75,221.131.105.30,61.160.250.203,112.82.240.117,219.83.160.32,221.228.69.44,153.35.48.73,221.228.69.34,153.35.48.74,221.131.105.29,61.160.250.71,112.21.165.171,112.82.240.221,61.160.245.197,112.21.165.163,112.82.223.197,221.228.69.49,153.35.48.72,221.131.105.28,183.134.217.90,183.134.217.91,59.44.60.115,124.95.143.115,221.180.236.131,59.44.60.114,124.95.143.114,221.180.236.130' > /etc/trafficserver/localdown/localdown_edge.ini

    f_sync
    f_check
    f_nosync
}

function f_c211 {
		yum -y install ts ts-localdown ts-billing ts-refresh ts-config ts-verycdn ts-logput logput verydb nali knot-isp-db
		f_yum_ts_next
		sed -i '1!s/^billing/#billing/' /etc/trafficserver/plugin.config
		echo 'origin=221.228.69.43,153.35.48.68,221.131.105.24,61.160.249.74,223.68.160.51,112.82.240.224,219.83.160.35' > /etc/trafficserver/localdown/localdown_edge.ini

		f_sync
		f_check
		f_nosync
}

function f_c311 {
  yum -y install ts ts-localdown ts-billing ts-refresh ts-config ts-verycdn ts-logput logput verydb nali knot-isp-db
  f_yum_ts_next
  sed -i '1!s/^billing/#billing/' /etc/trafficserver/plugin.config
  echo 'origin=183.134.215.9' > /etc/trafficserver/localdown/localdown_edge.ini

  f_sync
  f_check
  f_nosync

}

function f_c176 {
	echo "init start..................................................."
	echo
	sleep 1
	dnf -y install ts ts-localdown ts-verycdn
	read -p "boss 下发完成之后输入next继续:" next
	while [[ "$next" != "next" ]];do
		read -p "确认下发完成输入next回车：" next
	done
	echo "verycdn.so powerby:Powered-By-VeryCDN" > /etc/trafficserver/plugin.config
	echo -e "`ls -l /dev/sd* | grep -v sda | awk '{print $NF}'`" > /etc/trafficserver/storage.config
	echo 'origin=101.69.161.66,61.174.50.66,112.21.165.170,112.82.223.190,61.160.245.190,180.97.172.9,153.35.48.77' >/etc/trafficserver/localdown/localdown_edge.ini
	f_sync
	f_check
	f_nosync
}

function f_c14c {
	echo "以下用的运维写的的c14初始化脚本,即将开始初始化......................"
	echo
        sleep 3

	wget -q http://mts.mirrors.verycloud.cn/fedora/fedora-22.repo -O /etc/yum.repos.d/fedora.repo
	echo

	wget -O srs_init_f22.sh c13.myccdn.info/srs/srs_init_f22.sh && bash srs_init_f22.sh
	echo
	echo "改计费.............."
	echo -e "billing.so path:_billing allowip:127.0.0.1:61.160.245.54:112.82.223.54:112.82.223.198:61.160.245.198:112.82.223.197:61.160.245.197:223.68.160.40:61.160.245.199:112.82.223.199:112.21.182.2:112.21.182.4:61.160.249.70:112.82.240.134:180.153.159.98:103.245.81.194:180.153.159.99:103.245.81.195:58.215.133.194:58.215.133.195:58.215.133.213:58.215.133.214:103.242.65.103:120.195.110.194:120.195.110.205:180.97.171.210:180.97.171.211: interval:300 \nconfig.so allowip:127.0.0.1:61.160.245.54:112.82.223.54:112.82.223.198:61.160.245.198:112.82.223.197:61.160.245.197:223.68.160.40:61.160.245.199:112.82.223.199:112.21.182.2:112.21.182.4:61.160.249.70:112.82.240.134:180.153.159.98:103.245.81.194:180.153.159.99:103.245.81.195:61.160.196.33:112.82.241.220:58.215.133.194:58.215.133.195:58.215.133.213:58.215.133.214:103.242.65.103:120.195.110.194:120.195.110.205: \nverycdn.so powerby:Powered-By-VeryCDN \n#don't delete this line#" &> /etc/trafficserver/plugin.config

}

function f_c34c {
	echo "引用自:opsdocs--c34初始化脚本,即将开始初始化......................"
	echo
        sleep 2
	wget -q http://mts.mirrors.verycloud.cn/fedora/fedora-22.repo -O /etc/yum.repos.d/fedora.repo
	curl -s http://docsdata.verycdn.cn/init/srs_init_f22_c34.sh |bash
	echo
}

function f_c332 {
	echo "以下使用陈伟写的c33始化脚本，即将进入初始化.................................."
        echo
        sleep 3
	yum -y install knot-isp-db
	rm -rf /root/morefun.sh && wget http://wei.myccdn.info/cdn/morefun.sh && bash morefun.sh
	echo -e "billing.so path:_billing allowip:127.0.0.1:61.160.245.54:112.82.223.54:112.82.223.198:61.160.245.198:112.82.223.197:61.160.245.197:223.68.160.40:61.160.245.199:112.82.223.199:112.21.182.2:112.21.182.4:61.160.249.70:112.82.240.134:180.153.159.98:103.245.81.194:180.153.159.99:103.245.81.195:58.215.133.194:58.215.133.195:58.215.133.213:58.215.133.214:103.242.65.103:120.195.110.194:120.195.110.205:180.97.171.210:180.97.171.211: interval:300
verycdn.so powerby:Powered-By-VeryCDN" > /etc/trafficserver/plugin.config
	service trafficserver restart
	echo "copy同类型计费成功，初始化完成！请根据上面提示检查服务！"
}



# --↓↓↓↓---------- main program----------------------------------------------

dev=$(hostname | cut -b "12-15")

case $dev in
c111)
	f_c111
	;;
c132)
	f_c132
	;;
c232)
	f_c232
	;;
c211)
	f_c211
	;;
c176)
	f_c176
	;;
c14c)
	f_c14c
	;;
c34c)
	f_c34c
	;;
c332)
	f_c332
	;;
c311)
	f_c311
	;;
c411)	
	echo
	echo "用的http://docsdata.verycdn.cn/init/c41_init.sh"
	sleep 2
	wget -SO c41_init.sh http://docsdata.verycdn.cn/init/c41_init.sh && bash c41_init.sh
	;;
*)
	echo -e "\n \n \n暂不支持该设备 请确认hostname 或联系运维！\n \n \n"
esac
