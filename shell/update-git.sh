#!/bin/bash
param=$1
type=$2
if [[ $type == 'cms' ]];then
REMOTE_IP="xapp20-057"
SERVER_BIN_ROOT=/home/www/release/cms-bin
ssh ${REMOTE_NAME}@${REMOTE_IP} "sh ${SERVER_BIN_ROOT}/update-cms.sh $param"
else
REMOTE_NAME="evans"
REMOTE_IP="xapp20-061"
#REMOTE_IP="app20-008"
SERVER_BIN_ROOT=/home/www/bin/user-site
if [[ $type == "jockjs" ]];then
#ssh ${REMOTE_NAME}@${REMOTE_IP} "sh ${SERVER_BIN_ROOT}/update_jockjs.sh $1"
ssh 10.249.6.26 "sh ${SERVER_BIN_ROOT}/update_jockjs.sh $1"
#add by coldramy
#ssh xapp20-061 "sh ${SERVER_BIN_ROOT}/update_jockjs.sh $1"
else
#ssh ${REMOTE_NAME}@${REMOTE_IP} "sh ${SERVER_BIN_ROOT}/update_pages.sh $1"
ssh 10.249.6.26 "sh ${SERVER_BIN_ROOT}/update_pages.sh $1"
#ssh xapp20-061 "sh ${SERVER_BIN_ROOT}/update_pages.sh $1"
fi
fi
