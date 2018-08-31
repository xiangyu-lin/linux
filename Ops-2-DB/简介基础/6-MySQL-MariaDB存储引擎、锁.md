MySQL存储引擎

MySQL存储引擎：	存储引擎也通常称作“表类型”

表类型
    CREATE TABLE ... ENGINE=
    如何修改默认存储引擎：通过default_storage_engine服务变量实现

InnoDB：
    处理大量短期事务；
    数据存储于"表空间(table space)"中;
        (1) 所有InnoDB表的数据和索引放置于同一个表空间中；即
              innodb_file_per_table=OFF
                    表空间文件：datadir定义的目录下
              ibddata1,ibddata2,...
        (2) 每个表单独使用一个表空间存储标的数据和索引；
            innodb_file_per_table=ON

            数据文件(存储数据和索引)：tbl_name.ibd,
            表格式定义： tbl_name.frm

      特性
        基于MVCC来支持高并发，支持所有的四个隔离级别，默认级别为REPEATABLE READ，间隙锁放置幻读；
        使用聚集索引
        支持“自适应hash索引”
        锁粒度： 行级锁

        MariaDB (XtraDB(percona 提供))  #MariaDB的InnoDB其实是XTraDB

        数据存储：表空间
        并发：MVCC，间隙锁
        索引：聚集索引、辅助索引
        性能：预计操作、自适应hash、插入缓存区
        备份：支持热备(xtrabackup)

      表空间：table space，由InnoDB管理的特有格式数据文件，内部可同时存储数据和索引


MyISAM:
    支持全文索引(FULLTEXT index)、压缩、空间函数(GIS)；但不支持事务；且为表级锁；
    崩溃后无法安全恢复

    使用场景：只读(或写较少)、表较小(可以接受长时间进行修复操作)
        Aria: ctash-safe

    文件:每个表都在数据库目录下存储三个文件：
        tbl_name.frm: 表格式定义
        tbl_name.MYD: 数据文件
        tbl_name.MYI: 索引文件

    特性：
        加锁和并发： 且为表级锁
        修复： 手工修复或自动修复、但可能丢失数据
        索引：非聚集索引
        延迟更新索引键：
        压缩表

    行格式：dynamic,fixed,compressed,compact,redundent



其他存储引擎

    CSV：
      将数据存储为CSV格式；不支持索引；仅适用于数据交换场景；

    ARCHIVE：
      仅支持INSERT和SELECT，支持很好压缩功能；
      适用于存储日志信息，或其它按时间序列实现的数据采集类的应用；

      不支持事务，不能很好的支持索引；

    MRG_MUISAM：将多个MyISAM表合并成为一个虚拟表；是MYISAM的一个变种，
    BLACKHOLE：类似于/dev/null，不真正存储任何数据
    MEMORY：所有数据都保存与内存中，内存表；支持hash索引；表级锁；
        临时表
    NDB：是MySQL CLUSTER中专用的存储引擎
    BLACKHOLE：
     没有存储机制，任何发往此引擎的数据都会丢弃；其会记录二进制日志，因此，常用于多级复制架构中作中转服务器；

    MEMORY：
     保存数据在内存中，内存表；常用于保存中间数据，如周期性的聚合数据等；也用于实现临时表
     支持hash索引，使用表级锁，不支持BLOB和TEXT数据类型
    PERFORMANCE_SCHEMA：伪存储引擎；
    ARCHIVE： 数据归档，只支持SELECT和INSERT操作；支持行级锁和专用缓存区；
    FEDERATED： 用于访问其他远程MySQL服务器的一个代理，它通过创建一个到远程MySQL服务器的客户端连接，并将查询传输到远程服务器执行，而后完成数据存取
        在MariaDB的实现是federatedX

---

第三方的存储引擎：

	OLTP类：
		XtraDB: 增强的InnoDB，由Percona提供；
			编译安装时，下载XtraDB的源码替换MySQL存储引擎中的InnoDB的源码

		PBXT: MariaDB自带此存储引擎
			支持引擎级别的复制、外键约束，对SSD磁盘提供适当支持；
			支持事务、MVCC

		TokuDB: 使用Fractal Trees索引，适用存储大数据，拥有很压缩比；已经被引入MariaDB；

	列式存储引擎：
		Infobright: 目前较有名的列式引擎，适用于海量数据存储场景，如PB级别，专为数据分析和数据仓库设计；
		InfiniDB
		MonetDB
		LucidDB

	开源社区存储引擎：
		Aria：前身为Maria，可理解为增强版的MyISAM(支持崩溃后安全恢复，支持数据缓存)
		Groona：全文索引引擎，Mroonga是基于Groona的二次开发版
		OQGraph: 由Open Query研发，支持图结构的存储引擎
		SphinxSE: 为Sphinx全文搜索服务器提供了SQL接口
		Spider: 能数据切分成不同分片，比较高效透明地实现了分片(shared)，并支持在分片上支持并行查询；

MariaDB支持的其他存储引擎：
    OQGraph
    SphinxSE
    TokuDB
    Cassandra
    CONNECT
    SQUENCE

---
mysql> SHOW ENGINES;
mysql> SHOW TABLES STATUS [LIKE clause] [WHERE clause]

SHOW TABLE STATUS [{FROM | IN} db_name]
  [LIKE 'pattern' | WHERE expr]

   mysql> SHOW TABLE STATUS IN hellodb WHERE Name='classes'\G
  *************************** 1. row ***************************
             Name: classes
           Engine: InnoDB
          Version: 10
       Row_format: Compact
             Rows: 8
   Avg_row_length: 2048
      Data_length: 16384
  Max_data_length: 0
     Index_length: 0
        Data_free: 9437184
   Auto_increment: 9
      Create_time: 2014-04-08 11:14:52
      Update_time: NULL
       Check_time: NULL
        Collation: utf8_general_ci
         Checksum: NULL
   Create_options:
          Comment:
  1 row in set (0.01 sec)

    Name: 表名
    Engine: 存储引擎
    Version: 版本
    Row_format: 行格式
      {DEFAULT|DYNAMIC|FIXED|COMPRESSED|REDUNDANT|COMPACT}
    Rows: 表中的行数
    Avg_row_length: 平均每行所包含的字节数；
    Data_length: 表中数据总体大小，单位是字节
    Max_data_length: 表能够占用的最大空间，单位为字节
    Index_length: 索引的大小，单位为字节
    Data_free: 对于MyISAM表，表示已经分配但尚未使用的空间，其中包含此前删除行之后腾出来的空间
    Auto_increment: 下一个AUTO_INCREMENT的值；
    Create_time: 表的创建时间；
    Update_time：表数据的最近一次的修改时间；
    Check_time：使用CHECK TABLE或myisamchk最近一次检测表的时间；
    Collation: 排序规则
    Checksum: 如果启用，则为表的checksum；
    Create_options: 创建表时指定使用的其它选项；
    Comment: 表的注释信息


---

并发控制
MySQL锁：

	执行操作时施加的锁模式
		读锁：共享锁
		写锁：独占锁，排它锁

	锁粒度：
		表级锁：table lock
			锁定了整张表
		行级锁：row lock
			锁定了需要的行

			粒度越小，开销越大，但并发性越好；
			粒度越大，开销越小，但并发性越差；

      锁策略：在锁粒度及数据安全性寻求的平衡机制；
          每种存储引擎都可以自行实现其锁策略和锁粒度
          MySQL在服务器级别也实现了锁，表级锁；用户可显式请求

	锁的实现位置：
		MySQL锁：可以使用显式锁
		存储引擎锁：自动进行的（隐式锁）；

		显式锁(表级锁)：
			(1)LOCK TABLES
			   UNLOCK TABLES

        #LOCK TABLES students READ;
        #UNLOCK TABLES; #释放所有锁
        #LOCK TABLES students WRITE;

  			LOCK TABLES
  			    tbl_name lock_type
  			    [, tbl_name lock_type] ...

			    锁类型：READ|WRITE

      (2) FLUSH TABLES tb_name[,...] [WITH READ LOCK]
      (3) SELECT clase [FOR UPDATE] [WITH READ LOCK]


			InnoDB存储引擎也支持另外一种显式锁(锁定挑选出的部分行，行级锁 )：
				SELECT ... LOCK IN SHARE MODE;
				SELECT ... FOR UPDATE;

   分类
      隐式锁：由存储引擎自动施加锁(建议使用)
      显示锁：上面的
