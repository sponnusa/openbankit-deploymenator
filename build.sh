#!/bin/bash

REPOS=(
    "bitbucket.attic.pw/scm/smar/agent.git"
    "bitbucket.attic.pw/scm/smar/cards-bot.git"
    "bitbucket.attic.pw/scm/smar/backoffice.git"
    "bitbucket.attic.pw/scm/smar/info.git"
    "bitbucket.attic.pw/scm/smar/keyserver.git"
    "bitbucket.attic.pw/scm/smar/merchant.git"
    "bitbucket.attic.pw/scm/smar/merchant-bot.git"
    "bitbucket.attic.pw/scm/smar/nginx-proxy.git"
    "bitbucket.attic.pw/scm/smar/offline.git"
    "bitbucket.attic.pw/scm/smar/web-wallet.git"
    "bitbucket.attic.pw/scm/smar/welcome.git"
    "bitbucket.attic.pw/scm/cryp/api.git"
)

TYPE_NONE=0
TYPE_ENV=1
TYPE_JS=2

ENV_TYPES=(
    ${TYPE_JS}      #agent
    ${TYPE_ENV}     #cards-bot
    ${TYPE_JS}      #backoffice
    ${TYPE_JS}      #info
    ${TYPE_ENV}     #keyserver
    ${TYPE_JS}      #merchant
    ${TYPE_ENV}     #merchant-bot
    ${TYPE_NONE}    #nginx-proxy
    ${TYPE_JS}      #offline
    ${TYPE_JS}      #web-wallet
    ${TYPE_JS}      #welcome
    ${TYPE_ENV}     #api
)

GIT_USER=''
GIT_PASS=''
GIT_BRANCH='nbu0.1'
BASE_DIR='/vhosts/'

function makeconfig {
    if [[ ${ENV_TYPES[${COUNTER}]} == ${TYPE_JS} ]]; then
        cd $1 && cp -f ../deploymenator/default.env.js env.js
    fi

    if [[ ${ENV_TYPES[${COUNTER}]} == ${TYPE_ENV} ]]; then
        cd $1 && cp -f ../deploymenator/default.env .env
    fi
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

COUNTER=0
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

    ((COUNTER++))
done
