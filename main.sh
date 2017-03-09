#!/bin/bash

REPOS=(
    "bitbucket.attic.pw/scm/smar/abs.git"
    "bitbucket.attic.pw/scm/smar/api.git"
    "bitbucket.attic.pw/scm/smar/cards-bot.git"
    "bitbucket.attic.pw/scm/smar/merchant-bot.git"
    "bitbucket.attic.pw/scm/smar/exchange.git"
    "bitbucket.attic.pw/scm/smar/frontend.git"
)

GIT_USER=''
GIT_PASS=''
GIT_BRANCH='release'
BASE_DIR='/vhosts/'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/default.env .env
}

#clear old default config file
rm -rf ./default.env

cp -f ./clear.env default.env

echo "" >> ./default.env
read -p "Enter SMTP host:" smtp_host; echo "SMTP_HOST=$smtp_host" >> ./default.env;
read -p "Enter SMTP port:" smtp_port; echo "SMTP_PORT=$smtp_port" >> ./default.env;
read -p "Enter SMTP security:" smtp_security; echo "SMTP_SECURITY=$smtp_security" >> ./default.env;
read -p "Enter SMTP username:" smtp_user; echo "SMTP_USER=$smtp_user" >> ./default.env;
read -p "Enter SMTP password:" smtp_pass; echo "SMTP_PASS=$smtp_pass" >> ./default.env;

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

echo "make indexes on api..."
cd ${BASE_DIR}api && sleep 1 && make indexes
echo "Complete"