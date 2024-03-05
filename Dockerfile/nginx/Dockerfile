FROM nginx:mainline-alpine3.18
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>
ENV TIMEZONE="Asia/Shanghai" \
    BUILD_DEPS="tzdata \
                sudo \
                nano \
                bash \
                iperf3 \
                nginx \
                bind-tools"
RUN apk update && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    apk add --no-cache curl ca-certificates && \
    touch /etc/ca-certificates.conf && \
    rm -rf /var/cache/apk/*
#COPY 2048 /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]    
