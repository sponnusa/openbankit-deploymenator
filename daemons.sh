#!/bin/bash

REPOS=(
    "gitlab.com/openbankit/cashier-daemon.git"
    "gitlab.com/openbankit/emission-daemon.git"
)

GIT_USER='openbankit.guest'
GIT_PASS='OB1guest'
GIT_BRANCH='mirror'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/clear.env .env
}

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=${CUR_DIR}/../${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && makeconfig $dir && make build && cd ..
   else
       git clone -b $GIT_BRANCH "http://$GIT_USER:$GIT_PASS@$i" $dir
       cd $dir && makeconfig $dir && make build && cd ..
   fi
done
