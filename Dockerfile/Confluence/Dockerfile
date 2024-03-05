FROM atlassian/confluence-server:7.5.2
MAINTAINER wanjie <jie.wan@daocloud.io>
ENV  JAVA_OPTS='-Duser.timezone=GMT+08 -Dconfluence.document.conversion.fontpath=/usr/share/fonts/winfonts/'
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y nano fontconfig xfonts-utils \
    && apt-get clean autoclean && apt-get autoremove -y \
    && mkdir /usr/share/fonts/winfonts

COPY "mysql-connector-java-5.1.49.jar" "/opt/atlassian/confluence/lib"
COPY winfonts/ /usr/share/fonts/winfonts/
