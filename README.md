# docker-pushpin

**This repository is archived.** The Pushpin Docker image is now built and maintained in the main Pushpin repo:

https://github.com/fastly/pushpin/tree/main/docker

## What this means for you

If you just pull the image, nothing changes. It's still published to Docker Hub as [`fanout/pushpin`](https://hub.docker.com/r/fanout/pushpin), for both `linux/amd64` and `linux/arm64`:

```sh
docker pull fanout/pushpin
```

If you build the image yourself, use the `Dockerfile` and `compose.yaml` in the [`docker/`](https://github.com/fastly/pushpin/tree/main/docker) directory of fastly/pushpin. The README there covers building and running it.

## Issues and pull requests

Please open issues and pull requests on [fastly/pushpin](https://github.com/fastly/pushpin) instead of here. Keeping the Docker files next to the Pushpin source means the image is built and tested alongside each Pushpin release, so they don't drift apart.
