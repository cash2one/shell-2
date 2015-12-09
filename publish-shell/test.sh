#!/bin/bash
get_info(){
time_local=`date -d ' -1 minutes' +"%d/%b/%Y:%H:%M"`
        result=`curl -s http://10.10.3.190/server_info/b.php`
        host=`echo $result|awk -F ';' '{print $1}'`
        host=($host)
        regex=`echo $result|awk -F ';' '{print $2}'`
        regex=($regex)
        knowing=`echo $result|awk -F ';' '{print $3}'`
        knowing=($knowing)
        lenth=${#regex[*]}
        for ((i = 0; i< $lenth; i++ ))
        do
            echo '----------------------------start-------------------------'
            echo ${host[$i]}
            echo ${regex[$i]}
            echo ${knowing[$i]}
            info=`get_count ${host[$i]} ${regex[$i]}`
            count=`echo $info|awk -F ', "max_s' '{print $1}'|awk -F 'total" : ' '{print $3}'`
            echo $count
            last_min_knowing=`date -d "-1 minute" "+%Y-%m-%d %H:%M" `
            curl -s -d "tid=${knowing[$i]}&dt=$last_min_knowing&data=$count" http://10.10.3.43:9075/api/add-data
        done
}






get_count(){
host=$1
request=$2
. /home/www/publish-shell/es_config.sh
result=`curl -sXGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
"query": {
"bool": {
"must": [
{"prefix": {"logs.time_local.raw": "'$time_local'"}},
{"regexp": {"logs.host.raw": "'$host'"}},
{"regexp": {"logs.request.raw": "GET '$request'"}}
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


