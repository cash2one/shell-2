#!/bin/bash 

. common-new.sh
echo $1,$2,$3,$4 >>/tmp/aaa
new_branch=$1
#git 取代码

if [ ! $new_branch ];then
    echo "请输入分支"
    exit
fi

param=$2
remoteList=${param//,/ }
for app in $remoteList
do
    curr_dir=$RELEASE_ROOT_GITBAK/${app}
    cd $curr_dir
    status=`git st | sed -n '/clean/p'`
    if [[ ! $status ]];then
        git rebase --abort
        git rd
    fi
    rm -fr /home/evans/release/git/$app/.git/rebase-apply
    git branch -D $new_branch-$app
    git fetch origin master:$new_branch-$app
    git push branch $new_branch-$app  
#    git push ub $new_branch-$app  
    echo $new_branch-$app" creating success. deleting local branch..."
    git branch -D $new_branch-$app
done



