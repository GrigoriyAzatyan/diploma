#!/bin/bash

echo GIT_BRANCH: $GIT_BRANCH
export TAG=`echo $GIT_BRANCH | grep -Eo 'v[0-9\.]+'`
echo TAG: $TAG
docker build -t gregory78/static-page:$TAG .
cat /jenkins/docker.pwd | docker login --username gregory78 --password-stdin
docker push gregory78/static-page:$TAG
yes | docker image prune
cat ./static-page-kube/static-page.tpl | envsubst > ./static-page-kube/static-page.yaml
kubectl apply -f ./static-page-kube/static-page.yaml
