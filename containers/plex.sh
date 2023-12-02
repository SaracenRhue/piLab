#!/bin/bash

sudo docker run -d \
  --name=plex \
  --net=bridge \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e PLEX_CLAIM= `#optional` \
  -p 32400:32400 \
  -v /DATA/AppData/plex:/config \
  -v /DATA/Media/tv:/tv \
  -v /DATA/Media/movies:/movies \
  --restart unless-stopped \
  lscr.io/linuxserver/plex:latest