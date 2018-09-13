bash脚本编程

基础简介

	bash提供了编程环境

	程序：指令+数据

	程序编程风格
		过程式：以指令为中心，数据服务于指令
		对象式：以数据为中心，指令服务于数据

	shell程序：提供了编程能力，解释执行

	程序的执行方式
		计算机：运行二进制指令

	编程语言：
		  低级：汇编
		  高级：
			编译：高级语言-->编译器-->目标代码
				C、C++, java
			解释：高级语言-->解释器-->机器代码
				shell, perl, python

	过程式编程
		顺序执行
		循环执行
		选择执行

	shell编程：过程式、解释执行

	编程语言的基本结构
		数据存储：变量、数组
		表达式
		语句

	shell脚本格式：文本文件

	shebang
	#!/bin/bash
	#!/usr/bin/python
	#!/usr/bin/perl

	运行脚本
		1.给予执行权限，通过具体的文件路径指定文件执行；
		2.直接运行解释器，将脚本作为解释器程序的参数运行；

		chmod +x echo.sh
		bash echo.sh

	bash -n 检查语法错误
	bash -x 测试执行 （某些命令测试时会真正执行）


	bash自定义退出状态码

		exit [n]：自定义退出状态码

		注意：脚本中一旦遇到exit命令，脚本立即终止；终止退出状态取决于exit命令后面的数字；
		注意：如果未给脚本指定退出状态码，整个脚本的退出状态码取决于脚本中执行的最后一条命令的状态码；


		编程语言：
			数据结构
			顺序执行
			选择执行
				条件测试
					运行命令或[[ EXPRESSION ]]
						执行状态返回值；
				if
				case

			循环执行
				将某代码段重复运行多次
				重复运行多少次？
					循环次数事先已知：
					循环次数事先未知；

					必须有进入条件和退出条件

				for, while, until

			函数：结构化编程及代码重用；
				function

变量

	### 变量类型

	数据存储格式、存储空间大小、参与运算种类

		字符型
		数值型
				整型
				浮点型

		强类型：定义变量时必须指定类型、参与运算必须符合类型要求；调用未声明变量会产生错误；
		弱类型：无须指定类型，默认均为字符型；参与运算会自动进行隐式类型转换；变量无须事先定义可直接调用



	### bash中的变量的种类

	根据变量的生效范围等标准

	- 本地变量：生效范围为当前shell进程；对当前shell之外的其它shell进程，包括当前shell的子shell进程均无效；
	- 环境变量：生效范围为当前shell进程及其子进程；
	- 局部变量：生效范围为当前shell进程中某代码片断(通常指函数)；
	- 位置变量：$1, $2,...来表示，用于让脚本在脚本代码中调用通过命令行传递给它的参数；
	- 特殊变量：$?, $0, $*, $@, $#
			$# 是传给脚本的参数个数
			$0 是脚本本身的名字
			$1 是传递给该shell脚本的第一个参数
			$2 是传递给该shell脚本的第二个参数
			$@ 是传给脚本的所有参数的列表
			$* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个
			$$ 是脚本运行的当前进程ID号
			$? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误

	本地变量

		变量赋值：name='value'

		可以使用引用：
	    value:
			(1) 可以是直接字串; name="username"
			(2) 变量引用：name="$username"
			(3) 命令引用：name=`COMMAND`, name=$(COMMAND)

		变量引用：${name}, $name
			""：弱引用，其中的变量引用会被替换为变量值；
			''：强引用，其中的变量引用不会被替换为变量值，而保持原字符串；

		显示已定义的所有变量
			set

		销毁变量：
			unset name


	环境变量

		变量声明、赋值：
			export name=VALUE
			declare -x name=VALUE

		变量引用：$name, ${name}

		显示所有环境变量：
			export
			env
			printenv
		销毁：
			unset name

		bash有许多内建的环境变量：PATH, SHELL, UID, HISTSIZE, HOME, PWD, OLD


	只读变量

		readonly name
		declare -r name


	位置变量

		在脚本代码中调用通过命令行传递给脚本的参数；
		$1, $2, ...：对应调用第1、第2等参数；

			shift [n]

		$0: 命令本身；

		$*: 传递给脚本的所有参数；
		$@: 传递给脚本的所有参数；
		$#: 传递给脚本的参数的个数；

		示例：判断给出的文件的行数
			#!/bin/bash
			linecount="$(wc -l $1| cut -d' ' -f1)"
			echo "$1 has $linecount lines."

	变量命名法则

		1. 不能使程序中的保留字：例如if, for;
		2. 只能使用数字、字母及下划线，且不能以数字开头；
		3. 见名知义，

条件测试
	判断某需求是否满足，需要由测试机制来实现。
	专用的测试表达式需要由测试命令辅助完成测试过程。

	测试命令
		test EXPRESSION
		[ EXPRESSION ]
		[[ EXPRESSION ]]

	注：EXPRESSION前后必须有空白字符


	bash的测试类型

		测试表达式的类别
			数值比较
			字符串测试
			文件测试

	数值测试
		-gt: 是否大于；
		-ge: 是否大于等于；
		-eq: 是否等于；
		-ne: 是否不等于；
		-lt: 是否小于；
		-le: 是否小于等于；

	字符串测试
		==：是否等于；
		>: 是否大于；
		<: 是否小于；
		!=: 是否不等于；
		=~: 左侧字符串是否能够被右侧的PATTERN所匹配；
		Note: 此表达式一般用于[[  ]]中；

		-z "STRING"：测试字符串是否为空，空则为真，不空则为假；
		-n "STRING"：测试字符串是否不空，不空则为真，空则为假；
		Note：用于字符串比较时的用到的操作数都应该使用引号


	条件测试


		存在性测试
			-a FILE
			-e FILE: 文件存在性测试，存在为真，否则为假；

		存在性及类别测试
			-b FILE：是否存在且为块设备文件；
			-c FILE：是否存在且为字符设备文件；
			-d FILE：是否存在且为目录文件；
			-f FILE：是否存在且为普通文件；
			-h FILE 或 -L FILE：存在且为符号链接文件；
			-p FILE：是否存在且为命名管道文件；
			-S FILE：是否存在且为套接字文件；

		文件权限测试
			-r FILE：是否存在且可读
			-w FILE: 是否存在且可写
			-x FILE: 是否存在且可执行

	  文件特殊权限测试
			-g FILE：是否存在且拥有sgid权限；
			-u FILE：是否存在且拥有suid权限；
			-k FILE：是否存在且拥有sticky权限；

		文件大小测试
			-s FILE: 是否存且非空

		文件是否打开：
			-t fd: fd表示文件描述符是否已经打开且与某终端相关
			-N FILE：文件自动上一次被读取之后是否被修改过；
			-O FILE：当前有效用户是否为文件属主；
			-G FILE：当前有效用户是否为文件属组；

		双目测试
			FILE1 -ef FILE2: FILE1与FILE2是否指向同一个设备上的相同inode
			FILE1 -nt FILE2: FILE1是否新于FILE2；
			FILE1 -ot FILE2: FILE1是否旧于FILE2；

		组合测试条件

		逻辑运算
		第一种
			COMMAND1 && COMMAND2
			COMMAND1 || COMMAND2
			! COMMAND
			[ -e FILE ] && [ -r FILE ]
		第二种
			EXPRESSION1 -a EXPRESSION2
			EXPRESSION1 -o EXPRESSION2
			! EXPRESSION

			注：必须使用测试命令进行

bash脚本编程之用户交互

	read [option]... [name ...]
		-p 'PROMPT'
		-t TIMEOUT

	bash -n /path/to/some_script
		检测脚本中的语法错误

	bash -x /path/to/some_script
		调试执行

	read 1987name 从标准输入读取输入并赋值给变量1987name。
	read 从标准输入读取一行并赋值给特定变量REPLY。
	read -a arrayname 把单词清单读入arrayname的数组里。
	read -p "text" 打印提示（text），等待输入，并将输入存储在REPLY中。
	read -t 3 指定读取等待时间为3秒。
	read -s 静默模式 用于输入密码时不显示

	#read one two three
	1 2 3 	#在控制台输入1 2 3，它们之间用空格隔开。

	补充一个终端输入密码时候，不让密码显示出来的例子
	#!/bin/bash read -p "输入密码：" -s pwd
	echo
	echo password read, is "$pwd"

	示例：用户建立磁盘路径，显示已有分区
			#!/bin/bash
			# Version: 0.0.1
			# Author: MageEdu
			# Description: read testing

			read -p "Enter a disk special file: " diskfile
			[ -z "$diskfile" ] && echo "Fool" && exit 1

			if fdisk -l | grep "^Disk $diskfile" &> /dev/null; then
				    fdisk -l $diskfile
			else
				    echo "Wrong disk special file."
				    exit 2
			fi

if语句
	CONDITION:
		bash命令：
			用命令的执行状态结果；
				成功：true
				失败：flase

			成功或失败的意义：取决于用到的命令；

	单分支：
		if CONDITION; then
			if-true
		fi

	双分支：
		if CONDITION; then
			if-true
		else
			if-false
		fi

	多分支：
		if CONDITION1; then
			if-true
		elif CONDITION2; then
			if-ture
		elif CONDITION3; then
			if-ture
		...
		esle
			all-false
		fi

		逐条件进行判断，第一次遇为“真”条件时，执行其分支，而后结束；

	示例：用户键入文件路径，脚本来判断文件类型；
		#!/bin/bash
		#

		read -p "Enter a file path: " filename

		if [ -z "$filename" ]; then
		    echo "Usage: Enter a file path."
		    exit 2
		fi

		if [ ! -e $filename ]; then
		    echo "No such file."
		    exit 3
		fi

		if [ -f $filename ]; then
		    echo "A common file."
		elif [ -d $filename ]; then
		    echo "A directory."
		elif [ -L $filename ]; then
		    echo "A symbolic file."
		else
		    echo "Other type."
		fi

	注意：if语句可嵌套

case语句
	条件判断case语句（相当于简化版的if语句）（PAT不支持正则，但支持glob）
		case 变量引用 in
		PAT1)
			分支1
			;;
		PAT2)
			分支2
			;;
		...
		*)
			分支n
			;;
		esac

		case支持glob风格的通配符：
			*: 任意长度任意字符；
			?: 任意单个字符；
			[]：指定范围内的任意单个字符；
			a|b: a或b
			示例：

				#!/bin/bash
				# 第一行 '<<' 没有引号 为了编辑器显示效果加的
				cat '<<' EOF
				cpu) show cpu information;
				mem) show memory information;
				disk) show disk information;
				quit) quit
				============================
				EOF
				read -p "Enter a option: " option
				while [ "$option" != 'cpu' -a "$option" != 'mem' -a "$option" != 'disk' -a "$option" != 'quit' ]; do
				    read -p "Wrong option, Enter again: " option
				done

				case "$option" in
				cpu)
					lscpu
					;;
				mem)
					cat /proc/meminfo
					;;
				disk)
					fdisk -l
					;;
				*)
					echo "Quit..."
					exit 0
					;;
				esac

for循环

	for 变量名  in 列表; do
		循环体
	done

	列表生成方式
		(1) 直接给出列表；
		(2) 整数列表：
			(a) {start..end}
			(b) $(seq [start [step]] end)
		(3) 返回列表的命令；
			$(COMMAND)
		(4) glob
		(b) 变量引用；
			$@, $*

	执行机制：
		依次将列表中的元素赋值给“变量名”; 每次赋值后即执行一次循环体; 直到列表中的元素耗尽，循环结束;


	示例：添加10个用户, user1-user10；密码同用户名；
		#!/bin/bash
		#

		if [ ! $UID -eq 0 ]; then
		    echo "Only root."
		    exit 1
		fi

		for i in {1..10}; do
		    if id user$i &> /dev/null; then
		  	echo "user$i exists."
		    else
		    	useradd user$i
			if [ $? -eq 0 ]; then
			    echo "user$i" | passwd --stdin user$i &> /dev/null
		            echo "Add user$i finished."
		        fi
		    fi
		done

	示例：判断某路径下所有文件的类型
		#!/bin/bash
		#

		for file in $(ls /var); do
		    if [ -f /var/$file ]; then
			echo "Common file."
		    elif [ -L /var/$file ]; then
			echo "Symbolic file."
		    elif [ -d /var/$file ]; then
			echo "Directory."
		    else
			echo "Other type."
		    fi
		done

	示例：
		#!/bin/bash
		#
		declare -i estab=0
		declare -i listen=0
		declare -i other=0

		for state in $( netstat -tan | grep "^tcp\>" | awk '{print $NF}'); do
		    if [ "$state" == 'ESTABLISHED' ]; then
			let estab++
		    elif [ "$state" == 'LISTEN' ]; then
			let listen++
		    else
			let other++
		    fi
		done

		echo "ESTABLISHED: $estab"
		echo "LISTEN: $listen"
		echo "Unkown: $other"

while循环

	while CONDITION; do
		循环体
	done

	CONDITION：循环控制条件；进入循环之前，先做一次判断；每一次循环之后会再次做判断；
	条件为“true”，则执行一次循环；直到条件测试状态为“false”终止循环；

	进入条件：CONDITION为true；
	退出条件：false

	因此：CONDTION一般应该有循环控制变量；而此变量的值会在循环体不断地被修正；

	示例：求100以内所有正整数之和；
		#!/bin/bash
		#
		declare -i sum=0
		declare -i i=1

		while [ $i -le 100 ]; do
		    let sum+=$i
		    let i++
		done

		echo "$i"
		echo "Summary: $sum."

	练习：添加10个用户
		user1-user10

		#!/bin/bash
		#
		declare -i i=1
		declare -i users=0

		while [ $i -le 10 ]; do
		    if ! id user$i &> /dev/null; then
			useradd user$i
		  	echo "Add user: user$i."
		        let users++
		    fi
		    let i++
		done

		echo "Add $users users."

until循环

	until CONDITION; do
		循环体
	done

	进入条件：false
	退出条件：true

	示例：求100以内所正整数之和；
		#!/bin/bash
		#
		declare -i i=1
		declare -i sum=0

		until [ $i -gt 100 ]; do
		    let sum+=$i
		    let i++
		done

		echo "Sum: $sum"

	示例：打印九九乘法表
		#!/bin/bash
		#
		declare -i j=1
		declare -i i=1

		until [ $j -gt 9 ]; do
		    until [ $i -gt $j ]; do
				echo -n -e "${i}X${j}=$[$i*$j]\t"
		        let i++
		    done
		    echo
		    let i=1
		    let j++
		done

循环控制语句

	用于循环体中
	continue [N]：提前结束第N层的本轮循环，而直接进入下一轮判断；（N从内而外结束）
		while CONDTIITON1; do
			CMD1
			...
			if CONDITION2; then
				continue
			fi
			CMDn
			...
		done

	break [N]：提前结束循环；
		while CONDTIITON1; do
			CMD1
			...
			if CONDITION2; then
				break
			fi
			CMDn
			...
		done

	示例1：求100以内所有偶数之和；要求循环遍历100以内的所正整数；
		#!/bin/bash
		#
		declare -i i=0
		declare -i sum=0

		until [ $i -gt 100 ]; do
		    let i++
		    if [ $[$i%2] -eq 1 ]; then
				continue
		    fi
		    let sum+=$i
		done

		echo "Even sum: $sum"

创建死循环

	创建死循环：
		while true; do
			循环体
		done

		until false; do
			循环体
		done

		示例2：每隔3秒钟到系统上获取已经登录的用户的信息；如果docker登录了，则记录于日志中，并退出；
			#!/bin/bash
			#
			read -p "Enter a user name: " username

			while true; do
					if who | grep "^$username" &> /dev/null; then
					break
					fi
					sleep 3
			done

			echo "$username logged on." >> /tmp/user.log

			第二种实现：
			#!/bin/bash
			#
			read -p "Enter a user name: " username

			until who | grep "^$username" &> /dev/null; do
					sleep 3
			done

			echo "$username logged on." >> /tmp/user.log

while循环的特殊用法（遍历文件的每一行）

	while read line; do
		循环体
	done < /PATH/FROM/SOMEFILE

	依次读取/PATH/FROM/SOMEFILE文件中的每一行，且将行赋值给变量line:

	示例：找出其ID号为偶数的所有用户，显示其用户名及ID号；
		#!/bin/bash
		while read line;do
		        if [ $[`echo $line | cut -d: -f3` % 2] -eq 0 ];then
		                echo -e -n "username: `echo $line | cut -d: -f1`\t"
		                echo "uid: `echo $line | cut -d: -f3 `"
		        fi
		done < /etc/passwd

for循环的特殊格式
	for ((控制变量初始化;条件判断表达式;控制变量的修正表达式)); do
		循环体
	done

	控制变量初始化：仅在运行到循环代码段时执行一次；
	控制变量的修正表达式：每轮循环结束会先进行控制变量修正运算，而后再做条件判断；

	示例：求100以内所正整数之和；
		#!/bin/bash
		#
		declare -i sum=0

		for ((i=1;i<=100;i++)); do
		    let sum+=$i
		done

		echo "Sum: $sum."

	示例2：打印九九乘法表；
		#!/bin/bash
		#

		for((j=1;j<=9;j++));do
		        for((i=1;i<=j;i++))do
		            echo -e -n "${i}X${j}=$[$i*$j]\t"
		        done
		        echo
		done

	练习：写一个脚本，完成如下任务
		(1) 显示一个如下菜单：
			cpu) show cpu information;
			mem) show memory information;
			disk) show disk information;
			quit) quit
		(2) 提示用户选择选项；
		(3) 显示用户选择的内容；

			#!/bin/bash
			#
			cat << EOF
			cpu) show cpu information;
			mem) show memory information;
			disk) show disk information;
			quit) quit
			============================
			EOF

			read -p "Enter a option: " option
			while [ "$option" != 'cpu' -a "$option" != 'mem' -a "$option" != 'disk' -a "$option" != 'quit' ]; do
			    read -p "Wrong option, Enter again: " option
			done

			if [ "$option" == 'cpu' ]; then
			    lscpu
			elif [ "$option" == 'mem' ]; then
			    cat /proc/meminfo
			elif [ "$option" == 'disk' ]; then
			    fdisk -l
			else
			    echo "Quit"
			    exit 0
			fi

		进一步地：
			用户选择，并显示完成后不退出脚本；而是提示用户继续选择显示其它内容；直到使用quit方始退出；

function:函数

	过程式编程：代码重用
		模块化编程
		结构化编程

	语法一：
		function f_name {
			...函数体...
		}

	语法二：
		f_name() {
			...函数体...
		}

	调用：函数只有被调用才会执行；
		调用：给定函数名
			函数名出现的地方，会被自动替换为函数代码；

		函数的生命周期：被调用时创建，返回时终止；
			return命令返回自定义状态结果；
				0：成功
				1-255：失败

		#!/bin/bash
		#
		function adduser {
		   if id $username &> /dev/null; then
		        echo "$username exists."
		        return 1
		   else
		        useradd $username
		        [ $? -eq 0 ] && echo "Add $username finished." && return 0
		   fi
		}

		for i in {1..10}; do
		    username=myuser$i
		    adduser
		done

		示例：服务脚本
			#!/bin/bash
			#
			# chkconfig: - 88 12
			# description: test service script
			#
			prog=$(basename $0)
			lockfile=/var/lock/subsys/$prog

			start() {
			    if [ -e $lockfile ]; then
				echo "$prog is aleady running."
				return 0
			    else
				touch $lockfile
				[ $? -eq 0 ] && echo "Starting $prog finished."
			    fi
			}

			stop() {
			    if [ -e $lockfile ]; then
				rm -f $lockfile && echo "Stop $prog ok."
			    else
				echo "$prog is stopped yet."
			    fi
			}

			status() {
			    if [ -e $lockfile ]; then
				echo "$prog is running."
			    else
				echo "$prog is stopped."
			    fi
			}

			usage() {
			    echo "Usage: $prog {start|stop|restart|status}"
			}

			if [ $# -lt 1 ]; then
			    usage
			    exit 1
			fi

			case $1 in
			start)
				start
				;;
			stop)
				stop
				;;
			restart)
				stop
				start
				;;
			status)
				status
				;;
			*)
				usage
			esac

		练习：打印九九乘法表，利用函数实现；

	函数返回值：
		函数的执行结果返回值：
			(1) 使用echo或print命令进行输出；
			(2) 函数体中调用命令的执行结果；
		函数的退出状态码：
			(1) 默认取决于函数体中执行的最后一条命令的退出状态码；
			(2) 自定义退出状态码：
				return

	函数可以接受参数：
		传递参数给函数：调用函数时，在函数名后面以空白分隔给定参数列表即可；例如“testfunc arg1 arg2 ...”

		在函数体中当中，可使用$1, $2, ...调用这些参数；还可以使用$@, $*, $#等特殊变量；

		示例：添加10个用户
			#!/bin/bash
			#
			function adduser {
			   if [ $# -lt 1 ]; then
				return 2
				# 2: no arguments
			   fi

			   if id $1 &> /dev/null; then
				echo "$1 exists."
				return 1
			   else
				useradd $1
				[ $? -eq 0 ] && echo "Add $1 finished." && return 0
			   fi
			}

			for i in {1..10}; do
			    adduser myuser$i
			done

		练习：打印NN乘法表，使用函数实现；

	变量作用域：
		本地变量：当前shell进程；为了执行脚本会启动专用的shell进程；因此，本地变量的作用范围是当前shell脚本程序文件；
		局部变量：函数的生命周期；函数结束时变量被自动销毁；
			如果函数中有局部变量，其名称同本地变量；

		在函数中定义局部变量的方法：
			local NAME=VALUE

	函数递归：
		函数直接或间接调用自身；

		N!=N(n-1)(n-2)...1
			n(n-1)! = n(n-1)(n-2)!

			#!/bin/bash
			#
			fact() {
			    if [ $1 -eq 0 -o $1 -eq 1 ]; then
					echo 1
			    else
					echo $[$1*$(fact $[$1-1])]
			    fi
			}

			fact 5

		练习：求n阶斐波那契数列；
			#!/bin/bash
			#
			fab() {
			    if [ $1 -eq 1 ]; then
				echo 1
			    elif [ $1 -eq 2 ]; then
				echo 1
			    else
				echo $[$(fab $[$1-1])+$(fab $[$1-2])]
			    fi
			}

			fab 7

function 数组 {
		变量：存储单个元素的内存空间；
		数组：存储多个元素的连续的内存空间；
			数组名
			索引：编号从0开始，属于数值索引；
				注意：索引也可支持使用自定义的格式，而不仅仅是数值格式；
					  bash的数组支持稀疏格式；

			引用数组中的元素：${ARRAY_NAME[INDEX]}

		声明数组：
			declare -a ARRAY_NAME
			declare -A ARRAY_NAME: 关联数组；

		数组元素的赋值：
			(1) 一次只赋值一个元素；
				ARRAY_NAME[INDEX]=VALUE
					weekdays[0]="Sunday"
					weekdays[4]="Thursday"
			(2) 一次赋值全部元素：
				ARRAY_NAME=("VAL1" "VAL2" "VAL3" ...)
			(3) 只赋值特定元素：
				ARRAY_NAME=([0]="VAL1" [3]="VAL2" ...)
			(4) read -a ARRAY

		引用数组元素：${ARRAY_NAME[INDEX]}
			注意：省略[INDEX]表示引用下标为0的元素；

		（#引用）数组的长度(数组中元素的个数)：${#ARRAY_NAME[*]}, ${#ARRAY_NAME[@]}

			示例：生成10个随机数保存于数组中，并找出其最大值和最小值；
				#!/bin/bash
				#
				declare -a rand
				declare -i max=0

				for i in {0..9}; do
				    rand[$i]=$RANDOM
				    echo ${rand[$i]}
				    [ ${rand[$i]} -gt $max ] && max=${rand[$i]}
				done

				echo "Max: $max"

			练习：写一个脚本
				定义一个数组，数组中的元素是/var/log目录下所有以.log结尾的文件；要统计其下标为偶数的文件中的行数之和；

					#!/bin/bash
					#
					declare -a files
					files=(/var/log/*.log)
					declare -i lines=0

					for i in $(seq 0 $[${#files[*]}-1]); do
					    if [ $[$i%2] -eq 0 ];then
						let lines+=$(wc -l ${files[$i]} | cut -d' ' -f1)
					    fi
					done

					echo "Lines: $lines."

		引用数组中的元素：
			所有元素：${ARRAY[@]}, ${ARRAY[*]}

			数组切片：${ARRAY[@]:offset:number}
				offset: 要跳过的元素个数
				number: 要取出的元素个数，取偏移量之后的所有元素：${ARRAY[@]:offset}；

		向数组中追加元素： 				#（如果0元素不存在 会赋值给[0]，并删除其他）
			ARRAY[${#ARRAY[*]}]

		删除数组中的某元素：
			unset ARRAY[INDEX]

		关联数组：
			declare -A ARRAY_NAME
			ARRAY_NAME=([index_name1]='val1' [index_name2]='val2' ...)

		练习：生成10个随机数，升序或降序排序；
}
function bash的字符串处理工具 {
		字符串切片：
			${var:offset:number}
			取字符串的最右侧几个字符：${var: -lengh}
				注意：冒号后必须有一空白字符；

		基于模式取子串：
			${var#*word}：其中word可以是指定的任意字符；功能：自左而右，查找var变量所存储的字符串中，第一次出现的word, 删除字符串开头至第一次出现word字符之间的所有字符；
			${var##*word}：同上，不过，删除的是字符串开头至最后一次由word指定的字符之间的所有内容；
				file="/var/log/messages"
				${file##*/}: messages

			${var%word*}：其中word可以是指定的任意字符；功能：自右而左，查找var变量所存储的字符串中，第一次出现的word, 删除字符串最后一个字符向左至第一次出现word字符之间的所有字符；
				file="/var/log/messages"
				${file%/*}: /var/log

			${var%%word*}：同上，只不过删除字符串最右侧的字符向左至最后一次出现word字符之间的所有字符；

			示例：url=http://www.magedu.com:80
				${url##*:}
				${url%%:*}

		查找替换：
			${var/pattern/substi}：查找var所表示的字符串中，第一次被pattern所匹配到的字符串，以substi替换之；
			${var//pattern/substi}: 查找var所表示的字符串中，所有能被pattern所匹配到的字符串，以substi替换之；

			${var/#pattern/substi}：查找var所表示的字符串中，行首被pattern所匹配到的字符串，以substi替换之；
			${var/%pattern/substi}：查找var所表示的字符串中，行尾被pattern所匹配到的字符串，以substi替换之；

		查找并删除：
			${var/pattern}：查找var所表示的字符串中，删除第一次被pattern所匹配到的字符串
			${var//pattern}：
			${var/#pattern}：
			${var/%pattern}：

		字符大小写转换：
			${var^^}：把var中的所有小写字母转换为大写；
			${var,,}：把var中的所有大写字母转换为小写；

		变量赋值：
			${var:-value}：如果var为空或未设置，那么返回value；否则，则返回var的值；
			${var:=value}：如果var为空或未设置，那么返回value，并将value赋值给var；否则，则返回var的值；

			${var:+value}：如果var不空，则返回value；
			${var:?error_info}：如果var为空或未设置，那么返回error_info；否则，则返回var的值；

	为脚本程序使用配置文件：
		(1) 定义文本文件，每行定义“name=value”
		(2) 在脚本中source此文件即可

	命令：
		mktemp命令：
			mktemp [OPTION]... [TEMPLATE]
				TEMPLATE: filename.XXX
					XXX至少要出现三个；
				OPTION：
					-d: 创建临时目录；
					--tmpdir=/PATH/TO/SOMEDIR：指明临时文件目录位置；

		# filename=$(mktemp /tmp.text.XXX) 直接引用

		install命令：
	       install [OPTION]... [-T] SOURCE DEST
	       install [OPTION]... SOURCE... DIRECTORY
	       install [OPTION]... -t DIRECTORY SOURCE...
	       install [OPTION]... -d DIRECTORY...
	       		选项：
	       			-m MODE
	       			-o OWNER
	       			-g GROUP

	练习：写一个脚本
		(1) 提示用户输入一个可执行命令名称；
		(2) 获取此命令所依赖到的所有库文件列表；
		(3) 复制命令至某目标目录(例如/mnt/sysroot)下的对应路径下；
			/bin/bash ==> /mnt/sysroot/bin/bash
			/usr/bin/passwd ==> /mnt/sysroot/usr/bin/passwd
		(4) 复制此命令依赖到的所有库文件至目标目录下的对应路径下：
			/lib64/ld-linux-x86-64.so.2 ==> /mnt/sysroot/lib64/ld-linux-x86-64.so.2

		进一步地：
			每次复制完成一个命令后，不要退出，而是提示用户键入新的要复制的命令，并重复完成上述功能；直到用户输入quit退出；
}
function exercise {
	---------------------------------
	function for {
		练习1：/etc/rc.d/rc3.d目录下分别有多个以K开头和以S开头的文件；
		分别读取每个文件，以K开头的文件输出为文件加stop，以S开头的文件输出为文件名加start；
			“K34filename stop”
			“S66filename start”

			练习2：写一个脚本，使用ping命令探测172.16.250.1-254之间的主机的在线状态；

			通过ping命令探测172.16.250.1-254范围内的所有主机的在线状态；
		#!/bin/bash
		#
		net='172.16.250'
		uphosts=0
		downhosts=0

		for i in {1..20}; do
				ping -c 1 -w 1 ${net}.${i} &> /dev/null
				if [ $? -eq 0 ]; then
			echo "${net}.${i} is up."
						let uphosts++
				else
			echo "${net}.${i} is down."
						let downhosts++
				fi
		done

		echo "Up hosts: $uphosts."
		echo "Down hosts: $downhosts."
		--------------------------------------
	}
	function while {

		练习：通过ping命令探测172.16.250.1-254范围内的所有主机的在线状态；(用while循环)
		#!/bin/bash
		#
		declare -i i=1
		declare -i uphosts=0
		declare -i downhosts=0
		net='172.16.250'

		while [ $i -le 20 ]; do
				if ping -c 1 -w 1 $net.$i &> /dev/null; then
				echo "$net.$i is up."
				let uphosts++
				else
				echo "$net.$i is down."
				let downhosts++
				fi
				let i++
		done

		echo "Up hosts: $uphosts."
		echo "Down hosts: $downhosts."

		练习：打印九九乘法表；(分别使用for和while循环实现)
		#!/bin/bash
		#

		for j in {1..9}; do
				for i in $(seq 1 $j); do
				echo -e -n "${i}X${j}=$[$i*$j]\t"
				done
				echo
		done

		#!/bin/bash
		#
		declare -i i=1
		declare -i j=1

		while [ $j -le 9 ]; do
				while [ $i -le $j ]; do
				echo -e -n "${i}X${j}=$[$i*$j]\t"
				let i++
				done

				echo
				let i=1
				let j++
		done


		练习：利用RANDOM生成10个随机数字，输出这个10数字，并显示其中的最大者和最小者；

		#!/bin/bash
		#
		declare -i max=0
		declare -i min=0
		declare -i i=1


		while [ $i -le 9 ]; do
				rand=$RANDOM
				echo $rand

				if [ $i -eq 1 ]; then
				max=$rand
				min=$rand
				fi

				if [ $rand -gt $max ]; then
				max=$rand
				fi
				if [ $rand -lt $min ]; then
				min=$rand
				fi
				let i++
		done

		echo "MAX: $max."
		echo "MIN: $min."
	}

}
