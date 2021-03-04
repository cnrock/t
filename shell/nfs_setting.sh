#!/bin/bash
# powered by zzg
set -e
echo "当前分享的目录:"
NFS_IP="10.23.2.249"
NFS_DIR="/nfs"
showmount -e $NFS_IP

read -p "请输入一个新的共享目录名称, eg: registry_10.23.100.1 :" dir_name
if [ -d $NFS_DIR/$dir_name ] ;then
  echo "dir have been used,try again "
  exit 1
fi

mkdir $NFS_DIR/$dir_name
echo "$NFS_DIR/$dir_name  10.23.0.0/8(rw,sync,no_root_squash)" >>/etc/exports
systemctl restart nfs
showmount -e $NFS_IP
echo "look like successed, use \" showmount -e $NFS_IP \" at clinet to test"
