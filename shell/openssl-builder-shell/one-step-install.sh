#!/bin/bash
clear
echo ------------------------------------------
echo CentOS7 openssh升级到8.8p1
echo By wanjie
echo Mod at 2022-02-20
echo openssl-1.1.1m +openssh-8.8p1-1.el7 with rpmbuild
echo 生产环境使用前请做好测试
echo ------------------------------------------
sleep 3s
clear
echo 安装前检查ssh版本
# 安装前检查ssh版本
echo ---------------查看版本----------------------
ssh -V
# 解压离线rpm包
tar xvf openssh88.tar
# 先升級openssl
echo ---------------先升級openssl----------------------
rpm -Uvh ./openssh88/openssl-1.1.1m-1.el7.x86_64.rpm --nodeps --force
# 升级openssh88
echo ---------------升級openssh----------------------
rpm -Uvh ./openssh88/openssh*.rpm
# 修改文件权限，不然后面sshd无法重启，提示权限过高
echo ---------------修改/etc/ssh/ssh_host*文件权限----------------------
chmod 400 /etc/ssh/ssh_host_ed25519_key
chmod 400 /etc/ssh/ssh_host_rsa_key
chmod 400 /etc/ssh/ssh_host_ecdsa_key
# 允许root登陆，可选，注释#即可
echo ---------------修改是否root登陆----------------------
# echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo ---------------修改加密相关----------------------
# 修改 /etc/pam.d/sshd 文件，避免密码正确却无法登陆现象
cat /etc/pam.d/sshd
#%PAM-1.0
auth required pam_sepermit.so
auth include password-auth
account required pam_nologin.so
account include password-auth
password include password-auth
## pam_selinux.so close should be the first session rule
session required pam_selinux.so close
session required pam_loginuid.so
## pam_selinux.so open should only be followed by sessions to be executed in the user context
session required pam_selinux.so open env_params
session optional pam_keyinit.so force revoke
session include password-auth
EOF
# 重启ssh服务
systemctl restart sshd
echo ---------------查看版本----------------------
# 查看openssl版本
openssl version
# 查看ssh版本
ssh -V
# 查看状态
systemctl status sshd
# bye
echo ---------------bye----------------------