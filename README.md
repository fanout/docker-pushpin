## Pushpin Dockerfile


This repository contains **Dockerfile** of [Pushpin](http://www.pushpin.org/) for [Docker](https://www.docker.com/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Pushpin Version: 1.6.0

### Base Docker Image

* [ubuntu:15.10](https://hub.docker.com/_/ubuntu/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/johnjelinek/pushpin/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull johnjelinek/pushpin`

   (alternatively, you can build an image from Dockerfile: `docker build -t="johnjelinek/pushpin" github.com/johnjelinek/pushpin-docker`)


### Usage

    docker run -dt -p 7999:7999 --name pushpin johnjelinek/pushpin

#### Attach app to accept traffic

  1. Start an acceptor container that exposes on port 8080.

  2. Start a pushpin container by linking to the acceptor container:

    ```sh
    docker run -dt -p 7999:7999 --link acceptor:app johnjelinek/pushpin
    ```

Open `http://<host>:7999` to see the result.

#### Attach app to respond to traffic

  1. Start a responder container by linking to the pushpin container:

    ```sh
    docker run -d --link pushpin:pushpin ubuntu bash -c "apt-get update; apt-get install -y curl; while true; do curl -s -d '{ \"items\": [ { \"channel\": \"test\", \"http-stream\": { \"content\": \"hello there\n\" } } ] }' http://pushpin:5561/publish ; sleep 1; done"
    ```
