FROM --platform=$TARGETPLATFORM alpine:3.16.2
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>

ENV TIMEZONE="Asia/Shanghai" \
    BUILD_DEPS="tzdata \
                curl \
                sudo \
                nano \
                bash \
                bind-tools \
                busybox=1.35.0-r17 \
                nginx=1.22.1-r0"
RUN apk update && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    rm -rf /var/cache/apk/*
RUN source ~/.bashrc
COPY 2048 /usr/share/nginx/html
COPY 2048/default.conf /etc/nginx/http.d/default.conf
COPY Dockerfile /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
