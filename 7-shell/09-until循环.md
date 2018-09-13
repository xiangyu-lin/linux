## until循环
语法
```
until CONDITION; do
	循环体
done
```
> 进入条件：false 退出条件：true

创建死循环
```
until false; do
	循环体
done

```
---

示例：求100以内所正整数之和；
```
#!/bin/bash
#
declare -i i=1
declare -i sum=0

until [ $i -gt 100 ]; do
    let sum+=$i
    let i++
done

echo "Sum: $sum"
```

示例：打印九九乘法表
```
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
```
