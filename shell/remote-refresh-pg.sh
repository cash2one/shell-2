#!/bin/bash
. common-new.sh
if [ -z $1 ]; then
    echo "Please input {pmt name])}.";
    exit 0;
fi

if [ -z $2 ]; then
    releaseAppList=${SITES_EXT}
else
    param=$2
    releaseAppList=${param//,/ }
fi
idate=`date +"%F %H:%M:%S"`
branch=$1
fpxx=$3
#~ 指定从master或者branch拉
#!这个功能目前应该比指定app更常用，建议参数放在前面
for app in $releaseAppList
do
if [[ $app =~ "usersite" ]] && [[ $if_rsync == "no" ]];then
    for server in $PG
    do
        ssh evans@$server "sh /home/www/bin/user-site/rsync.sh ${path} /data1/release/site/v2/$app/"
    done
else
    cd $PG_PATH/$app
    status=`git st | sed -n '/clean/p'`
    if [[ ! $status ]];then
        git rebase --abort
        git rd
    fi 
    rm -fr /home/evans/release/pg/$app/.git/rebase-apply
    git checkout master
    now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
#    if [[ $now_branch  != 'master' ]];then
#        echo repo is error!;
#        exit
#    fi
    if [[ $app =~ "usersite" ]];then
        branch_name=${branch}-anjuke_usersite
    else
        branch_name=${branch}-${app}
    fi
    git br -D ${branch_name}
    git fetch origin
    git fetch ${DEV_ALIAS} ${branch_name}:${branch_name}
    git checkout ${branch_name}
    curr_dir=${PG_PATH}/${app}
#    result=`bash /home/evans/release-bin/check-syntax.sh ${curr_dir} ${branch_name}`
#    if [[ $result =~ "Errors parsing" ]];then
#        echo ${app}' Syntax Error';
#        `git co master`
#        exit
#    fi
    now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
#    if [[ $now_branch  != ${branch_name} ]];then
#        echo repo is error!;
#        exit
#    fi  
    #!建议上线代码都取出以后，再一起去同步
    string_machines=''
    appServer= 
    #~  首字母大写
    servers=$PG
    #~ 拼接服务器字符串
    for machine in ${servers}
    do
        string_machines="${string_machines} -m ${machine} "
    done
    dsh -r ssh -c ${string_machines} "/bin/bash -l /home/www/bin/user-site/new-rsync-from-deploy.sh" ${branch} $app $fpxx
    if [ $app == 'java' ];then
        if [[ $fpxx == "" ]];then
           fpxx="fp30"
        fi
        begin=`awk 'BEGIN{ print index("'${branch_name}'","-") }'`
        echo $branch_name|cut -c$((begin+1))-$((begin+5)) >/home/evans/release-bin/id
        branch_id=`cat /home/evans/release-bin/id`
        ssh 10.249.6.28 "sh /home/www/bin/user-site/restart.sh ${branch} ${branch_id} ${fpxx}"
    fi
    git co master 
    git br -D ${branch_name}
fi
if [[ $app =~ "usersite" && if_rsync != "no" ]];then
    if_rsync="no"
    path=/data1/release/site/v2/$app/$branch
fi
done
