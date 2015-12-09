#!/bin/bash
. /home/www/publish-shell/es_config.sh

ip=`ifconfig |grep 'inet addr:'|awk -F ':' '{print $2}'|awk -F ' ' '{print $1}'|grep '10.10'`
time_local=`date -d ' -1 minutes' +"%d/%b/%Y:%H:%M"`
echo $time_local
#time_local="27/Nov/2015:15:16"
result=`curl -sXGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
"query": {
"bool": {
"must": [
{"prefix": {"logs.time_local.raw": "'$time_local'"}},
{"prefix": {"logs.server_addr.raw": "'$ip'"}}],
"must_not": [ ],
"should": [ ]
}
},
"from": 0,
"size": 0,
"sort": [ ],
"facets": { }
}'`
#echo `date`
#echo $result
logstash_count=`echo $result|awk -F ', "max_s' '{print $1}'|awk -F 'total" : ' '{print $3}'`
server_count=`tail -100000 /data1/logs/nginx/access.log|grep ''$time_local''|wc -l`
echo $logstash_count 
echo $server_count
logstash_count=`expr $logstash_count + 2`
echo $logstash_count
if [[ ! $logstash_count -ge $server_count ]];then
    ssh $MAIL_SERVER -oStrictHostKeyChecking=no "echo "$time_local:`hostname`数据不一致 es:$logstash_count access $server_count" >> /tmp/logstash"
fi
