#!/bin/bash
#定义待清理的命名空间
list=$(cat /root/reg_ns_list.txt)
# 遍历空间
for kongjian in $list
do
sh /root/gc_registry_prefix.sh -h "https://10.10.150.105" -a "admin:dangerous" -d -p "count=4" -n $kongjian >> /tmp/clean_reg_ns.log 2>>/tmp/cs.log
echo "clean $kongjian was done,thanks"
done
