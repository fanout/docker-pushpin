#
# Pushpin Dockerfile
#
# https://github.com/fanout/docker-pushpin
#

# Pull the base image
FROM ubuntu:16.04
MAINTAINER Justin Karneges <justin@fanout.io>

# Add private APT repository
RUN \
  apt-get update && \
  apt-get install -y apt-transport-https software-properties-common && \
  echo deb https://dl.bintray.com/fanout/debian fanout-xenial main \
    | tee /etc/apt/sources.list.d/fanout.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
    379CE192D401AB61

ENV PUSHPIN_VERSION 1.10.1-1~xenial1

# Install Pushpin
RUN \
  apt-get update && \
  apt-get install -y pushpin=$PUSHPIN_VERSION

ARG target=app:8080

# Configure Pushpin
RUN \
  echo "* ${target},over_http" > /etc/pushpin/routes && \
  sed -i \
    -e 's/zurl_out_specs=.*/zurl_out_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-in/' \
    -e 's/zurl_out_stream_specs=.*/zurl_out_stream_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-in-stream/' \
    -e 's/zurl_in_specs=.*/zurl_in_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-out/' \
    /usr/lib/pushpin/internal.conf && \
  sed -i \
    -e 's/services=.*/services=mongrel2,m2adapter,zurl,pushpin-proxy,pushpin-handler/' \
    -e 's/push_in_http_addr=127.0.0.1/push_in_http_addr=0.0.0.0/' \
    /etc/pushpin/pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* && \
  rm -fr /tmp/*

# Define default command
CMD ["/usr/bin/pushpin"]

# Expose ports.
# - 7999: HTTP port to forward on to the app
# - 5561: HTTP port to receive real-time messages to update in the app
EXPOSE 7999
EXPOSE 5561
