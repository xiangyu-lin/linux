vhost1: pma.linxy.top , phpMyAdmin, 同时提供https服务；
vhost2: wp.linxy.top  , wordpress


  [root@xLamp ~]# yum -y install httpd mariadb-server php php-mysql
  [root@xLamp ~]# systemctl start httpd
  [root@xLamp ~]# systemctl start  mariadb.service
  [root@xLamp ~]# mysql_secure_installation

---

[root@xLamp ~]# vim /etc/httpd/conf.d/pma.linxy.top.conf
```
<VirtualHost *:80>
    ServerName pma.linxy.top
    DocumentRoot "/var/www/vhosts/vho1"
</VirtualHost>
```
[root@xLamp ~]# mkdir -p  /var/www/vhosts/vhost1/
[root@xLamp ~]# vim /var/www/vhosts/vhost1/index.php
```
<?php
    phpinfo();
?>
```
[root@xLamp ~]# systemctl restart  mariadb.service
访问 pma.linxy.top/index.php 有php信息页 #域名解析到该主机或者绑定hosts

[root@xLamp ~]# cd /var/www/vhosts/vhost1/
[root@xLamp vhost1]# wget https://files.phpmyadmin.net/phpMyAdmin/4.0.10.20/phpMyAdmin-4.0.10.20-all-languages.tar.gz
[root@xLamp vhost1]# tar -xvf phpMyAdmin-4.0.10.20-all-languages.tar.gz
[root@xLamp vhost1]# ln -sv phpMyAdmin-4.0.10.20-all-languages pma

访问 pma.linxy.top/pma
