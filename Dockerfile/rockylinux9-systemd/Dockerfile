FROM cnrock/os:rockylinux9-systemd.mini
LABEL maintainer="Jie.Wan <webmaster@wanjie.info>"

RUN dnf -y install epel-release && dnf  update -y && \
    dnf -y install procps-ng systemd-udev && \
    dnf -y install net-tools iputils  && \
    dnf -y install python3-setuptools python3-pip && \
#    dnf install kernel && dracut -f /boot/initramfs-$(uname -r).img $(uname -r) && dnf config-manager --set-default kernel && \
 dnf -y install kernel 
RUN  dracut -f  /boot/initramfs-5.14.0-284.11.1.el9_2.x86_64.img 5.14.0-284.11.1.el9_2.x86_64 && dnf config-manager --set-default kernel && \
    yum clean all && dnf clean packages

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -rf /lib/systemd/system/multi-user.target.wants/* && \
    rm -rf /etc/systemd/system/*.wants/* && \
    rm -rf /lib/systemd/system/local-fs.target.wants/* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -rf /lib/systemd/system/basic.target.wants/* && \
    rm -rf /lib/systemd/system/systemd*udev* && \
    rm -rf /lib/systemd/system/getty.target && \
    rm -rf /lib/systemd/system/anaconda.target.wants/*

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
