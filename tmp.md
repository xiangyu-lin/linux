echo "Usage: $0 command [WEBNAME]"
echo "commands:"
echo "  start             Start tomcat"
echo "  stop              Stop Catalina, waiting up to 5 seconds for the process to end"
echo "  stop n            Stop Catalina, waiting up to n seconds for the process to end"
echo "  stop -force       Stop Catalina, wait up to 5 seconds and then use kill -KILL if still running"
echo "  stop n -force     Stop Catalina, wait up to n seconds and then use kill -KILL if still running"
echo "  version           What version of tomcat are you running?"


# 题目

## 简答

> 1. hmaster 作用

HMaster没有单点问题，在Hbase中可以启动多个HMaster,通过Zookeeper的Master选举机制保证总有一个Master正常运行并提供服务，其他HMaster作为备选时刻准备提供服务。HMaster主要负责Table和Region的管理工作。

管理用户对表的增删改查
管理RegionServer的负载均衡，调整region分布
在region分裂后，负责新region的分配
在regionserver死机后，负责失效RegionServer上的Region迁移

> 2. hlog作用

HLog(WAL log)：WAL意为write ahead log，
用来做灾难恢复使用，HLog记录数据的所有变更，
一旦region server 宕机，就可以从log中进行恢复。

> 3. region是什么？

HRegion是HBase中分布式存储和负载均衡的最小单元，即不同的HRegion可以分别在不同的HRegionServer上。

从物理上来说，一张表被拆分成多块，每一块就是一个Hregion
但同一个HRegion是不会拆分到多个HRegionServer上的。HRegion按大小分割，每个表一般只有一个HRegion，随着数据不断插入表，HRegion不断增大，
当HRegion的某个列簇达到一个阀值（默认256M）时就会分成两个新的HRegion

> 4. 简述hfile的生成过程

HFile生成流程当RegionServer(RS)收到写请求的时候(write request)，RS会将请求转至相应的Region。每一个Region都存储着一些列(a set of rows)。根据其列族的不同，将这些列数据存储在相应的列族中(Column Family，简写CF)。不同的CFs中的数据存储在各自的HStore中，HStore由一个Memstore及一系列HFile组成。Memstore位于RS的主内存中，而HFiles被写入到HDFS中。当RS处理写请求的时候，数据首先写入到Memstore，然后当到达一定的阀值的时候，Memstore中的数据会被刷到HFile中。

在本章节，我们以Flush流程为例，介绍如何一步步生成HFile的流程，来加深大家对于HFile原理的理解。
起初，HFile中并没有任何Block，数据还存在于MemStore中。
Flush发生时，创建HFile Writer，第一个空的Data Block出现，初始化后的Data Block中为Header部分预留了空间，Header部分用来存放一个Data Block的元数据信息。
而后，位于MemStore中的KeyValues被一个个append到位于内存中的第一个Data Block中

> 5. 简述列族与hfile的对应关系

hbase 一个列族 包含多和Hfile

> 6. hdfs的组件有哪些（至少3个）

Client  Namenode Secondary NameNode DataNode
Secondary Namenode：辅助后台程序，与NameNode进行通信，以便定期保存HDFS元数据的快照。

> 7. namenode作用

HDFS的守护进程，用来管理文件系统的命名空间，负责记录文件是如何分割成数据块，以及这些数据块分别被存储到那些数据节点上，它的主要功能是对内存及IO进行集中管理。

> 8. datanode作用 ：

存储实际的数据块，执行数据块读写操作
执行数据块的读/写操作。

文件系统的工作节点，根据需要存储和检索数据块，并且定期向namenode发送他们所存储的块的列表

## 判断

1. 安全模式下，hdfs可写入数据（X）安全模式是HDFS所处的一种特殊状态，在这种状态下，文件系统只接受读数据请求，而不接受删除、修改等变更请求。

2. hbase索引是基于行键的（X）Hbase 基于列模式存储
