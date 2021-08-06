#!/bin/bash
list=$(cat /root/reg-ns-list.txt)
for kongjian in $list
do
bash -x  /root/gc-registry-prefix.sh -h "https://10.23.18.154" -a "admin:changeme"  -p "count=15" -n $kongjian >> /tmp/stdout.log 2>>/tmp/stderr.log
echo "clean $kongjian was done,thanks"
sleep 5
docker exec -it dce_registry_1 registry garbage-collect /etc/docker/registry/conf.yml >> /tmp/gc.log 2>&1
done
