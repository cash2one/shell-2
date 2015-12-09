#!/bin/bash --login
appType=$1

release_dir=/data1/release/site/v2/pages/
if [ ! -d ${release_dir} ]; then
    mkdir -p ${release_dir}
#    chown evans:www-data -R /data1/release/
fi
#~ 要跟common中的RELEASE_ROOT_TEMP 一致
machine_tag=${HOSTNAME}
rsync --delete-after -avzP -e ssh evans@app10-089:/home/evans/release/pages/${appType}/ ${release_dir} --exclude=.git
