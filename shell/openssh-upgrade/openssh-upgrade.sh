#!/bin/bash

clear
echo ------------------------------------------
echo        CentOS7 openssh升级到8.4p1--online
echo            By feichai
echo            Mod cnrock
echo         生产环境使用前请做好测试
echo ------------------------------------------
sleep 3s
clear
echo 下载关键包
wget http://cdn.download.fcblog.cn/openssl-1.0.2r.tar.gz
wget http://cdn.download.fcblog.cn/openssh-8.4p1.tar.gz
wget http://cdn.download.fcblog.cn/zlib-1.2.11.tar.gz
echo 安装进程开始
sleep 1s
clear
echo 刷新yum元数据缓存
echo $(date +%F-%T)  刷新yum元数据缓存开始…… >> update.log
sleep 2s
yum makecache
echo $(date +%F-%T)  刷新yum元数据缓存结束…… >> update.log
sleep 1s
clear
echo 检测安装telnet服务
echo $(date +%F-%T)  检测telnet服务开始…… >> update.log
sleep 1s
echo 尝试启动telnet服务
sleep 2s
systemctl restart telnet.socket &&  systemctl restart xinetd
ps -ef |grep xinetd | egrep -v grep > /dev/null
if [ $? -eq 0 ]
then
    echo 检测到telnet服务已启动……
    systemctl enable telnet.socket
    systemctl enable xinetd
    echo $(date +%F-%T)  检测到telnet服务并启动…… >> update.log
    sleep 2s
else
    echo 未检测到telnet服务，开始安装服务……
    echo $(date +%F-%T)  未检测到telnet服务，开始安装…… >> update.log
    sleep 2s
    yum -y install xinetd telnet-server
    cp /etc/securetty /etc/securetty.bak
    echo "pts/0" >> /etc/securetty
    echo "pts/1" >> /etc/securetty
    echo $(date +%F-%T)  安装telnet服务结束…… >> update.log
    sleep 2s
    clear
    echo 安装telnet服务结束，启动服务……
    echo $(date +%F-%T)  启动telnet服务开始…… >> update.log
    systemctl restart telnet.socket &&  systemctl restart xinetd
        systemctl enable telnet.socket
    systemctl enable xinetd
    echo $(date +%F-%T)  启动telnet服务结束…… >> update.log
    sleep 1s
fi
clear
echo 关闭SElinux并禁用……
echo $(date +%F-%T)  关闭SElinux并禁用开始…… >> update.log
sleep 2s
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
cat /etc/selinux/config
sleep 2s
echo $(date +%F-%T)  关闭SElinux并禁用结束…… >> update.log
clear
echo 安装程序依赖包……
echo $(date +%F-%T)  安装程序依赖包开始…… >> update.log
sleep 2s
yum -y install gcc gcc-c++ make pam pam-devel openssl-devel pcre-devel perl zlib-devel
echo $(date +%F-%T)  安装程序依赖包结束…… >> update.log
sleep 1s
clear
echo 停止并卸载原有ssh
echo $(date +%F-%T)  停止并卸载原有ssh开始…… >> update.log
sleep 2s
systemctl stop sshd
cp -r /etc/ssh /etc/ssh.old
cp /etc/init.d/ssh /etc/init.d/ssh.old
rpm -qa | grep openssh
sleep 1s
rpm -e `rpm -qa | grep openssh` --nodeps
rpm -qa | grep openssh
echo $(date +%F-%T)  停止并卸载原有ssh结束…… >> update.log
sleep 1s
clear
echo 安装zlib
echo $(date +%F-%T)  安装zlib开始…… >> update.log
sleep 2s
tar -zxvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/usr/local/zlib && make && make install
ls -l /usr/local/zlib
cd ..
echo $(date +%F-%T)  安装zlib结束…… >> update.log
sleep 1s
clear
echo 配置zlib
echo $(date +%F-%T)  配置zlib开始…… >> update.log
echo "/usr/local/zlib/lib" >> /etc/ld.so.conf.d/zlib.conf
ldconfig -v
sleep 1s
echo $(date +%F-%T)  配置zlib结束…… >> update.log
clear
echo 安装openssl
echo $(date +%F-%T)  安装openssl开始…… >> update.log
sleep 2s
tar -zxvf openssl-1.0.2r.tar.gz
cd openssl-1.0.2r
./config shared zlib && make && make install
cd ..
echo $(date +%F-%T)  安装openssl结束…… >> update.log
sleep 1s
clear
echo 配置openssl
echo $(date +%F-%T)  配置openssl开始…… >> update.log
sleep 2s
mv -f /usr/bin/openssl /usr/bin/openssl.bak
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf.d/ssl.conf
ldconfig -v
openssl version -a
sleep 1s
clear
echo $(date +%F-%T)  配置openssl结束…… >> update.log
echo 安装openssh
echo $(date +%F-%T)  安装openssh开始…… >> update.log
sleep 2s
rm -rf /etc/ssh
tar -zxvf openssh-8.4p1.tar.gz
cd openssh-8.4p1
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-openssl-includes=/usr/local/ssl/include --with-ssl-dir=/usr/local/ssl   --with-zlib --with-md5-passwords
make
sleep 1s
make install
cd ..
echo $(date +%F-%T)  安装openssh结束…… >> update.log
sleep 1s
clear
echo 配置openssh
echo $(date +%F-%T)  配置openssh开始…… >> update.log
sleep 2s
echo "PasswordAuthentication yes"   >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo 'Banner /etc/issue' >> /etc/ssh/sshd_config
cp -p openssh-8.4p1/contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chmod 600 /etc/ssh/ssh_host_rsa_key
chmod 600 /etc/ssh/ssh_host_ecdsa_key
chmod 600 /etc/ssh/ssh_host_ed25519_key
chkconfig --add sshd
chkconfig sshd on
systemctl restart sshd
sleep 1s
clear
echo $(date +%F-%T)  配置openssh结束…… >> update.log
systemctl status sshd
if [ $? -eq 0 ]
then
    echo SSH安装成功，开始关闭并禁用telnet
    echo $(date +%F-%T)  关闭并禁用telnet开始…… >> update.log
    sleep 2s
    systemctl stop telnet.socket &&  systemctl stop xinetd
    systemctl disable telnet.socket &&  systemctl disable xinetd
    echo $(date +%F-%T)  关闭并禁用telnet结束…… >> update.log
    clear
    echo 安装进程结束
    sleep 2s
    echo $(date +%F-%T)  安装进程结束…… >> update.log
else
    echo SSH未成功安装或配置，安装进程即将退出，请检查……
    echo $(date +%F-%T)  错误，SSH未成功安装或配置…… >> update.log
    sleep 3s
    echo -e "\n"
    echo 安装进程结束
    echo $(date +%F-%T)  安装进程结束…… >> update.log
fi
echo ------------------------------------------
ssh -V
echo ------------------------------------------
systemctl status sshd
