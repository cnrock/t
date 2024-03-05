#FROM centos:7
FROM --platform=$TARGETPLATFORM rockylinux:9
#FROM --platform=$TARGETPLATFORM rockylinux/rockylinux:9.1
LABEL maintainer="Jie.Wan <webmaster@wanjie.info>"

RUN  dnf -y update && \
    dnf -y install epel-release && \ 
     dnf -y install snapd systemd && \ 
     systemctl enable --now snapd.socket && \
    dnf  -y install net-tools iputils systemd git   python3 python3-pip python3-setuptools && \
    yum -y clean all

RUN cd /tmp && \
    git clone https://github.com/novnc/websockify.git && \
     cd websockify/ && python3 setup.py install

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/systemd*udev* && \
    rm -f /lib/systemd/system/getty.target && \
    rm -f /lib/systemd/system/anaconda.target.wants/*
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
