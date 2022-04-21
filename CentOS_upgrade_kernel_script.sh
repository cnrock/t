#!/bin/bash
#
# Title: CentOS7.6_x64_upgrade_kernel_script
# Author: ZNing
# Date: 2019-7-3 23:13:09
# MOD by cnrock // 2022-04-21
# 修改选择时的中文注释，修改 elrepo-release-7.el7.elrepo.noarch.rpm 地址
# 如果是centos 8 ，修改  https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm 即可 ，这里未做判断，毕竟8停了
# Pass on the CentOS 7.* x64
# You should run this script three times. The first is yum update, the second is kernel upgrade to 5, the final one is optional when you decided to maunal which is deleting old kernel.
# Having fun to using it. (*^▽^*) Best wishes from Misaka Mikoto and Misaka 10086. 

clear;

function upgradeYum()
{
    yum clean all;
    yum update -y;
    reboot;
}

function upgradeKernel()
{
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org;
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm;
    yum --disablerepo="*" --enablerepo="elrepo-kernel" list available;
    yum --enablerepo=elrepo-kernel install -y kernel-lt;
    grub2-mkconfig -o /boot/grub2/grub.cfg;
    grub2-editenv list;
    awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg;
    echo -n  "please enter the latest kernel number ->";
    read  num;
    grub2-set-default $num;
    grub2-editenv list;
}

function confirmKernel()
{
    echo -n  "are the kernel changed? If it is, plz input(y),else(n) ->";
    read confirmInput;
    if [ "$confirmInput" == 'y' ]; then
		reboot;
	elif [ "$selected" == 'n' ]; then
		exit;
	else
		confirmKernel;
		return;
	fi;
}

function removeOldKernel()
{
    IFS=$'\n';
    for LINE in `rpm -qa | grep kernel- | grep 3.`; do
        #Do some works on "${LINE}"
        yum -y remove ${LINE};
    done;
    reboot;
}

function checkSystem()
{
    cat /etc/redhat-release;
    uname -sr;
    uname -a;
    echo "[Notice] Confirm Upgrade Kernel? please select: (1~4)"
    select selected in '升级所有的包' '仅升级内核至5.*-lt长期版' '删除旧内核' 'Exit'; do break; done;
	[ "$selected" == 'Exit' ] && echo 'Exit Upgrade.' && exit;
	if [ "$selected" == '升级所有的包' ]; then
		upgradeYum;
	elif [ "$selected" == '仅升级内核至5.*-lt长期版' ]; then
		upgradeKernel;
        confirmKernel;
	elif [ "$selected" == '删除旧内核' ]; then
		removeOldKernel;
	else
		ConfirmInstall;
		return;
	fi;
	echo "[OK] You Selected: ${selected}";
}

checkSystem;
