## 分区管理工具：fdisk, parted, sfdisk                                	

### fdisk
> 对于一块硬盘来讲，最多只能管理15分区；

	` fdisk -l [-u] [device...] `
    > -u 搭配"-l"参数列表，会用分区数目取代柱面数目，来表示每个分区的起始地址。

	`	fdisk device `
			p: print, 显示已有分区；
			n: new, 创建
			d: delete, 删除 可能要重启生效
			w: write, 写入磁盘并退出
			q: quit, 放弃更新并退出
			m: 获取帮助
			l: 列表所分区id
			t: 调整分区id

### parted #用于大容量分区 脚本自动化分区
```
    parted /dev/sdb mklabel gpt 修改分区表格式
    parted /dev/sdb mkpart primary ext3 1 2G #创建一个2G分区
    parted /dev/sdb mkpart primary ext3 2G 4G #创建另一个2G分区
    parted /dev/sdb print #查看分区信息
    parted /dev/sdb rm 2 #删除sdb2
```
---
### 查看内核是否已经识别新的分区
    cat /proc/partations

### 通知内核重新读取硬盘分区表
    partx -a /dev/DEVICE
  		 		-n M:N/
    kpartx -a /dev/DEVICE
  				-f: force
    partprobe [/dev/DEVICE]
    > CentOS 5: 使用partprobe
