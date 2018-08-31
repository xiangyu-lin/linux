##  ifcfg     

> ifconfig/route/netstat

ifconfig命令

      ifconfig [interface]      不加选项显示所有活动接口
      ifconfig -a               所有接口信息
      ifconfig IFACE [up|down]  宕掉IFACE这个网卡

      ifconfig interface [aftype] options | address ...

          ifconfig IFACE IP/mask [up]         配置eth1 ip示例
              ifconfig eth1 172.16.0.2/16    

          ifconfig IFACE IP netmask MASK      配置eth1 ip示例2
              ifconfig eth1 172.16.0.1 netmask 255.255.0.0

      注意：立即生效

      启用混杂模式：[-]promisc
      > 启用混杂模式 -表示禁用 目标mac即便不是自己 收到信息也会保存一份 方便抓包分析

      > ifup/ifdown IFACE  ==>  ifconfig IFACE up/down


route命令  #配置立即生效 但不永久有效

    路由管理命令

      route -n      查看路由 不加-n 会反解成名称 耗时 有的dns不支持
      route add     添加路由

        route add  [-net|-host]  target [netmask Nm] [gw Gw] [[dev] If]

        #添加主机路由
        目标：192.168.1.3  网关：172.16.0.1
        ~]# route add -host 192.168.1.3 gw 172.16.0.1 dev eth0

        #添加网络路由
        目标：192.168.0.0 网关：172.16.0.1
        ~]# route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1 dev eth0
        ~]# route add -net 192.168.0.0/24 gw 172.16.0.1 dev eth0

        默认路由，网关：172.16.0.1
        ~]# route add -net 0.0.0.0 netmask 0.0.0.0 gw 172.16.0.1
        ~]# route add default gw 172.16.0.1

    删除：route del
      route del [-net|-host] target [gw Gw] [netmask Nm] [[dev] If]

        目标：192.168.1.3  网关：172.16.0.1
        ~]# route del -host 192.168.1.3

        目标：192.168.0.0 网关：172.16.0.1
        ~]# route del -net 192.168.0.0 netmask 255.255.255.0

    DNS服务器指定
      /etc/resolv.conf  #可以出现3次
        nameserver DNS_SERVER_IP1 #114.114.114.114
        nameserver DNS_SERVER_IP2 #
        nameserver DNS_SERVER_IP3

    正解：FQDN-->IP
      # dig -t A FQDN
      # host -t A FQDN
    反解：IP-->FQDN
      # dig -x IP
      # host -t PTR IP

      FQDN: www.magedu.com.  #完全限定名称

netstat命令： #网络状态查看

  netstat - Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships

  显示网络连接：
    netstat [--tcp|-t] [--udp|-u] [--raw|-w] [--listening|-l] [--all|-a] [--numeric|-n] [--extend|-e[--extend|-e]]  [--program|-p]
      -t: tcp协议相关
      -u: udp协议相关
      -w: raw socket相关  #裸套接字
      -l: 处于监听状态
      -a: 所有状态
      -n: 以数字显示IP和端口；
      -e：扩展格式 #显示user等信息
      -p: 显示相关进程及PID

      常用组合：
        -tan, -uan, -tnl, -unl

  显示路由表：
    netstat  {--route|-r} [--numeric|-n]
      -r: 显示内核路由表
      -n: 数字格式

  显示接口统计数据：
    netstat  {--interfaces|-I|-i} [iface] [--all|-a] [--extend|-e] [--program|-p] [--numeric|-n]

      # netstat -i   所有接口
        # netstat -I IFACE  指定接口
