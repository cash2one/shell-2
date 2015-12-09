#!/bin/bash
get_info(){
    file="/home/www/publish-shell/list"
    while read line
    do
        line=($line)
        lenth=${#line[*]}
        info=`get_count ${line[0]} ${line[1]}`
        echo "$info"
        count=`echo "$info"|awk -F 'value" : ' '{print $2}'`
        count=`echo "scale=1;$count * 1000"|bc`
        count=`echo $count|awk -F '\.' '{print $1}'`
        echo ${line[2]}: ${line[1]} $count"ms"
    done < $file
}

get_count(){
host=$1
request=$2
last_time=`date -d '-60 minutes' '+%s'000`
. /home/www/publish-shell/es_config.sh
result=`curl -sXGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
  "size": 0,
  "query": {
    "filtered": {
      "query": 
        {"regexp": {"logs.host.raw": "'$host'"}},
        {"regexp": {"logs.request.raw": "GET '$request'"}},
      "filter": {
        "bool": {
          "must": [
            {
              "range": {
                "@timestamp": {
                  "gte": "'${last_time}'"
                }
              }
            }
          ],
          "must_not": []
        }
      }
    }
  },
  "aggs": {
    "1": {
      "avg": {
        "field": "request_time"
      }
    }
  }
}'`
echo `date`
echo "$result"
}



get_info


