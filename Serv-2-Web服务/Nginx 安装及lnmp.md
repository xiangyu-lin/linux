# Installing the nginx

> 下载解压进入目录

1. groupadd -r nginx && useradd -r -g nginx -s /bin/false -M nginx  
2. yum -y install gcc openssl-devel pcre-devel zlib-devel   # pcre 支持正则
3. ./configure --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_flv_module --with-http_image_filter_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_stub_status_module
4. make && make install
5. nginx  运行
6. nginx -s reload 重载

# Lnmp
  yum -y install php-fpm mysql-server php-mysql
  serveic php-fpm start
> 取消此配置段注释 并修改 fastcgi_param 为 下面那行

`location ~ \.php$ {
    #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; `

> ./configure \
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
