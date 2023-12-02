#!/bin/bash

sudo docker run -d \
  --name=resilio-sync \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Vienna \
  -p 8888:8888 \
  -p 55555:55555 \
  -v /DATA/AppData/resilio/config:/config \
  -v /DATA/AppData/resilio/downloads:/downloads \
  -v /DATA/AppData/resilio/sync:/sync \
  --restart unless-stopped \
  lscr.io/linuxserver/resilio-sync:latest