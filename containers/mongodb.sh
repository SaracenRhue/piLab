#!/bin/bash

sudo docker run -d -p 27017:27017 -v /DATA/AppData/mongo:/data/db --name mongo mongo:bionic