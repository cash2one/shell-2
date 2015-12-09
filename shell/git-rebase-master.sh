#!/bin/bash 

. common-new.sh

#~ 别名
#DEV_ALIAS='branch'

# on server deploy
if [ -f cv-rebase.lock ];then
    echo "now is rebase ,Please wait a moment! "
    exit
else
    touch ${BIN_ROOT}/cv-rebase.lock
fi

branch=$1

if [ ! $1 ];then
    echo "请输入分支"
    exit
fi

if [ ! $2 ];then
    echo "请输入分支类型"
    exit
fi
if [ -z $2 ]; then
    releaseAppList=${SITES_EXT}
else
    param=$2
    releaseAppList=${param//,/ }
fi
for branch_type in $releaseAppList
do
cd $RELEASE_ROOT_GITBAK/$branch_type
    status=`git st | sed -n '/clean/p'`
    if [[ ! $status ]];then
        git rebase --abort
        git rd
    fi  
    rm -fr /home/evans/release/git/$branch_type/.git/rebase-apply
git checkout master
git fetch origin;
git rebase origin/master;
branch_name=${branch}-${branch_type}
git branch -D $branch_name
git fetch ${DEV_ALIAS} $branch_name:$branch_name
git checkout $branch_name
#has_conflict=`git rebase master | sed -n '/conflict/p'`
has_conflict=`git rebase origin/master`
#判断是否有冲突
if [[ ! $? -eq 0 ]];then
    git rebase --abort
    git checkout master
    git branch -D $branch_name
    echo "have conflict ${branch_type}!"
else
    echo "rebase master action success...";
    now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [[ $now_branch  != ${branch_name} ]];then
    echo repo is error!;
    rm ${BIN_ROOT}/cv-rebase.lock
    exit
    fi
    git push ${DEV_ALIAS} $branch_name 
    git checkout master
    git branch -D $branch_name
fi
done
rm ${BIN_ROOT}/cv-rebase.lock
echo `date` $branch_name $branch_type >>/home/evans/release-bin/releaselog/rebase.log
