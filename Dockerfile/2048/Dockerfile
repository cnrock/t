FROM --platform=$TARGETPLATFORM  alpine:latest
#FROM  alpine:latest
#FROM --platform=$TARGETPLATFORM nginx:1.24.0-alpine-slim
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>

ENV TIMEZONE="Asia/Shanghai" \
    BUILD_DEPS="tzdata \
                sudo \
                nano \
                bash \
                iperf3 \
                nginx \
                stress-ng \
                openssl \
                bind-tools"
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community stress-ng
RUN apk update && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    apk add --no-cache curl ca-certificates && \ 
    touch /etc/ca-certificates.conf && \ 
    rm -rf /var/cache/apk/*
COPY 2048 /usr/share/nginx/html
COPY 2048/default.conf /etc/nginx/http.d/default.conf
COPY Dockerfile /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
