# Google Cloud Directory Sync in Docker image

[![Build Status](https://img.shields.io/docker/build/brainbeanapps/gcds.svg)](https://hub.docker.com/r/brainbeanapps/gcds)
[![Docker Pulls](https://img.shields.io/docker/pulls/brainbeanapps/gcds.svg)](https://hub.docker.com/r/brainbeanapps/gcds)
[![Docker Stars](https://img.shields.io/docker/stars/brainbeanapps/gcds.svg)](https://hub.docker.com/r/brainbeanapps/gcds)
[![Docker Layers](https://images.microbadger.com/badges/image/brainbeanapps/gcds.svg)](https://microbadger.com/images/brainbeanapps/gcds)

Dockerized version of [Google Cloud Directory Sync](https://tools.google.com/dlpage/dirsync/) by [Brainbean Apps](https://brainbeanapps.com)

## Usage

```bash
docker run \
  --name gcds \
  --net=host \
  -e GCDS_CONFIG="/opt/gcds/data/config.xml" \
  -e GCDS_SYNC_PERIOD="10m" \
  -v /data/gcds:/opt/gcds/data:rw \
  -v /data/gcds/logs:/var/log/gcds/:rw \
  brainbeanapps/gcds:latest
```
