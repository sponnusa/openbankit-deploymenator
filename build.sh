#!/bin/bash

REPOS=(
    "bitbucket.attic.pw/scm/smar/agent.git"
    "bitbucket.attic.pw/scm/smar/backoffice.git"
    "bitbucket.attic.pw/scm/smar/info.git"
    "bitbucket.attic.pw/scm/smar/keyserver.git"
    "bitbucket.attic.pw/scm/smar/merchant.git"
    "bitbucket.attic.pw/scm/smar/merchant-bot.git"
    "bitbucket.attic.pw/scm/smar/cards-bot.git"
    "bitbucket.attic.pw/scm/smar/distribution-daemon.git"
    "bitbucket.attic.pw/scm/smar/nginx-proxy.git"
    "bitbucket.attic.pw/scm/smar/offline.git"
    "bitbucket.attic.pw/scm/smar/web-wallet.git"
    "bitbucket.attic.pw/scm/smar/welcome.git"
    "bitbucket.attic.pw/scm/cryp/api.git"
)

GIT_USER=''
GIT_PASS=''
GIT_BRANCH='nbu'
BASE_DIR='/vhosts/'

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

    if [[ $key == '' ]]; then
        echo "Error: git password is empty. Try again."
        continue
    fi

    GIT_PASS=$key
    break
done

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=$BASE_DIR$dir

    if [[ -d "$dir" ]]; then
        cd $dir && git pull && make build && cd ..
    else
        git clone -b $GIT_BRANCH "http://$GIT_USER:$GIT_PASS@$i" $dir
        cd $dir && make build && cd ..
    fi
done
