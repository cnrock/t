# https://github.com/P3TERX/openwrt-build-env
# OpenWrt build environment in docker
# MIT License
# Copyright (c) 2020 P3TERX <https://p3terx.com>
# 2022.04.14
# Mod for amd64 and arm64 by cnrock

#ARG BASE_IMAGE_TAG=20.04
ARG BASE_IMAGE_TAG=latest
FROM linuxplus/ubuntu:${BASE_IMAGE_TAG}

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG DEPENDS_LIST=depends-ubuntu-2004

RUN apt-get update -qq && \
    apt-get upgrade -qqy && \
    apt-get install -qqy $(curl -fsSL https://raw.githubusercontent.com/cnrock/t/master/D/Dockerfile/openwrt-build-env/${DEPENDS_LIST}) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER user
RUN sudo usermod -u 1001 user
RUN sudo groupmod -g 1002 user
WORKDIR /home/user
