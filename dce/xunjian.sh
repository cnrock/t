#!/bin/bash
# mod by wanjie
a="\033[40;37m"
e="\033[0m"
b="\033[41;37m"
c="\033[42;37m"
f="\033[43;37m"
g="\033[44;37m"
h="\033[45;37m"
q="\033[46;37m"
echo -e "$h=========脚本适用K8S主节点&作者：wanjie======"$e
# 1.系统信息监控,CPU,内存,负载,磁盘信息
echo -e "$a--------1.系统信息监控,CPU,内存,负载,磁盘信息--" $e

zhuji=$(hostname)
echo -e "$a----主机名： $zhuji" $e

cpushu=$(cat /proc/cpuinfo | grep -i  processor | wc -l)
echo -e "$b----cpu数： $cpushu" $e

neicunshu=` cat /proc/meminfo | grep MemTotal | awk '{print $2}' `
echo -e "$b----内存大小： $neicunshu" $e
mem_in_giga=`  echo $(( $neicunshu / 1000 / 1000)) `
echo -e "$b----内存 $mem_in_giga GB  "  $e
free -h | grep Mem |  awk '{print $3,$5}'
yiyong=$(free -h | grep Mem |  awk '{print $3}')
keyong=$(free -h | grep Mem |  awk '{print $5}')
echo -e "$b----已用内存：$yiyong   可用内存 $keyong"

kaiji=$(uptime)
echo -e "$b----开机时间 $kaiji"

linux=$(cat /etc/redhat-release)
echo -e "$q----系统版本：$linux" $e
Mem=$(free -h | grep Mem: | awk '{print $4}')
echo -e "$q----系统剩余内存：$Mem" $e
# 磁盘监控看系统分区信息,这里只监控根分区
df -Th | grep -w /
CP=$(df -h | grep /dev/mapper/centos-root | awk '{print $5}')
echo -e "$q----系统磁盘使用：$CP" $e

# 镜像仓库空间的可用
df -Th /var/local/dce/registry
changku=$(df -Th /var/local/dce/registry| awk '{print $6}')
echo -e "$b-镜像仓库可用：$changku" $e

# docker数据盘的大小
docker info | grep -i "data space" | grep -vi meta

# 打开文件数，打开文件数（参考值：小于 60000）
wenjisnshu=$(lsof -w |wc -l)
echo -e "$a--打开文件数 $wenjisnshu （参考值：小于 60000）---" $e

#线程数（参考值：小于 6000）
xianchengshu=$(ps -elf | wc -l)

echo -e "$a--线程数 $xianchengshu （参考值：小于 6000）---" $e

#网络连接数（参考值：小于 1000）
lianjieshu=$(netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}')

echo -e "$a--网络连接数 $lianjieshu （参考值：小于 1000）---" $e

#echo -e "$q----检测网络---" $e
#curl -I http://cn.bing.com &>/dev/null
#if [ $? == 0 ];
#then 
#    echo -e "$q----访问外网：成功---" $e
#else
#    echo -e "$q----访问外网：失败---" $e
#fi
JH=$(crontab -l)
echo -e "$q----计划任务：$JH" $e
echo -e "$b----docker进行检查" $e
systemctl status docker | grep running  #查看docker状态是否为running如果grep到running则为状态正常
if [ $? == 0 ];   #如果上条状态码等于0
then 
   echo -e "$b----docker状态正常----" $e  #则输出状态正常
else
   echo -e "$b----docker状态不正常---请进行检查------" $e #否则输出不正常
fi
echo  -e "$a----查看Docker进程数量----" $e
docker=$(docker ps | wc -l)   #查看docker运行容器数量
echo -e "$b----Docker进程数量为：$docker" $e
echo -e "$a----查看Kubelet服务状态----" $e
systemctl status kubelet | grep running #查看kubelet服务状态是否正常
if [ $? == 0 ]; #如果上条命令状态为0
then
    echo -e "$c----Kubelet服务状态正常----"$e  #则表示kubelet服务状态为正常
else
    echo -e "$c----Kubelet服务状态异常--请进行检查---" $e #否则kubelet服务状态为异常
fi
echo -e "$a----查看K8s集群状态----"$e   #查看k8s集群状态
K8s=$(kubectl get nodes | grep Ready | wc -l)    #进行查询k8s集群节点为正常状态的节点
echo -e "$c----K8s集群节点状态为Ready的数量为：$K8s" $e
echo -e "$a----查看Etcd集群健康状态----" $e
Etcd=$(kubectl get cs | grep Health | grep etcd | wc -l) #进行查询etcd集群节点为健康状态的节点
echo -e "$c----Etcd集群节点状态为Health的数量为：$Etcd" $e


echo  -e "$b----以下为控制DCE控制阶段信息---" $e
# 2.DCE集群状态信息
# 在控制器执行即可
kubectl get cs
kubectl get nodes | grep -v Ready
kubectl get pods -o wide --all-namespaces | grep -v Running|grep -v Completed
shibai=$(kubectl get pods -o wide --all-namespaces | grep -v Running|grep -v Completed|wc -l)
echo -e "$c----失败的pod数量为：$shibai" $e

echo  -e "$c------巡检结束---请核对信息-------" $e


