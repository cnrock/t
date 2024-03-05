FROM hagb/docker-easyconnect:7.6.7
LABEL MAINTAINER="webmaster@wanjie.info"

ENV TIMEZONE="Asia/Shanghai"              \
    BUILD_DEPS="tzdata \
                curl \
                sudo \
                bash \
                locales \
                ttf-wqy-microhei"

RUN apt-get update                                          && \
    apt-get upgrade                                         && \
    apt-get install ${BUILD_DEPS}                           && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    dpkg-reconfigure -f noninteractive tzdata               && \
    apt-get remove tzdata                                  && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="zh_CN.UTF-8"' > /etc/default/locale        && \
    dpkg-reconfigure --frontend=noninteractive locales      && \
    update-locale LANG=zh_CN.UTF-8                         && \
    apt-get clean                                          && \
    ENV LANG zh_CN.UTF-8                                    && \
    ENV LANGUAGE zh_CN.UTF-8                                && \
    ENV LC_ALL zh_CN.UTF-8
