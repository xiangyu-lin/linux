# sudo

> 授权之后，能够让某用户以另外一个用户的身份运行命令； #不需要密码

## 配置文件  */etc/sudoers*

	# visudo -f /etc/sudoers
	> visudo 检查语法

	 **root			ALL=(ALL) 		ALL
		 %wheel		ALL=(ALL)			ALL**
>
	who: 运行命令者的身份，user
	where: 通过哪些主机，host
	(whom)：以哪个用户的身份, runas
	which: 运行哪些命令，command
	wheel:用户组

## 配置选项

	**users 	hosts=(runas) 	commands**

	**users**
			username; #uid; user_alias
			%group_name; %#gid

	**host**
			ip; hostname; netaddr

	**command**
			command name; directory; sudoedit

	Alias_Type NAME = item1, item2, ...
		NAME: 必须使用全大写字母；
		Alias_Type:
			User_Alias; Host_Alias; Runas_Alias;Cmnd_Alias

	```
	User_Alias ADMINUSERS = admin1,admin2,lin
	Cmnd_Alias ADMINCOM = /usr/bin/passwd [a-z]*,!/usr/bin/passwd root
	ADMINUSERS ALL=(ALL) ADMINCOM
	#授权passwd命令 但不允许改root密码
	```

## sudo命令
`sudo [-u user] COMMAND`

	-u user: 默认为root;
	-k: 清除此前记录用户密码；将会强迫使用者在下一次执行sudo时问密码
	-b: 后台运行
	-l: 查看当前用户拥有的权限
