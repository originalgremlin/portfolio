FROM alpine:3.7

ENV VERSION=${VERSION:-1.9.4-r0}

COPY root /
WORKDIR /usr/local/src

RUN set -x \
    && apk add --no-cache go=${VERSION} \
    && go build /usr/local/src

ENTRYPOINT [ "/bin/sh" ]
