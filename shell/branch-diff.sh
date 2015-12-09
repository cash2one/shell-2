#!/bin/bash 
. common-new.sh
RELEASE_ROOT_GITBAK="/home/evans/release/git_bak"

if [ -f cv-rebase.lock ];then
    echo "other branch now use this fuction,please wait a moment!"
    exit
else
    touch ${BIN_ROOT}/cv-rebase.lock
fi
branch=$1
param=$2
appList=${param//,/ }

for app in $appList
do
    curr_dir=$RELEASE_ROOT_GITBAK/$app
    cd $curr_dir
    branch_name=$branch-$app
    git fetch origin
    `git br -D $branch_name`
    sha1=`git log origin/master -n1|grep commit |awk '{print $2}'`
    branch_exist=`git log origin/${branch_name} -n1`
    if [[ $branch_exist == "" ]];then
        echo "${branch_name} not exist" 
    else
        git fetch origin ${branch_name}:${branch_name}
        git co ${branch_name}
        has_conflict=`git rebase origin/master`
        if [[ ! $? -eq 0 ]];then
        git rebase --abort 
        git checkout master
        git branch -D $branch_name
        echo "have conflict ${app}!"
        rm ${BIN_ROOT}/cv-rebase.lock
        exit
        else
        now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [[ $now_branch  != ${branch_name} ]];then
        echo repo is error!;
        rm ${BIN_ROOT}/cv-rebase.lock
        exit
        fi
        result=`bash /home/evans/release-bin/check-syntax.sh ${curr_dir} ${branch_name}`
        if [[ $result =~ "Errors parsing" ]];then
            echo ${app}' Syntax Error';
            rm ${BIN_ROOT}/cv-rebase.lock
            `git co master`
            exit
        fi  
        git co ${branch_name}
        r=`arc diff origin/master --preview`
        uri=`echo "$r"|grep -P '/\d+/'`
        url=`echo $uri|awk -F 'URI: ' '{print$2}'`
        echo ${url} 
        echo $url >> /home/evans/release-bin/branch-diff.log
        if [[ ${url} == '' ]];then
            echo 'nochange'
        fi
#        git push ${DEV_ALIAS} $branch_name  -f  
        `git checkout master`
        `git branch -D $branch_name`
    fi
fi
done
rm ${BIN_ROOT}/cv-rebase.lock
