#!/bin/bash
get_info(){
time_local=`date -d ' -1 minutes' +"%d/%b/%Y:%H:%M"`
info=`get_count $ip ${regex[$i]}`
count=`echo $info|awk -F ', "max_s' '{print $1}'|awk -F 'total" : ' '{print $3}'`
last_min_knowing=`date -d "-1 minute" "+%Y-%m-%d %H:%M" `
curl -s -d "tid=13964&dt=$last_min_knowing&data=$count" http://10.10.3.43:9075/api/add-data
}






get_count(){
server_addr=$1
request=$2
. /home/www/publish-shell/es_config.sh

result=`curl -XGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
"query": {
"bool": {
"must": [
{"prefix": {"logs.time_local.raw": "'$time_local'"}}
],
"must_not": [ ],
"should": [ ]
}
},
"from": 0,
"size": 0,
"sort": [ ],
"facets": { }
}'`
echo `date`
echo $result
}



get_info
