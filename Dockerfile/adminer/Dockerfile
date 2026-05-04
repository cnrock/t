FROM --platform=$TARGETPLATFORM  adminer:standalone
USER root
RUN apk update && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*
USER adminer
CMD    [ "php", "-S", "0.0.0.0:8080", "-t", "/var/www/html" ]
