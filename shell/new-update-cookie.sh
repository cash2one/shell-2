#!/bin/bash -l
#set -x
#exec 1> /tmp/create_version.txt
. common-new.sh
#~ 判断是否有人在上线
if [ -f cv-$4.lock ];then
    echo "Version is releasing,Please wait a moment! "
    exit
else
    touch ${BIN_ROOT}/cv-$4.lock
fi
version=$1
branch=$2
if [ -z $3 ]; then
    releaseAppList=${SITES_EXT}
else
    param=$3
    releaseAppList=${param//,/ }
fi
type=$4
idate=`date +"%F %H:%M:%S"`
echo "git update to newest start"


#~ 指定从master或者branch拉
#!这个功能目前应该比指定app更常用，建议参数放在前面
if [ ! -d ${LOG_ROOT}/${version} ]; then
    mkdir -p ${LOG_ROOT}/${version}
fi
for app in $releaseAppList
do
    app_now=$app
    echo "Creating ${app} version:${version}."
    [[ "${app_now/$type/}" != "$app_now" ]] && app=$type || app="1"
    cd $RELEASE_ROOT_GIT/$app
    banch_name=${branch}
    git fetch ${DEV_ALIAS} ${banch_name}:${banch_name}
    git checkout ${banch_name};
#        git tag -f -a $version -m "create tag $version $idate" 
#        git push origin --tags
#        git tag -d $version$app
    [[ "${app_now/$type/}" != "$app_now" ]] && app=$type || app="1"
    if [[ $app_now =~ '8' ]];then
        servers='public'
    elif [[ $app_now =~ '9' ]];then
        servers='cookie'
    else
        servers=$app
    fi
    cd /home/www/userops/daily_ops_tool/
    ansible $servers -i hosts -f 20 -m shell -a 'bash '${SERVER_BIN_ROOT}'/new-rsync-from-deploy.sh '${version}' '$app''
    #如果$2传过来了值，那么说明是cookie版，删除该branch
    if [[ $2 != "" ]]; then
    cd $RELEASE_ROOT_GIT/$app
    banch_name=${branch}
    git co master;
    git branch -D ${banch_name};
    fi
    if [[ $upper_app == "Member7" ]];then
    cd /home/www/userops/daily_ops_tool/
    ansible member-pg -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/MEMBER_RELEASE_VERSION'
    fi 
    if [[ $upper_app == "Member_usersite7" ]];then
    cd /home/www/userops/daily_ops_tool/
    ansible member-pg -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/Member_usersite_RELEASE_VERSION'
    ansible cookie -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/member_usersite_RELEASE_VERSION'
    fi
    if [[ $5 == "35" ]];then
    cd /home/www/userops/daily_ops_tool/
    ansible touch-cookie -i hosts -u root -m shell -a ' echo '${version}' > /home/www/conf/touch_usersite_RELEASE_VERSION'
    ansible touch-cookie -i hosts -u root -m shell -a ' echo '${version}' > /home/www/conf/touch_usersite_RELEASE_VERSION_BETA'
    fi

done

#~ 移除锁文件
rm ${BIN_ROOT}/cv-$4.lock



