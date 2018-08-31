**LVS-NAT                                                                    .**

### 架构
```
Director       eth0(外网) 172.16.1.2
               eth1(内网) 192.168.112.61
RealServer1    192.168.112.252 网关 192.168.112.61 (开启http服务)
RealServer2    192.168.112.123 网关 192.168.112.61 (开启http服务)
```

### 配置
> Director
```
ipvsadm -A -t 172.16.1.2:80 -s rr
ipvsadm -a -t 172.16.1.2:80 -r 192.168.112.123:80 -m
ipvsadm -a -t 172.16.1.2:80 -r 192.168.112.252:80 -m
sed -i '/ip_forword/s/0/1/' /etc/sysctl.conf   #开启路由转发
sysctl -p #重载配置
```

### 测试
> client 要能访问Director外网ip (比如同一网段)
```
[root@localhost ~]# curl http://172.16.1.2
RealServer 1 192.168.112.123
[root@localhost ~]# curl http://172.16.1.2
RealServer 2 192.168.112.252
```
---

[root@localhost ~]# ipvsadm -A -t 172.16.1.2:80 -s wrr
[root@localhost ~]# ipvsadm -a -t 172.16.1.2:80 -r 192.168.112.123:80 -i -w 1
[root@localhost ~]# ipvsadm -a -t 172.16.1.2:80 -r 192.168.112.252:80 -i -w 1

[root@localhost ~]# ipvsadm -D -t 172.16.1.2:80

------NAT 模式 CentOS7 需要开启路由转发

1.临时开启，（写入内存，在内存中开启）
echo "1" > /proc/sys/net/ipv4/ip_forward
2.永久开启，（写入内核）
在 vim /sysctl.conf 下
加入此行   net.ipv4.ip_forward = 1
sysctl -p               ----加载一下
[root@localhost ~]# sysctl -a |grep "ip_forward"    ----查看一下
net.ipv4.ip_forward = 1
net.ipv4.ip_forward_use_pmtu = 0

-------注释
ipvsadm -Ln  查看lvs规则表
ipvsadm -Lnc 查看当前调度状态
