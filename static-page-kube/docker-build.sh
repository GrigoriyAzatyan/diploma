#!/bin/bash

echo GIT_BRANCH: $GIT_BRANCH
export TAG=${GIT_BRANCH:10}
echo TAG: $TAG
docker build -t gregory78/static-page:$TAG .
cat /jenkins/docker.pwd | docker login --username gregory78 --password-stdin
docker push gregory78/static-page:$TAG
yes | docker image prune
kubectl apply -f ./static-page-kube/static-page.yaml
