#!/bin/bash
# checkPid and send wechat notify
# Author: webmaster@wanjie.info
set -e
send(){
    key=你的方糖密钥
    title=Node14当前Pid个数
    content=$(ps -eLf |wc -l)
    curl "http://sc.ftqq.com/$key.send?text=$title&desp=$content" >/dev/null 2>&1 &
}
kaobei(){
   cp /var/log/dmesg /root/dmesg
    touch /root/pid-history.log
    date  >> /root/pid-history.log
    ps -eLf |wc -l >> /root/pid-history.log
}

count=`ps -eLf |wc -l`
if [ $count -gt 1000 ];then
    send
    kaobei
fi
