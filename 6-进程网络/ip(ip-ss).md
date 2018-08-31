# ip ss

ip 命令

> ip - show / manipulate routing, devices, policy routing and tunnels

	ip [ OPTIONS ] OBJECT { COMMAND | help }

		OBJECT =  link | addr | route

	link OBJECT

		ip link - network device configuration

			set
				dev IFACE
				可设置属性：
					up and down：激活或禁用指定接口；

			show
				[dev IFACE]：指定接口
				[up]：仅显示处于激活状态的接口

		ip address - protocol address management

			ip addr { add | del } IFADDR dev STRING
				[label LABEL]：添加地址时指明网卡别名
				[scope {global|link|host}]：指明作用域
					global: 全局可用；
					link: 仅链接可用；
					host: 本机可用；
				[broadcast ADDRESS]：指明广播地址

			ip address show - look at protocol addresses
				[dev DEVICE]
				[label PATTERN]
				[primary and secondary]

			ip address flush - flush protocol addresses
				使用格式同show

		ip route - routing table management

			ip route add
				添加路由：ip route add TARGET via GW dev IFACE src SOURCE_IP
					TARGET:
						主机路由：IP
						网络路由：NETWORK/MASK

					添加网关：ip route add defalt via GW dev IFACE

			ip route delete
				删除路由：ip route del TARGET

			ip route show
			ip route flush
				[dev IFACE]
				[via PREFIX]

ss命令：
	格式：ss [OPTION]... [FILTER]
		选项：
			-t: tcp协议相关
			-u: udp协议相关
			-w: 裸套接字相关
			-x：unix sock相关
			-l: listen状态的连接
			-a: 所有
			-n: 数字格式
			-p: 相关的程序及PID
			-e: 扩展的信息
			-m：内存用量
			-o：计时器信息

			FILTER := [ state TCP-STATE ] [ EXPRESSION ]

	TCP的常见状态：
		tcp finite state machine:
			LISTEN: 监听
			ESTABLISHED：已建立的连接
			FIN_WAIT_1
			FIN_WAIT_2
			SYN_SENT
			SYN_RECV
			CLOSED

		EXPRESSION:
			dport =
			sport =
			示例：’( dport = :ssh or sport = :ssh )’

	常用组合：
		-tan, -tanl, -tanlp, -uan
