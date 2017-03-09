#!/bin/bash

REPOS=(
    "bitbucket.attic.pw/scm/smar/cashier-daemon.git"
    "bitbucket.attic.pw/scm/smar/emission-daemon.git"
)

GIT_USER=''
GIT_PASS=''
GIT_BRANCH='release'
BASE_DIR='/vhosts/'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/clear.env .env
}

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

while true
do
    stty_orig=`stty -g` # save original terminal setting.
    stty -echo          # turn-off echoing.
    read -ra key -p "Git password for $GIT_USER: "
    stty $stty_orig     # restore terminal setting.

    if [[ ${key} == '' ]]; then
        echo "Error: git password is empty. Try again."
        continue
    fi

    GIT_PASS=${key}
    break
done

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=${BASE_DIR}${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && makeconfig $dir && make build && cd ..
   else
       git clone -b $GIT_BRANCH "http://$GIT_USER:$GIT_PASS@$i" $dir
       cd $dir && makeconfig $dir && make build && cd ..
   fi
done