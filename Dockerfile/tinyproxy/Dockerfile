###############################################################################
# Name:         Dockerfile
# Author:       Daniel Middleton <daniel-middleton.com>
# Mod:          webmaster@wanjie.info
# Mod for mutil arch amd64 & arm64
# Description:  Dockerfile used to build dannydirect/tinyproxy
# Usage:        docker build -t dannydirect/tinyproxy:latest .
# Usage:        docker build -t cnrock/tinyproxy:latest .
###############################################################################

#FROM --platform=$TARGETPLATFORM alpine:latest
#LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>
FROM alpine:edge

LABEL maintainer="Wan Jie <webmaster@wanjie.info>" \
      version="1.11.3" \
      description="Alpine Linux BaseImage，tinyproxy"

COPY run.sh /opt/docker-tinyproxy/run.sh


RUN apk add --no-cache \
    bash \
    tinyproxy && \
    chmod a+x /opt/docker-tinyproxy/run.sh

ENTRYPOINT ["/opt/docker-tinyproxy/run.sh"]
