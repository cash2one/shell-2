#!/bin/bash
while true
do
day=`date "+%Y%m%d" `
date=`date -d "-1 second" "+%Y:%H:%M:%S" `
qps=`tail -1300 /data1/logs/nginx/access.log |grep "$date"|wc -l`
old_qps=`cat /tmp/qps`
echo $qps
echo $old_qps
if [[ $qps -gt $old_qps ]];then
    echo $qps > /tmp/qps
    curl  "http://10.10.3.190/server_info/save_qps.php?server=`hostname`&qps=$qps&date=$day"
    echo ok
fi
sleep 1
done
