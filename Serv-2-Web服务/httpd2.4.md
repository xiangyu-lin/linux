# httpd-2.4

/etc/httpd24/extra

新特性：

 1. MPM支持运行DSO机制；以模块形式按需加载；
 2. 支持event MPM；#2.2 实验阶段 2.4生产可用
 3. 支持异步读写；
 4. 支持每模块及每个目录分别使用各自的日志级别；
 5. 每请求配置；<If>
 6. 增强版的表达式分析器；
 7. 支持毫秒级的keepalive timeout；
 8. 基于FQDN的虚拟主机不再需要NameVirtualHost指令；
 9. 支持用户自定义变量；

新模块：

	(1) mod_proxy_fcgi
	(2) mod_ratelimit
	(3) mod_remoteip

修改了一些配置机制: 不再支持使用Order, Deny, Allow来做基于IP的访问控制；


---

### CentOS 7 配置

配置文件：

- 主配置文件：/etc/httpd/conf/httpd.conf
- 模块配置文件：/etc/httpd/conf.modules.d/* .conf
- 辅助配置文件：/etc/httpd/conf.d/* .conf

- mpm：以DSO机制提供，配置文件00-mpm.conf

服务控制：

	systemctl {start|stop|restart|status|reload} httpd.service

配置：

	(1) 切换使用MPM
		LoadModule mpm_NAME_module modules/mod_mpm_NAME.so
			NAME: prefork, event, worker

	(2) 修改'Main' server的DocumentRoot

	(3) 基于IP的访问控制法则 # 放到这个容器中<RequireAll>
		允许所有主机访问：Require all granted
		拒绝所有主机访问：Require all deny

		控制特定IP访问：
			Require ip IPADDR：授权指定来源地址的主机访问
			Require not ip IPADDR：拒绝指定来源地址的主机访问

			IPADDR：
				IP: 172.16.100.2
				Network/mask: 172.16.0.0/255.255.0.0
				Network/Length: 172.16.0.0/16
				Net: 172.16

		控制特定主机（HOSTNAME）访问
			Require host HOSTNAME
			Require not host HOSTNAME

			HOSTNAME:
				FQDN: 特定主机
				DOMAIN：指定域内的所有主机

		<RequireAll>
		    Require all granted
		    Require not ip 10.252.46.165
		</RequireAll>


	(4) 虚拟主机
		基于IP、Port和FQDN都支持；
		基于FQDN的不再需要NameVirtualHost指令；

	(5) ssl
		启用模块：
			LoadModule ssl_module modules/mod_ssl.so
