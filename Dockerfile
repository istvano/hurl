FROM debian:bullseye-slim
ARG HURL_VERSION=1.6.1
ENV HURL_VERSION=${HURL_VERSION}
RUN apt-get update -y
RUN set -ex; \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        curl wget bash make \
        unzip \
        coreutils \
        ssh-client apt-transport-https openssh-client \
        gnupg \
		nano vim tmux \
		net-tools dnsutils \
		jq 
WORKDIR /tmp
# install hurl
RUN curl -LO https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl_${HURL_VERSION}_amd64.deb && \
    apt install -y ./hurl_${HURL_VERSION}_amd64.deb && \
    rm ./hurl_${HURL_VERSION}_amd64.deb

# Create non-root user for hurl
RUN groupadd -r hurl && useradd --no-log-init -r -g hurl hurl && mkdir /home/hurl && chown hurl:hurl /home/hurl
WORKDIR /home/hurl
USER hurl
RUN echo "alias tmux='tmux -u'" >> ~/.bashrc && \
echo "alias hi='echo hello'" >> ~/.bashrc && \
echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
echo "alias l.='ls -d .* --color=auto'" >> ~/.bashrc && \
echo "alias grep='grep --color=auto'" >> ~/.bashrc && \
echo "alias fgrep='fgrep --color=auto'" >> ~/.bashrc && \
echo "alias egrep='egrep --color=auto'" >> ~/.bashrc && \
echo "alias l='ls -CF --color=auto'" >> ~/.bashrc && \
echo "alias la='ls -A --color=auto'" >> ~/.bashrc && \
echo "alias ll='ls -alF --color=auto'" >> ~/.bashrc \
echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf

ENV TERM=xterm-256color
ENV BASH_ENV "/home/hurl/.bashrc"

CMD ["bash", "-l"]