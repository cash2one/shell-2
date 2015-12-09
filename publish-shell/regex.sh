#!/bin/bash
server=`hostname`
second=`date "+%S"`
#echo $second
#server_regex=`curl -s http://10.10.3.190/server_info/get_regex.php?server=$server`
result=`curl -s http://10.10.3.190/server_info/get_regex.php?server=$server`
regex=`echo $result|awk -F ';' '{print $1}'`
regex=($regex)
knowing=`echo $result|awk -F ';' '{print $2}'`
knowing=($knowing)
lenth=${#regex[*]}
for ((i = 0; i< $lenth; i++ ))
do
if [[ $((10#$second)) -lt 03 ]];then
    last_min=`date -d "-1 minute" "+%Y:%H:%M" `
    last_min_knowing=`date -d "-1 minute" "+%Y-%m-%d %H:%M" `
    count=`tail -50000 /data1/logs/nginx/access.log |grep "$last_min"|awk '{print $10}'|grep -Poc "${regex[$i]}"`
    curl -d "tid=${knowing[$i]}&dt=$last_min_knowing&data=$count" http://10.10.3.43:9075/api/add-data
fi
