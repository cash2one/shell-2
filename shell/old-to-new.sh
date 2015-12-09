#!/bin/bash
#mkdir -p /home/www/move
#cd /home/www/move
#git clone --mirro git@git.corp.anjuke.com:_user_site/anjuke-site anjuke
#git clone --mirro git@git.corp.anjuke.com:_user_site/haozu-site haozu
#git clone --mirro git@git.corp.anjuke.com:_user_site/jinpu-site jinpu
#git clone --mirro git@git.corp.anjuke.com:site/user-site user-site
#git clone --mirro git@git.corp.anjuke.com:aifang/touchWeb java
#git clone --mirro git@git.corp.anjuke.com:site/pages pages
#allFolder="anjuke haozu jinpu java user-site pages"
#for folder in $allFolder
#do
#cd ${folder}
#pwd
#git push --mirro git@gitlab.corp.anjuke.com:_site/${folder}.git
#cd ../ 
#done
#cd /home/evans/release/git_bak
# git clone git@git.corp.anjuke.com:_chat/anjuke-chat anjuke_chat
#  git clone http://gitlab.corp.anjuke.com/_mobile-api/chat-cms.git cms 
# git clone git@gitlab.corp.anjuke.com:_mobile-api/haozu3.git hzold
#  git clone git@git.corp.anjuke.com:_mobileAPI/anjuke-mobile-api ajkapi
# git clone git@gitlab.corp.anjuke.com:_mobile-api/haozu.git hzapi
#  git clone git@gitlab.corp.anjuke.com:_mobile-api/jinpu.git jpapi
#  git clone git@gitlab.corp.anjuke.com:_mobile-api/new-api.git api_usersite
#   git clone git@git.corp.anjuke.com:site/cms-chat cms_chat
#git clone git@gitlab.corp.anjuke.com:_site/anjuke.git member
#   cd ajkapi/
#   git remote add branch git@git.corp.anjuke.com:_mobileApiDev/mobileApiDev
#   cd ../anjuke_chat/
#   git remote add branch git@git.corp.anjuke.com:_mobileApiDev/mobileApiDev
#   cd ../cms
#   git remote add branch git@git.corp.anjuke.com:_mobileApiDev/mobileApiDev
#   cd ../cms_chat/
#   git remote add branch git@git.corp.anjuke.com:_mobileApiDev/mobileApiDev
#   cd ../hzold/
#   git remote add branch git@gitlab.corp.anjuke.com:_mobile-api/haozu3.git
#   cd ../hzapi/
#   git remote add branch git@gitlab.corp.anjuke.com:_mobile-api/haozu.git
#   cd ../api_usersite/
#   git remote add branch git@gitlab.corp.anjuke.com:_mobile-api/new-api.git 
#  cd ../jpapi/
#   git remote add branch git@gitlab.corp.anjuke.com:_mobile-api/jinpu.git
#cd ../member/
#    git remote add branch git@gitlab.corp.anjuke.com:_site/anjuke.git
#
#exit
#


#修改remote
#cd /home/evans/release/pages
#rm -rf pages
#git clone git@gitlab.corp.anjuke.com:_site/pages.git pages
allPath="/home/evans/release/git /home/evans/release/git_bak"
allFolder="anjuke haozu jinpu java anjuke_usersite zufang_usersite shangpu_usersite member_usersite pad_usersite touch_usersite member_usersite"
for path in $allPath
do
    cd ${path}
    for folder in $allFolder
    do
#        if [ -d "${path}/${folder}" ];then
            if  [[ ${folder} =~ "usersite" ]];then
                f=user-site
            else
                f=${folder}
            fi
#            rm -rf ${path}/${folder}
            git clone git@gitlab.corp.anjuke.com:_site/${f}.git ${folder}
            cd $folder
            git remote add branch git@gitlab.corp.anjuke.com:_site/${f}.git 
#            now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
#            if [[ $now_branch  != "master" ]];then
#                echo ${path}/${folder}repo is error!;
#                exit
#            fi 
#            old_sha1=`git log origin/master -n1|grep commit |awk '{print $2}'` 
#            git remote set-url origin git@gitlab.corp.anjuke.com:_site/${f}.git 
#            git remote set-url branch git@gitlab.corp.anjuke.com:_site/${f}.git 
#            new_sha1=`git log origin/master -n1|grep commit |awk '{print $2}'` 
#            if [[ $old_sha1 != $new_sha1 ]];then
#                echo master code is error!
#                exit
#            fi
            cd ../
#        fi
    done
done
mv hp haozu
mv jp jinpu

#touchWeb remote
cd /home/www/java-deploy/releases/repo/
rm -rf 3_touchweb
git clone git@gitlab.corp.anjuke.com:_site/java.git 3_touchweb
#PG remote
cd /home/www/userops/daily_ops_tool
/usr/local/bin/ansible pg -i hosts -m shell -a "/home/www/bin/user-site/update-remote.sh" 
