#!/bin/bash

sudo docker run -d \
  --name=firefox \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Vienna \
  -p 4200:3000 \
  -v /DATA/AppData/firefox:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest