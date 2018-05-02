FROM alpine:3.7

ARG packer_version
ARG terraform_version

ENV PACKER_VERSION="${packer_version:-1.1.3}" \
    TERRAFORM_VERSION="${terraform_version:-0.11.3}"

# set up
WORKDIR /tmp
RUN set -x \
    && apk add --no-cache bash coreutils curl docker docker-bash-completion git gnupg go groff htop jq less libc-dev make man man-pages mysql-client openssh openssl python3 redis zip \
    && pip3 install -U pip \
    && pip3 install -U aws-shell boto3 docker-compose \
    && curl -fSLO "https://keybase.io/hashicorp/key.asc" \
    && gpg --import key.asc

# packer
RUN set -x \
    && curl -fSLO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS.sig" \
    && curl -fSLO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS" \
    && curl -fSLO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
    && gpg --verify "packer_${PACKER_VERSION}_SHA256SUMS.sig" "packer_${PACKER_VERSION}_SHA256SUMS" \
    && grep " packer_${PACKER_VERSION}_linux_amd64.zip\$" "packer_${PACKER_VERSION}_SHA256SUMS" | sha256sum -c - \
    && unzip "packer_${PACKER_VERSION}_linux_amd64.zip" -d /usr/bin/

# terraform
RUN set -x \
    && curl -fSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig" \
    && curl -fSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
    && curl -fSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && gpg --verify "terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
    && grep " terraform_${TERRAFORM_VERSION}_linux_amd64.zip\$" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum -c - \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/bin/

# clean up
RUN set -x \
    && rm -rf /tmp/*
COPY root /
WORKDIR /usr/local/data

ENTRYPOINT [ "/bin/bash" ]
CMD [ "-l" ]
