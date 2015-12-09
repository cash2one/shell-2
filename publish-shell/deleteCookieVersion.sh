#!/bin/bash
allFloder="/home/www/release/v2/,/data1/release/site/v2/anjuke-jp/,/data1/release/site/v2/anjuke-zu/,/data1/release/site/v2/member_usersite/,/data1/release/site/v2/pad_usersite/,/data1/release/site/v2/system/,/data1/release/site/v2/systemext/,/data1/release/site/v2/touch_usersite/,/data1/release/site/v2/api_usersite/,
/home/www/release/v2/,/home/www/release/haozu-mobile-api/,/home/www/release/anjuke-mobile-api/app-api/,/home/www/release/haozu-mobile-api-v3.0/,/home/www/release/jinpu-mobile-api/"
floderList=${allFloder//,/ }
for floder in $floderList
do
if [ -d ${floder} ];then
    echo 'floder exist'
    rm -rf ${floder}9*
else
    echo ${floder}' not exist'
fi
done
