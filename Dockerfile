FROM debian:bullseye-slim
ARG HURL_VERSION=1.6.1
ENV HURL_VERSION=${HURL_VERSION}
RUN apt-get update -y
RUN set -ex; \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        curl wget bash \
        unzip \
        coreutils \
        ssh-client apt-transport-https openssh-client \
        gnupg \
		nano vim \
		net-tools dnsutils \
		jq 
WORKDIR /tmp
# install hurl
RUN curl -LO https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl_${HURL_VERSION}_amd64.deb
RUN apt install -y ./hurl_${HURL_VERSION}_amd64.deb

# Create non-root user for hurl
RUN groupadd -r hurl && useradd --no-log-init -r -g hurl hurl
USER hurl