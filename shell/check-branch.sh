#!/bin/bash  --login
if [ -z $1 ]; then
    echo "Please input Your Branch Name.";
    return;
fi

#. common-new.sh
RELEASE_ROOT_GIT='/home/evans/release/git_bak'
DEV_ALIAS='branch'
branch_name=$1
app=$2
curr_dir=$RELEASE_ROOT_GIT/$app
cd $curr_dir;
git fetch origin
git fetch branch 
branch_exist=`git log branch/${branch_name} -n1`
if [[ $branch_exist == "" ]];then
    echo "no this branch"
    else
    echo "ok"
fi
