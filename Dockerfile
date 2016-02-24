#
# Pushpin Dockerfile
#
# https://github.com/fanout/docker-pushpin
#

# Pull the base image
FROM ubuntu:15.10
MAINTAINER John Jelinek IV <john@johnjelinek.com>

ENV PUSHPIN_VERSION 1.6.0
ENV ZURL_VERSION 1.4.10

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y pkg-config libqt4-dev libqca2-dev \
  libqca2-plugin-ossl libqjson-dev libzmq3-dev python-zmq \
  python-setproctitle python-jinja2 python-tnetstring \
  python-sortedcontainers mongrel2-core git libcurl4-gnutls-dev

# Build Zurl
RUN \
  git clone git://github.com/fanout/zurl.git /zurl && \
  cd /zurl && \
  git checkout tags/v"$ZURL_VERSION" && \
  git submodule init && git submodule update && \
  ./configure && \
  make && \
  make install

# Build Pushpin
RUN \
  git clone git://github.com/fanout/pushpin.git /pushpin && \
  cd /pushpin && \
  git checkout tags/v"$PUSHPIN_VERSION" && \
  git submodule init && git submodule update && \
  make

# Configure Pushpin
RUN \
  cd /pushpin && \
  cp examples/config/* . && \
  sed -i -e 's/localhost:80/app:8080/' routes && \
  sed -i -e 's/push_in_http_addr=127.0.0.1/push_in_http_addr=0.0.0.0/' pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* && \
  rm -fr /tmp/*

# Define working directory
WORKDIR /pushpin

# Define default command
CMD ["/pushpin/pushpin"]

# Expose ports.
# - 7999: HTTP port to forward on to the app
# - 5561: HTTP port to receive real-time messages to update in the app
EXPOSE 7999
EXPOSE 5561
