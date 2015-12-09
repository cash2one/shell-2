#!/bin/bash
get_info(){
time_local=`date -d ' -1 minutes' +"%d/%b/%Y:%H:%M"`
all_ip=`mysql -h10.249.7.17 -uaifang -p123456 -A server_info -e "select ip from server_info where knowing_id !=''"`
for ip in $all_ip
do
    if [[ $ip =~ "." ]];then
        result=`curl -s http://10.10.3.190/server_info/get_knowing.php?ip=$ip`
        knowing=$result
        info=`get_count $ip`
        count=`echo $info|awk -F ', "max_s' '{print $1}'|awk -F 'total" : ' '{print $3}'`
echo $ip
echo $knowing
echo $count
echo '-----------'
        last_min_knowing=`date -d "-1 minute" "+%Y-%m-%d %H:%M" `
        curl -s -d "tid=${knowing[$i]}&dt=$last_min_knowing&data=$count" http://10.10.3.43:9075/api/add-data
    fi
done
}






get_count(){
server_addr=$1
. /home/www/publish-shell/es_config.sh

result=`curl -XGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
"query": {
"bool": {
"must": [
{"prefix": {"logs.time_local.raw": "'$time_local'"}},
{"prefix": {"logs.server_addr.raw": "'$server_addr'"}}
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
