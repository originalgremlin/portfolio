FROM alpine:3.7

ENV VERSION=${VERSION:-8.9.3-r1}

COPY root /
WORKDIR /usr/local/src

RUN set -x \
    && apk add --no-cache nodejs=${VERSION} yarn \
    && yarn install

ENTRYPOINT [ "/bin/sh" ]
