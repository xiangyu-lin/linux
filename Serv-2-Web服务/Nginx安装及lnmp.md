# Installing the nginx

安装

    [root@xiangyu-lin ~]# groupadd -r nginx
    [root@xiangyu-lin ~]# useradd -r -g nginx -s /bin/false -M nginx  
    [root@xiangyu-lin ~]# yum -y install gcc openssl-devel pcre-devel zlib-devel gd-devel  # pcre 支持正则
    [root@xiangyu-lin ~]# wget http://nginx.org/download/nginx-1.14.0.tar.gz
    [root@xiangyu-lin ~]# tar -xvf nginx-1.14.0.tar.gz
    [root@xiangyu-lin ~]# cd nginx-1.14.0
    [root@xiangyu-lin ~]# ./configure --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_flv_module --with-http_image_filter_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_stub_status_module
    [root@xiangyu-lin ~]# make && make install

运行 重载

    [root@xiangyu-lin ~]# nginx  
    [root@xiangyu-lin ~]# nginx -s reload

# Lnmp
  yum -y install php-fpm mysql-server php-mysql
  service php-fpm start
> 取消此配置段注释 并修改 fastcgi_param 为 下面那行

`location ~ \.php$ {
    #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; `

## 遇到的问题

- 启动不下来
```
[root@localhost nginx]# nginx
nginx: [emerg] getpwnam("nginx") failed
[root@localhost nginx]# useradd nginx
```
- 编译时缺少gd...
the HTTP image filter module requires the GD library.
```
#yum -y install gd-devel
```

附

    ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx/nginx.pid  \
    --lock-path=/var/lock/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_flv_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --http-client-body-temp-path=/var/tmp/nginx/client/ \
    --http-proxy-temp-path=/var/tmp/nginx/proxy/ \
    --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
    --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
    --http-scgi-temp-path=/var/tmp/nginx/scgi \
    --with-pcre

---

mysql报错 （好像启动还有问题  待办）

    Transaction Check Error:
      file /usr/lib64/mysql/libmysqlclient.so.16.0.0 from install of mysql-libs-5.1.73-8.el6_8.x86_64 conflicts with file from package mysql-community-libs-compat-8.0.12-1.el6.x86_64
      file /usr/lib64/mysql/libmysqlclient_r.so.16.0.0 from install of mysql-libs-5.1.73-8.el6_8.x86_64 conflicts with file from package mysql-community-libs-compat-8.0.12-1.el6.x86_64

    Error Summary

解决
    yum -y remove mysql-community-libs-compat-8.0.12-1.el6.x86_64
