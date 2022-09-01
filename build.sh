#!/bin/bash

TAG=${GIT_BRANCH:13}
docker build -t gregory78/static-page:$TAG .
cat /jenkins/docker.pwd | docker login --username gregory78 --password-stdin
docker push gregory78/static-page:$TAG
yes | docker image prune
