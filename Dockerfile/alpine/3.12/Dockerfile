FROM alpine:3.12
LABEL MAINTAINER="webmaster@wanjie.info"

ENV TIMEZONE="Asia/Shanghai"              \
    BUILD_DEPS="tzdata \
                curl \
                sudo \
                bash \
                dnscache \
                openssh-client \
                sshpass \
                acl"

RUN apk update                                              && \
    apk upgrade                                             && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
