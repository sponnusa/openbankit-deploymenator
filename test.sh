#!/bin/bash

REPO="gitlab.com/openbankit/test.git"

GIT_USER='openbankit.guest'
GIT_PASS='OB1guest'
GIT_BRANCH='mirror'

dir=$(basename "$REPO" ".git")
dir=${PWD}/../${dir}

if [[ -d "$dir" ]]; then
   echo "Folder $dir already exists"
else
   git clone -b $GIT_BRANCH "https://$GIT_USER:$GIT_PASS@$REPO" $dir
fi
