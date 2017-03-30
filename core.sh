#!/bin/bash

REPO="bitbucket.org/atticlab/docker-node.git"

GIT_USER=''
GIT_BRANCH='0.1.2'
BASE_DIR='/vhosts/'
CUR_DIR=${PWD}

dir=$(basename "$REPO" ".git")
dir=${BASE_DIR}${dir}

if [[ -d "$dir" ]]; then
   echo "Already cloned..."
else

   while true
   do
       read -ra key -p "Git login: "
       if [[ $key == '' ]]; then
           echo "Error: git login is empty. Try again."
           continue
       fi

       GIT_USER=$key
       break
   done

   git clone -b $GIT_BRANCH "https://$GIT_USER@$REPO" $dir
fi