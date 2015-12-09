#!/bin/bash

writeLog(){
    Week=`date +%Y%W`
    Today=`date +%Y-%m-%d`
    Time=`date +%T`
    if [ ! -d ${LOG_ROOT} ]; then
        mkdir -p ${LOG_ROOT}
    fi
    echo "Date:$Today  Week:$Week Time:$Time $1" >> $LOG_ROOT/$Week.txt
}

. server.sh
#~ 测试时使用自己的配置文件
if [ $USER == 'kyou' ]; then
    #!这个依赖好像有点奇怪，是线下的脚本就应该直接定义线下的common，线上的用线上的common，可能他们还有一个公共的common
    . common-dev.sh
    return;
fi

ANSIBLE_PATH=/home/www/userops/daily_ops_tool
#~ 别名
DEV_ALIAS='branch'
#~ 
SITES_EXT='anjuke haozu jinpu wechat ajkapi hzapi jpapi hzold'
#SITES_EXT='anjuke'
#~ 从git中checkout的项目文件
RELEASE_ROOT_TEMP='/home/evans/release/temp'

PG_PATH='/home/www/release/repo/pg'
#~ git仓库
SITE_ANJUKE_GIT="git@git.corp.anjuke.com:anjuke/v2-site"
#SITE_ANJUKE_GIT="git@git.corp.anjuke.com:anjuke/v2-feature"
SITE_HAOZU_GIT="git@git.corp.anjuke.com:site/haozu-user"
SITE_JINPU_GIT="git@git.corp.anjuke.com:site/jinpu-user"
BRANCH_GIT="git@git.corp.anjuke.com:site/user-branch"

#~ 脚本目录
BIN_ROOT='/home/evans/release-bin'
LOG_ROOT=$BIN_ROOT'/releaselog'
#~ copy到各个服务器的脚本
SERVER_SHELLS=$BIN_ROOT'/servers'
RELEASE_ROOT_GIT='/home/evans/release/git'
RELEASE_ROOT_GITBAK='/home/evans/release/git_bak'
#~ 服务器上shell脚本目录
SERVER_BIN_ROOT='/home/www/publish-shell'
