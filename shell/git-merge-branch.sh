#!/bin/bash  --login
#set -x
#exec 1> /tmp/merge.txt

if [ -z $1 ]; then
    echo "Please input Your Branch Name.";
    return;
fi
. common-new.sh

if [ -f cv-$3_merge.lock ];then
    echo "branch is merging,Please wait a moment! "
    exit
else
    touch ${BIN_ROOT}/cv-$3_merge.lock
    touch ${BIN_ROOT}/cv-$3.lock
fi

branchName=$1

#~ 指定合并的app 以逗号分割 ,默认为 anjuke haozu jinpu
param=$2
type=$3
releaseAppList=${param//,/ }
branch_desc=$4
branch_desc1=$5
branch_desc2=$6
for app in $releaseAppList
do
    branch_name=${branchName}
    curr_dir=$RELEASE_ROOT_GIT/$app
    cd $curr_dir;
    status=`git st | sed -n '/clean/p'`
    if [[ ! $status ]];then
        git rebase --abort
        git rd
    fi  
    rm -fr /home/evans/release/git/$app/.git/rebase-apply
    git checkout master;
    git fetch origin;
    git rebase origin/master;
    git branch -D $branch_name;
    git fetch $DEV_ALIAS $branch_name:$branch_name;
    git checkout $branch_name;
    now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [[ $now_branch  != $branch_name ]];then
    echo "no this branch"
    echo `date` $branch_name >> /home/evans/release-bin/log/no_branch.log
    exit
    else rebase_conflict=`git rebase master`
        if [[ ! $? -eq 0 ]];then
            git rebase --abort
            git checkout master
            git branch -D $branch_name
            echo "have conflict ${app}!"
        else
            echo "rebase master success...";
            now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
            if [[ $now_branch  != ${branch_name} ]];then
            echo repo is error!;
            rm ${BIN_ROOT}/cv-$3.lock
            rm ${BIN_ROOT}/cv-$3_merge.lock
            exit
            fi             
#            git push branch $branch_name -f
            git checkout master;
            git merge $branch_name --no-ff
            if_merge=`git log -n1|grep ${branch_name}`
            if [[ ! $if_merge ]];then
                echo FAIL
                rm ${BIN_ROOT}/cv-$3_merge.lock
                rm ${BIN_ROOT}/cv-$3.lock
                exit
            fi
            git push origin master:master;
			mkdir -p /home/evans/release-bin/if_push_ok/$type
			if [[ $type == "anjuke" ]];then
			url=_site/anjuke/commits/master
			elif [[ $type == "haozu" ]];then
			url=_site/haozu/commits/master
			elif [[ $type == "jinpu" ]];then
			url=_site/jinpu/commits/master
			elif [[ $type == "wechat" ]];then
			url=_site/wechat/commits/master
            elif [[ $type == "java" ]];then
			url=_site/tw_java/commits/master
            elif [[ $type == "yezhu" ]];then
			url=_site/sublessor/commits/master
            elif [[ $type == "ajkapi" ]];then
			url=_mobile-api/anjuke-mobile-api/commits/master
            elif [[ $type == "api_usersite" ]];then
			url=_mobile-api/new-api/commits/master
            elif [[ $type == "hzapi" ]];then
			url=_mobile-api/haozu/commits/master
            elif [[ $type == "jpapi" ]];then
			url=_mobile-api/jinpu/commits/master
            elif [[ $type == "hzold" ]];then
			url=_mobile-api/haozu3/commits/master
            elif [[ $type == "anjuke_chat" ]];then
			url=_mobile-api/anjuke-chat/commits/master
            elif [[ $type == "cms" ]];then
			url=_mobile-api/chat-cms/commits/master
            elif [[ $type == "cms_user" ]];then
			url=_site/cms-user/commits/master
			elif [[ $type == "anlife" ]];then
			url=_site/anlife/commits/master
			elif [[ $type == "member" ]];then
			url=_site/anjuke/commits/master
			elif [[ $type == "search_php_sdk" ]];then
			url=_uesearch/search-php-sdk/commits/master
            else
            url=_site/user-site/commits/master
            fi
		    curl "http://gitlab.corp.anjuke.com/$url" >/home/evans/release-bin/if_push_ok/$type/httpResult 
			c=`cat /home/evans/release-bin/if_push_ok/$type/httpResult`
            result=`cat /home/evans/release-bin/if_push_ok/$type/httpResult |grep "Merge branch '${branch_name}'"`
			if [[ $result != "" ]];then
			echo PASS
            echo ${branch_name}  ${branch_desc} ${branch_desc1} ${branch_desc2}>> /home/evans/release-bin/log/merger_$type.txt
			else
			echo FAIL
			fi
        fi
    fi
            git branch -D $branch_name
done
rm ${BIN_ROOT}/cv-$3_merge.lock
rm ${BIN_ROOT}/cv-$3.lock
