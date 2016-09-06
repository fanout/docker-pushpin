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

ENV PUSHPIN_VERSION 1.12.0-1~xenial1
ENV target app:8080

# Install Pushpin
RUN \
  apt-get update && \
  apt-get install -y pushpin=$PUSHPIN_VERSION

# Configure Pushpin
RUN \
  sed -i \
    -e 's/zurl_out_specs=.*/zurl_out_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-in/' \
    -e 's/zurl_out_stream_specs=.*/zurl_out_stream_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-in-stream/' \
    -e 's/zurl_in_specs=.*/zurl_in_specs=ipc:\/\/\{rundir\}\/pushpin-zurl-out/' \
    /usr/lib/pushpin/internal.conf && \
  sed -i \
    -e 's/services=.*/services=mongrel2,m2adapter,zurl,pushpin-proxy,pushpin-handler/' \
    -e 's/push_in_spec=.*/push_in_spec=tcp:\/\/\*:5560/' \
    -e 's/push_in_http_addr=.*/push_in_http_addr=0.0.0.0/' \
    -e 's/push_in_sub_spec=.*/push_in_sub_spec=tcp:\/\/\*:5562/' \
    -e 's/command_spec=.*/command_spec=tcp:\/\/\*:5563/' \
    /etc/pushpin/pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* && \
  rm -fr /tmp/*

# Define default command
CMD ["sh", "-c", "/usr/bin/pushpin --merge-output --port=7999 --route=\"* ${target},over_http\""]

# Expose ports.
# - 7999: HTTP port to forward on to the app
# - 5560: ZMQ PULL for receiving messages
# - 5561: HTTP port for receiving messages and commands
# - 5562: ZMQ SUB for receiving messages
# - 5563: ZMQ REP for receiving commands
EXPOSE 7999
EXPOSE 5560
EXPOSE 5561
EXPOSE 5562
EXPOSE 5563
