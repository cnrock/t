FROM --platform=$TARGETPLATFORM alpine:3.12
LABEL MAINTAINER wanjie <webmaster@wanjie.info>

ENV TIMEZONE="Asia/Shanghai" \
    BUILD_DEPS="tzdata \
                curl \
                sudo \
                bash \
                iptables \
                ip6tables \
                awall \
                nginx"
RUN apk update && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    rm -rf /var/cache/apk/*

COPY 2048 /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
