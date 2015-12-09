#!/bin/bash --login

#set -x
#exec 1> /tmp/release-ga.txt
version=$1
appType=$2
type=$3
[[ "${appType/$type/}" != "$appType" ]] && app=$type || app="1"
if [[ $app == 'hzapi' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='RELEASE_VERSION_HaozuAPI'
    dir_ext='haozu-mobile-api/'
elif [[ $app == 'ajkapi' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='RELEASE_VERSION_AnjukeAPI'
    dir_ext='anjuke-mobile-api/app-api/'
elif [[ $app == 'hzold' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='RELEASE_VERSION_HaozuAPI_V3.0'
    dir_ext='haozu-mobile-api-v3.0/'
elif [[ $app == 'jpapi' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='RELEASE_VERSION_JinpuAPI'
    dir_ext='jinpu-mobile-api/'
elif [[ $app == 'haozu' ]];then
    release_version_file_dir='/home/www/config/machine/'
    file_name='ZU_RELEASE_VERSION'
    dir_ext='anjuke-zu/'
elif [[ $app == 'jinpu' ]];then
    release_version_file_dir='/home/www/config/machine/'
    file_name='JP_RELEASE_VERSION'
    dir_ext='anjuke-jp/'
elif [[ $app == 'wechat' ]];then
    release_version_file_dir='/home/www/config/machine/'
    file_name='API_RELEASE_VERSION'
    dir_ext='wechat/'
elif [[ $app == 'anjuke' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='RELEASE_VERSION'
    dir_ext=''
elif [[ $app == 'cms_user' ]];then
    release_version_file_dir='/home/www/conf/'
    file_name='CMS_USER_RELEASE_VERSION'
    dir_ext='cms-user/'
else
    release_version_file_dir='/home/www/conf/'
    file_name=$app'_RELEASE_VERSION'
    dir_ext=$app/
fi

machine_tag=`cat /home/www/conf/MACHINE_NAME`
if [[ $app == "anjuke" ]];then
    if [ -d "/home/www/release/v2/${dir_ext}${version}" ]; then
        if_ok=`du -sh /home/www/release/v2/${dir_ext}${version}|awk '{print $1}'`
        if [[ $if_ok == "4.0K" ]]; then
            echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
            exit;
        fi
    else
        echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
    fi
elif [[ "$app" =~ "ajkapi" ]] || [[ "$app" =~ "hzapi" ]] || [[ "$app" =~ "jpapi" ]] || [[ "$app" =~ "hzold" ]]; then
    if [ -d "/home/www/release/${dir_ext}${version}" ]; then
        if_ok=`du -sh /home/www/release/${dir_ext}${version}|awk '{print $1}'`
        if [[ $if_ok == "4.0K" ]]; then
            echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
            exit;
        fi
     else
        echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
     fi
else
    if [ -d "/data1/release/site/v2/${dir_ext}${version}" ]; then
        if_ok=`du -sh /data1/release/site/v2/${dir_ext}${version}|awk '{print $1}'`
        if [[ $if_ok == "4.0K" ]]; then
            echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
            exit;
        fi
    else
        echo "${machine_tag} ${app} ${version} not exists; switch ga version fail !"
        exit;
    fi
fi

if [ ! -d ${release_version_file_dir} ];then
    mkdir -p $release_version_file_dir
fi
version_file=${release_version_file_dir}${file_name}
echo $1 > ${version_file}
log_path="/home/evans/release-bin/releaselog/${version}"
ssh app10-089 "mkdir -p ${log_path}"
#~ 记录日志
if [ $? -eq 0 ]; then
    ssh app10-089 "echo "${machine_tag}:`date`:${appType} ga success" >> ${log_path}/release-ga.log"
else
    ssh app10-089 "echo "${machine_tag}:`date`:${appType} ga failure" >> ${log_path}/release-ga.log"
fi

