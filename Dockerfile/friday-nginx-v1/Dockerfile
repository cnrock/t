FROM nginx:1.25.1
#FROM --platform=$TARGETPLATFORM nginx:1.25.1-alpine-slim
LABEL MAINTAINER Wan Jie <jie.wan@daocloud.io>

ENV TIMEZONE="Asia/Shanghai" \
    BUILD_DEPS="tzdata \
                sudo \
                nano \
                bash \
                dnsutils \
                bind9"
RUN apt update && \
    apt install -y ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \ 
    echo ${TIMEZONE} > /etc/timezone                        && \
    apt remove -y tzdata                                          && \
    apt install -y curl ca-certificates && \
    touch /etc/ca-certificates.conf && \
    rm -rf /var/cache/apt/*

COPY dist /usr/share/nginx/html
COPY dist/default.conf /etc/nginx/conf.d/default.conf
#COPY Dockerfile /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
