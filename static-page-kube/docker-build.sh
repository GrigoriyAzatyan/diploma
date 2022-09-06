#!/bin/bash

echo GIT_BRANCH: $GIT_BRANCH
export TAG=${GIT_BRANCH:10}
echo TAG: $TAG
ls -l .
cat ./static-page.yaml
