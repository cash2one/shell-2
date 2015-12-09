#!/bin/bash

. common-new.sh
version=$1
if [ -z $1 ]; then
    echo "Please input {RELEASE_VERSION (YYYY_MM [patch])}.";
    exit 0;
fi

if [ -z $2 ]; then
    releaseAppList=${SITES_EXT}
else
    param=$2
    releaseAppList=${param//,/ }
fi
type=$3
idate=`date +"%F %H:%M:%S"`

for app in $releaseAppList
do
    app_now=$app
    [[ "${app_now/$type/}" != "$app_now" ]] && app=$type || app="1"
    #!建议上线代码都取出以后，再一起去同步
    string_machines=''
    appServer= 
    #~  首字母大写
    [[ "${app_now/$type/}" != "$app_now" ]] && app=$type || app="1"
    upper_app=`echo $app_now|sed "s/\b[a-z]/\U&/g"`
    servers='arr'$upper_app'AppServer[@]'
    #~ 拼接服务器字符串
    for machine in ${!servers}
    do
        string_machines="${string_machines} -m ${machine} "
    done
    dsh -r ssh -c ${string_machines} "${SERVER_BIN_ROOT}/delete-version.sh" ${version} $app
    echo 
done
