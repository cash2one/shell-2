#!/bin/bash
#set -x
#exec 1> /tmp/create_version.txt
. common-new.sh
#~ 判断是否有人在上线
if [ -f cv-$4.lock ];then
    echo "Version is releasing,Please wait a moment! "
    exit
else
    touch ${BIN_ROOT}/cv-$4.lock
    touch ${BIN_ROOT}/cv-$4_merge.lock
fi
if [ -z $1 ]; then
    echo "Please input {RELEASE_VERSION (YYYY_MM [patch])}.";
    exit 0;
fi

if [ -z $2 ]; then
    echo "Please input RELEASE_VERSION order number.";
    exit 0;
else
    #当$5不为空，也就是为cookie的时候，$1的值为周，不包含年
    version=$1_$2
fi
if [ -z $3 ]; then
    releaseAppList=${SITES_EXT}
else
    param=$3
    releaseAppList=${param//,/ }
fi
type=$4
if1="1"
idate=`date +"%F %H:%M:%S"`
echo "git update to newest start"


#~ 指定从master或者branch拉
#!这个功能目前应该比指定app更常用，建议参数放在前面
if [[ ! -z $5 ]]; then
    branch=$5
fi
if [ ! -d ${LOG_ROOT}/${version} ]; then
    mkdir -p ${LOG_ROOT}/${version}
fi
for app in $releaseAppList
do
    app_now=$app
    echo "Creating ${app} version:${version}."
    [[ "${app_now/$type/}" != "$app_now" ]] && app=$type || app="1"
    [[ "${app_now/$if1/}" != "$app_now" ]] && app1="1" || app1=$type
    cd $RELEASE_ROOT_GIT/$app
    if [[ $? -ne 0 ]];then
        echo '路径不存在'；
        rm ${BIN_ROOT}/cv-$4.lock
        rm ${BIN_ROOT}/cv-$4_merge.lock
        exit
    fi
        status=`git st | sed -n '/clean/p'`
    if [[ ! $status ]];then
        git rebase --abort
        git rd
    fi 
    rm -fr /home/evans/release/git/$app/.git/rebase-apply
    if [[ $5 == "" ]]; then
    if [[ $app1 != "1" ]];then
        git checkout master
        git fetch origin
        git rebase origin/master
        now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [[ $now_branch  != 'master' ]];then
            echo repo is error!;
            rm ${BIN_ROOT}/cv-$4.lock
            rm ${BIN_ROOT}/cv-$4_merge.lock 
            exit
        fi
        if [ ! $? -eq 0 ];then
            echo "${app} Rebase master error, exit!"
            exit
        fi
        git tag -f -a $version$app origin/master -m "create tag $version $idate" 
        git push origin --tags
        git tag -d $version$app
    echo 'origin tags'
    else
    echo 'next'
    fi 
    else
        branch_name=${branch}
    if [[ $app1 != "1" ]];then
        git br -D ${branch_name}
        git fetch ${DEV_ALIAS} ${branch_name}:${branch_name}
        git checkout ${branch_name};
        now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [[ $now_branch  != ${branch_name} ]];then
            echo repo is error!;
            rm ${BIN_ROOT}/cv-$4.lock
            rm ${BIN_ROOT}/cv-$4_merge.lock 
            exit
        fi  
#        git tag -f -a $version$app -m "create tag $version $idate" 
#        git push branch --tags
#        git tag -d $version$app
        echo 'branch tags'
    fi 
    fi
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
    #如果$5传过来了值，那么说明是cookie版，删除该branch
    if [[ $5 != "" ]]; then

    [[ "${param/1/}" != "$param" ]] && app2="2" || app2="1"
    if [[ $app2 == "2" ]];then
    if [[ $app1 == "1" ]];then
    cd $RELEASE_ROOT_GIT/$app
    if [[ $? -ne 0 ]];then
        echo '路径不存在'；
        rm ${BIN_ROOT}/cv-$4.lock
        rm ${BIN_ROOT}/cv-$4_merge.lock
        exit
    fi
    branch_name=${branch}
    git co master;
    git branch -D ${branch_name};
    fi  
    else
    git co master
    git branch -D ${branch_name};
    fi  
    fi  
    if [[ $app_now == "member7" ]];then
    cd /home/www/userops/daily_ops_tool/
    ansible member-pg -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/MEMBER_RELEASE_VERSION'
    fi
    if [[ $app_now == "member_usersite7" ]];then
    cd /home/www/userops/daily_ops_tool/
    ansible member-pg -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/Member_usersite_RELEASE_VERSION'
    ansible cookie -i hosts  -m shell -a ' echo '${version}' > /home/www/conf/member_usersite_RELEASE_VERSION'
    fi
done

#~ 移除锁文件
rm ${BIN_ROOT}/cv-$4.lock
rm ${BIN_ROOT}/cv-$4_merge.lock
