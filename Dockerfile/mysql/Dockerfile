FROM mysql:5.7.29

MAINTAINER wanjie <jie.wan@daocloud.io>

# time zone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=C.UTF-8

COPY "mysql.cnf" "/etc/mysql/conf.d"
