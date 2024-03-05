FROM alpine

MAINTAINER "wanjie <webmaster@wanjie.info>"

RUN apk --no-cache add curl openssh-client sshpass less git && \
    rm /var/cache/apk/*

VOLUME /git
WORKDIR /git

ENTRYPOINT ["git"]
CMD ["--help"]	
