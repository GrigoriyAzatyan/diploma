#!/bin/bash

echo GIT_BRANCH: $GIT_BRANCH
TAG=${GIT_BRANCH:10}
echo TAG: $TAG
docker build -t gregory78/static-page:$TAG .
cat /jenkins/docker.pwd | docker login --username gregory78 --password-stdin
docker push gregory78/static-page:$TAG
yes | docker image prune
