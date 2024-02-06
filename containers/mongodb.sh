#!/bin/bash

mkdir /appdata/mongo
podman run -d \
    --name=mongo \
    -p 27017:27017 \
    -v /appdata/mongo:/data/db \
    docker.io/mongo:bionic

echo "mongodb running on port 27017"