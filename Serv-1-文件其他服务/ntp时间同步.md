## 三、配置NTP时间同步

### ntp 服务端配置

- 安装 ntp

        [root@ambari ~]# yum install -y ntp

- 修改配置文件 (加粗为手动添加，其他不动，192.168.1.0 指该网段内可同步)

        [root@ambari ~]# vi /etc/ntp.conf

        # Hosts on local network are less restricted.
        #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
        restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap

        # Use public servers from the pool.ntp.org project.
        # Please consider joining the pool (http://www.pool.ntp.org/join.html).
        # server 0.centos.pool.ntp.org iburst
        # server 1.centos.pool.ntp.org iburst
        # server 2.centos.pool.ntp.org iburst
        # server 3.centos.pool.ntp.org iburst
        server 127.127.1.0
        fudge 127.127.1.0 stratum 10

- 启动服务

        [root@ambari ~]# /etc/init.d/ntpd start
        [root@ambari ~]# chkconfig ntpd on

### ambari ntpdate 客户端配置

安装及同步

    [root@ambari ~]# yum -y install ntpdate
    [root@ambari ~]# ntpdate 192.168.1.53

---

附批量安装

- 安装ntpdate

        [root@ambari ~]# for i in {25..35};do ssh root@192.168.1.$i 'yum -y install ntpdate';done
        [root@ambari ~]# for i in {50..52};do ssh root@192.168.1.$i 'yum -y install ntpdate';done

- 任务计划每分钟同步

        [root@ambari ~]# for i in {25..35};do ssh root@192.168.1.$i 'echo "*/1 * * * * /usr/sbin/ntpdate 192.168.1.53" >> /var/spool/cron/root';done

        [root@ambari ~]# for i in {50..52};do ssh root@192.168.1.$i 'echo "*/1 * * * * /usr/sbin/ntpdate 192.168.1.53" >> /var/spool/cron/root';done

- 同步到硬件时钟

        [root@ambari ~]# for i in {25..35};do ssh root@192.168.1.$i 'echo "*/1 * * * * hwclock --systohc" >> /var/spool/cron/root';done

        [root@ambari ~]# for i in {50..52};do ssh root@192.168.1.$i 'echo "*/1 * * * * hwclock --systohc" >> /var/spool/cron/root';done

- 查看定时任务

        [root@ambari ~]# for i in {25..35};do ssh root@192.168.1.$i 'crontab -l';done
