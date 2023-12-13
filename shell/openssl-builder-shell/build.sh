#!/bin/bash
set -ex
yum install rpm-build zlib-devel openssl-devel gcc perl-devel pam-devel unzip -y
mkdir -p /root/rpmbuild/{SOURCES,SPECS}
cd /root/rpmbuild/SOURCES
if [[ ! -f "openssh-8.8p1.tar.gz" ]];then
wget -c https://mirrors.mit.edu/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz

fi
if [[ ! -f "x11-ssh-askpass-1.2.4.1.tar.gz" ]];then
wget -c https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz
fi
tar zxvf openssh-8.8p1.tar.gz openssh-8.8p1/contrib/redhat/openssh.spec
mv openssh-8.8p1/contrib/redhat/openssh.spec ../SPECS/
chown sshd:sshd /root/rpmbuild/SPECS/openssh.spec
cp /root/rpmbuild/SPECS/openssh.spec /root/rpmbuild/SPECS/openssh.spec_def
sed -i -e "s/%global no_gnome_askpass 0/%global no_gnome_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
sed -i -e "s/%global no_x11_askpass 0/%global no_x11_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
sed -i -e "s/^BuildRequires: openssl-devel < 1.1/#BuildRequires: openssl-devel < 1.1/g" /root/rpmbuild/SPECS/openssh.spec
sed -i -e '/with-privsep-path/a\ --with-openssl-includes=/usr/local/openssl/include \\\n --with-ssl-dir=/usr/local/openssl \\' /root/rpmbuild/SPECS/openssh.spec
cd /root/rpmbuild/SPECS/
rpmbuild -ba openssh.spec