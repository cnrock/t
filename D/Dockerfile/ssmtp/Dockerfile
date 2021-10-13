FROM alpine:$ALPINE
LABEL MAINTAINER="webmaster@wanjie.info"

ENV TIMEZONE="Asia/Shanghai"     \
    BUILD_DEPS="tzdata.          \
                curl             \
                sudo             \
			        	ca-certificates  \
			        	ssmtp            \
                bash"

RUN apk update                                              && \
    apk upgrade                                             && \
    apk add --no-cache ${BUILD_DEPS}                        && \
    cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone                        && \
    apk del tzdata                                          && \
    rm -rf /var/cache/apk/*
	

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 744 /usr/local/bin/docker-entrypoint.sh

COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY revaliases /etc/ssmtp/revaliases

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
