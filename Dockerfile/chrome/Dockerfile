FROM  --platform=$TARGETPLATFORM cnrock/chrome:v97
LABEL maintainer="webmaster@wanjie.info"

RUN  yum -y update && \
     yum install -y deltarpm && \
     yum -y upgrade google-chrome
RUN    yum -y clean all &&  rm -rf /var/tmp/* /tmp/* /var/cache/yum/*

CMD ["/usr/sbin/init"]
