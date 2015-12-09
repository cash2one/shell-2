#!/bin/bash

if [ -z $1 ]; then
    echo "Please input {RELEASE_VERSION (YYYY_MM_patch)}.";
    exit 0;
fi

. common-new.sh

#~ 指定上线的app 以逗号分割
if [ -z $2 ]; then
    releaseAppList=${SITES_EXT} #!TODO一起切换
else
    param=$2
    releaseAppList=${param//,/ }
fi

for app in $releaseAppList
do
    cd $ANSIBLE_PATH
    ansible $app -i hosts  -m shell -a 'bash '${SERVER_BIN_ROOT}'/release-version-ga.sh '$1' '$app' '$3''
    echo '-----------------------------------------------------------------'
    echo 'clear opcache'
    ansible $app -i hosts  -m shell -a 'curl -s 127.0.0.1:1700/opcache_restart'
done
