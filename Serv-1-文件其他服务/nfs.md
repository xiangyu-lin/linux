## NFS

NFS Network FileSystem 网络文件系统

服务端 CentOS7
[root@xNfs ~]# yum -y install nfs-utils
[root@xNfs ~]# vim /etc/exports
[root@xNfs ~]# service nfs start
  ```
  /mydata/data *(sync,rw,all_squash)
  ```
exportfs
> 中途修改/etc/exports 不重启使其生效

  export [-aruv] [Host:/path]

    -a  全部挂载或卸载 /etc/exports 内容
    -r  重新挂载分享出来的目录
    -v  显示过程
    -u  卸载目录
    Host ： 客户端主机地址
    /path

    exportfs -rv #重新挂载
    exportfs 192.168.112.61:/home/test/ #临时新增
    exportfs


客户端 CentOS6
[root@xy ~]# yum -y install nfs-utils 安装
[root@xy ~]# service rpcbind start 启动
[root@xy ~]# showmount -e 192.168.112.247 查看服务器端共享目录资源
[root@xy ~]# showmount -a 192.168.112.247 客户端查看已挂载NFS的客户端
[root@xy ~]# mount -t nfs 192.168.112.247:/mydata/data /tmp/mydata 挂载
[root@xy ~]# umount /tmp/mydata

[root@xy ~]# vim /etc/fstabss
192.168.112.247:/mydata/data /tmp/data nfs defaults 0 0
---
## /etc/exports 解释

  共享资源路径 [主机地址] [选项]

```
  /data *(sync,rw,all_squash)
  /tmp *(ro,no_root_squash)
  /home/share 192.168.112.*(rw,no_root_squash) *(ro)
  /opt/data 192.168.112.247(rw,anonuid=686,anongid=686)

```
  共享资源路径 ： nfs共享路径 供客户端挂载
  主机地址 ： 允许的挂载NFS的客户端 可以是ip或hostname、域名 可以*匹配
  选项
    ro,rw 客户端只读和读写权限
    no_root_squash : 客户端是root则有最高权限  此项不安全
    no_root_squash : 系统预设值 客户端root映射为匿名用户
    all_squash  : 都映射为匿名用户 nfsnobody
    no_all_squash : 客户端GID,UID==服务端GID,UID时，拥有读写权限
    anongid,anonuid ：将登入的nfs主机uid,gid 设置为某值
    sync : 资料同步写入磁盘 默认值
    async: 暂存内存 不直接写入磁盘

1、使用了非法端口，也就是使用了大于1024的端口。
这个错误，可以通过查看日志确认：
[root@local~ /]# cat /var/log/messages | grep mount
Jan 2 12:49:04 localhost mountd[1644]: refused mount request from 192.168.0.100 for /home/nfsshare/ (/home/nfsshare): illegal port 1689

解决办法：
修改配置文件/etc/exports，加入 insecure 选项,重启nfs服务，再尝试挂载。
/home/nfsshare/　　*(insecure,rw,async,no_root_squash)
