#!/bin/bash

REPOS=(
    "gitlab.com/openbankit/abs.git"
    "gitlab.com/openbankit/api.git"
    "gitlab.com/openbankit/cards-bot.git"
    "gitlab.com/openbankit/merchant-bot.git"
    "gitlab.com/openbankit/exchange.git"
    "gitlab.com/openbankit/frontend.git"
)

GIT_USER='openbankit.guest'
GIT_PASS='OB1guest'
GIT_BRANCH='mirror'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/default.env .env
}

clear old default config file
rm -rf ./default.env

cp -f ./clear.env default.env

echo "" >> ./default.env
read -p "Enter project name (use for labels):" project_name; echo "PROJECT_NAME=$project_name" >> ./default.env;
read -p "Enter SMTP host:" smtp_host; echo "SMTP_HOST=$smtp_host" >> ./default.env;
read -p "Enter SMTP port:" smtp_port; echo "SMTP_PORT=$smtp_port" >> ./default.env;
read -p "Enter SMTP security:" smtp_security; echo "SMTP_SECURITY=$smtp_security" >> ./default.env;
read -p "Enter SMTP username:" smtp_user; echo "SMTP_USER=$smtp_user" >> ./default.env;
read -p "Enter SMTP password:" smtp_pass; echo "SMTP_PASS=$smtp_pass" >> ./default.env;

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=${CUR_DIR}/../${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && makeconfig $dir && make build && cd ..
   else
       git clone -b $GIT_BRANCH "https://$GIT_USER:$GIT_PASS@$i" $dir
       cd $dir && makeconfig $dir && make build && cd ..
   fi
done

echo "make indexes on api..."
cd ./api && sleep 1 && make indexes
echo "Complete"
