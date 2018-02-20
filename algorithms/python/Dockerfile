FROM alpine:3.7

ENV VERSION=${VERSION:-3.6.3-r9} \
    PYTHONPATH=${PYTHONPATH}:/usr/local/src

RUN set -x \
    && apk add --no-cache --virtual .build-deps g++ musl-dev \
    && apk add --no-cache python3-dev=${VERSION} \
    && pip3 install --upgrade pip \
    && pip3 install jupyter \
    && apk del --purge .build-deps

COPY root /
WORKDIR /usr/local/src

ENTRYPOINT [ "/bin/sh" ]
