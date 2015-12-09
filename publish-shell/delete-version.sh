#!/bin/bash --login
#set -x

version=$1
appType=$2

if [ -z $1 ]; then
    echo "Please input {VERSION (YYYY_MM_patch)}.";
    exit;
fi

#exec 1> /tmp/rsync.log.$version.$appType
#exec 2>&1
if [[ $appType == 'hzapi' ]];then
    dir_ext='haozu-mobile-api/'
    temp_ext='TEMP_HZAPI'
    temp_dir=/home/www/release/${temp_ext}/
    release_dir=/home/www/release/${dir_ext}$1/
elif [[ $appType == 'ajkapi' ]];then
    dir_ext='anjuke-mobile-api/app-api/'
    temp_ext='TEMP_ajkAPI'
    temp_dir=/home/www/release/${temp_ext}/
    release_dir=/home/www/release/${dir_ext}$1/
elif [[ $appType == 'hzold' ]];then
    dir_ext='haozu-mobile-api-v3.0/'
    temp_ext='TEMP_hz3.0API'
    temp_dir=/home/www/release/${temp_ext}/
    release_dir=/home/www/release/${dir_ext}$1/
elif [[ $appType == 'jpapi' ]];then
    dir_ext='jinpu-mobile-api/'
    temp_ext='TEMP_JPAPI'
    temp_dir=/home/www/release/${temp_ext}/
    release_dir=/home/www/release/${dir_ext}$1/
elif [[ $appType == 'anjuke' ]];then
    dir_ext=''
    temp_ext='TEMP_AJK'
    temp_dir=/home/www/release/v2/${temp_ext}/
    release_dir=/home/www/release/v2/${dir_ext}$1/
elif [[ $appType == 'haozu' ]];then
    dir_ext='anjuke-zu/'
    temp_ext='TEMP_HZ'
    temp_dir=/data1/release/site/v2/${temp_ext}/
    release_dir=/data1/release/site/v2/${dir_ext}$1/
elif [[ $appType == "jinpu" ]];then
    dir_ext='anjuke-jp/'
    temp_ext='TEMP_JP'
    temp_dir=/data1/release/site/v2/${temp_ext}/
    release_dir=/data1/release/site/v2/${dir_ext}$1/
elif [[ $appType == "wechat" ]];then
    dir_ext='wechat/'
    temp_ext='TEMP_wechat'    
    temp_dir=/data1/release/site/v2/${temp_ext}/
    release_dir=/data1/release/site/v2/${dir_ext}$1/
else
    dir_ext=$appType/
    temp_ext=TEMP_$appType
    temp_dir=/data1/release/site/v2/${temp_ext}/
    release_dir=/data1/release/site/v2/${dir_ext}$1/
fi

#~ 要跟common中的RELEASE_ROOT_TEMP 一致
machine_tag=${HOSTNAME}
rm -rf $release_dir
echo ${HOSTNAME} $1 版本号已删除！
