#!/bin/bash
. /home/www/publish-shell/es_config.sh

time_local=`date -d ' -1 minutes' +"%d/%b/%Y:%H:%M"`
result=`curl -XGET 'http://'$ES_IP':9200/'$ES_INDEX'/_search?pretty' -d '{
  "size": 0,
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "status:[500 TO 504] AND time_local:\"'$time_local'\"",
          "analyze_wildcard": true
        }
      }
    }
  },
  "aggs": {}
}'`
count=`echo $result|awk -F ', "max_s' '{print $1}'|awk -F 'total" : ' '{print $3}'`
echo $count
#echo "$result"

last_min_knowing=`date -d "-1 minute" "+%Y-%m-%d %H:%M" `
curl -s -d "tid=13922&dt=$last_min_knowing&data=$count" http://10.10.3.43:9075/api/add-data
