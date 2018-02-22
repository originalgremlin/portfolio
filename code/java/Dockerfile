FROM alpine:3.7

ENV VERSION=${VERSION:-8.151.12-r0} \
    JAVA_HOME=/usr/lib/jvm/default-jvm/ \
    PATH=${PATH}:/usr/lib/jvm/default-jvm/bin
WORKDIR /usr/local/src

COPY root /

RUN set -x \
    && apk add --no-cache openjdk8=${VERSION}
#    && javac /usr/local/src

ENTRYPOINT [ "/bin/sh" ]
