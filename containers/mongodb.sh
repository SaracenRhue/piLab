#!/bin/bash

sudo docker run -d \
    --name=mongo \
    -p 27017:27017 \
    -v /DATA/AppData/mongo:/data/db \
    --restart unless-stopped \
    mongo:bionic