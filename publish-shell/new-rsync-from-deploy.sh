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
elif [[ $appType == "cms_user" ]];then
    dir_ext='cms-user/'
    temp_ext='TEMP_cms_user'    
    temp_dir=/home/www/release/${temp_ext}/
    release_dir=/home/www/release/${dir_ext}$1/
else
    dir_ext=$appType/
    temp_ext=TEMP_$appType
    temp_dir=/data1/release/site/v2/${temp_ext}/
    release_dir=/data1/release/site/v2/${dir_ext}$1/
fi

if [ ! -d ${temp_dir} ]; then
    mkdir -p ${temp_dir}
fi
if [ ! -d ${release_dir} ]; then
    mkdir -p ${release_dir}
fi
#~ 要跟common中的RELEASE_ROOT_TEMP 一致
machine_tag=`cat /home/www/conf/MACHINE_NAME`
rsync --delete-after -az -e ssh evans@app10-089:/home/evans/release/git/${appType}/ ${temp_dir} --exclude=.git
rsync -a  ${temp_dir} ${release_dir} 

log_path="/home/evans/release-bin/releaselog/${version}"
#~ 记录日志
if [ $? -eq 0 ]; then
    ssh app10-089 "mkdir -p ${log_path};echo "${machine_tag}:`date`:${appType} rsync success" >> ${log_path}/rsync.log"
else
    ssh app10-089 "mkdir -p ${log_path};echo "${machine_tag}:`date`:${appType} rsync failure ! !" >> ${log_path}/rsync.log"
fi
