##　nmon　监控　nmon analyser　分析

nmom 下载安装，运行

    [root@jzr ~]# mkdir -p /usr/local/nmon
    [root@jzr ~]# cd !$
    [root@jzr nmon]# wget https://sourceforge.mirrorservice.org/n/nm/nmon/nmon16g_x86.tar.gz
    [root@jzr nmon]# ln -sv /usr/local/nmon/nmon16g_x86_sles114 /bin/nmon
    [root@jzr nmon]# nmon

数据采集

    [root@jzr nmon]# mkdir /var/log/nmon
    [root@jzr nmon]# nmon -s1 -c60 -f -m /var/log/nmon
    [root@jzr nmon]# ll /var/log/nmon/jzr_181016_1656.nmon
    -rw-r--r-- 1 root root 110588 Oct 16 16:57 /var/log/nmon/jzr_181016_1656.nmon

参数说明：
    -s1    每隔n秒抽样一次，这里为1秒
    -c60   取出多少个抽样数量，这里为60，即监控=1*60/60=1分钟
    -f     按标准格式输出文件名称：<hostname>_YYMMDD_HHMM.nmon     ._
    -m     指定监控文件的存放目录，-m后跟指定目录

生成图形报表
    [root@jzr nmon]# sort /var/log/nmon/jzr_181016_1656.nmon > /var/log/nmon/jzr_181016_1656.csv
    [root@jzr nmon]# sz /var/log/nmon/jzr_181016_1656.csv

下载 nmon analyser
    https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Power+Systems/page/nmon_analyser

    https://www.ibm.com/developerworks/community/wikis/form/anonymous/api/wiki/61ad9cf2-c6a3-4d2c-b779-61ff0266d32a/page/b7fc61a1-eef9-4756-8028-6e687997f176/attachment/0718c0da-edb5-4068-8deb-a4ec08475e0f/media/nmon_analyser_v54.zip
