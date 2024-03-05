FROM amazoncorretto:8u362-al2023-jre
ENV JAVA_TOOL_OPTIONS="-Duser.timezone=Asia/Shanghai" \
    TZ="Asia/Shanghai"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN yum install libnsl tar unzip -y
COPY ./lrzsz.rpm ./
RUN  rpm -ivh lrzsz.rpm &&  rm -rf /var/cache/yum/*  && yum clean all
