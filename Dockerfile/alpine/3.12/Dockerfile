FROM  alpine:latest

LABEL maintainer="Wan Jie <webmaster@wanjie.info>" \
      version="1.0.0" \
      description="Alpine Linux BaseImage，include curl,bash,openssh,bind-tools with ShangHai timezone"

ENV TIMEZONE="Asia/Shanghai"              \
    BUILD_DEPS="tzdata \
                curl \
                sudo \
                bash \
                dnscache \
                openssh-client \
                bind-tools \
                pciutils \
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
