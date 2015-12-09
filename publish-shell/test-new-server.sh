#!/bin/bash
#测试新搭建的服务器是否可正常运行
server=$1
num=$2
if [[ -z $num ]];then
    num=10;
fi
all_url=`tail -$num /data1/logs/nginx/access.log|awk '{print $8$10}'`
for url in $all_url
do
{
    echo $url
    curl -s -I -o /dev/null "$url" -x ''$server':1700'
}&
done
