FROM docker:20.10.12-alpine3.15

MAINTAINER Wan Jie <jie.wan@daocloud.io>

RUN apk --update add \
    git \
    python3 \
    py3-pip \
    jq \
    && pip install awscli \
    && pip install six \
    && apk del py3-pip \
    && rm -rf /var/cache/apk/*
