MariaDB 日志

MariaDB日志
	查询日志: query log; #一般不开启
	慢查询日志：slow query log 查询执行时长超过指定时长的查询，即为慢查询
	错误日志: error log
	二进制日志：binary log 复制功能依赖于此日志
	中继日志：reley log
	事务日志：transaction log


查询日志：
  记录查询操作，保存到文件或表中： file|table

	log_output={TABLE|FILE|NONE}
		TABLE和FILE可以同时出现，用逗号分隔即可；
	general_log：是否启用查询日志；
	general_log_file：定义一般查询日志保存的文件


慢查询日志：
  查询执行时长超过指定时长的查询，即为慢查询
    MariaDB [(none)]> SHOW GLOBAL VARIABLES LIKE 'long_query_time';
    SELECT @@GLOBAL.long_query_time #查看单个参数的值 服务器变量两个@ 用户变量一个@
    SET GLOBAL.long_query_time=100

	long_query_time： 10.000000
	slow_query_log={ON|OFF}
		设定是否启用慢查询日志；它的输出位置也取决log_output={TABLE|FILE|NONE}；
	slow_query_log_file=HOSTNAME-slow.log
		定义日志文件路径及名称；

	log_slow_filter=admin,filesort,filesort_on_disk,full_join,full_scan,query_cache,query_cache_miss,tmp_table,tmp_table_on_disk
    过滤器 记录的类型
	log_slow_queries=ON #相当于 slow_query_log
	log_slow_rate_limit=1 #记录的速率每秒记录一个
	log_slow_verbosity


错误日志：
	服务器启动和关闭过程中的信息；
	服务器运行过程中的错误信息；
	事件调度器运行一个事件时产生的信息；
	在复制架构中的从服务器上启动从服务器线程时产生的信息；

	log_error = /path/to/error_log_file
	log_warnings = {1|0}
		是否记录警告信息于错误日志中；

二进制日志：
  记录导致数据改变或潜在导致数据改变的SQL语句；
  功能： 用于通过“重放”日志文件中的时间来生成数据副本；

  mysql> SHOW {BINARY | MASTERS} LOGS 查看mariadb 自行管理使用中的二进制日志文件列表
  mysql> SHOW MASTER STATUS; 查看mariadb正在用的二进制日志文件
	mysql> SHOW BINLOG EVENTS IN 'log_file';

  MySQL记录二进制日志的格式：
    基于语句：statement
    基于行：row
    混合模式：mixed 让系统自行判定基于哪种方式进行

  二进制日志文件的构成：
    两类文件
      日志文件： mysql-bin.文件名后缀，二进制格式
      索引文件： mysql-bin.index,文本格式 追踪正在使用中的二进制文件序列

  服务器参数：

		sql_log_bin = {ON|OFF},是否记录
    log_bin = {ON|OFF},同上
    log_bin=/PATH/TO/BIN_LOG_FILE 记录日志的文件路径
    binlog_format = {statement|row|mixed} 二进制日志记录的格式
    max_binlog_size =
      单个二进制日志文件上限默认1G；
        注意：(1)到达最大后自动滚动;(2)文件达到文件上限的大小不一定是精确值

		sync_binlog=1|0 #是否启用二进制日志同步功能；
    expire_log_days 过期时长 0不启用
		max_binlog_cache_size =
			二进制日志缓冲空间大小，仅用于缓冲事务类的语句；
		max_binlog_stmt_cache_size =

	二进制日志的功用：
		即时点恢复；
		复制；

  读取二进制日志(客户端命令工具)
  	# mysqlbinlog [options] log_file
  		--start-time
  		--stop-time
  		--start-position
  		--stop-position

	server-id: 服务器身份标识

	INSERT INTO t1 VALUE (CURRENT_DATE());

	二进制日志文件内容格式：

		事件发生的日期和时间  
		服务器ID server id 1
		事件的结束位置 end_log_pos 431
		事件的类型 Query
		原服务器生成此事件时的线程ID thread_id 1
		语句的时间戳和写入二进制日志文件的时间差； exec_time=0
		错误代码:error_code=0
		事件内容
		事件位置，相当于下一事件的开始位置
    GTID: Global Transaction ID;
      专属属性：GTID

	建议：切勿将二进制日志与数据文件放在一同设备；

中继日志：
  复制架构中，从服务器用于保存从主服务器的二进制日志中读取到的事件；

  relay_log_purge={ON|OFF}
  	是否自动清理不再需要中继日志

事务日志
  帮助事务型存储引擎自行管理和使用；
