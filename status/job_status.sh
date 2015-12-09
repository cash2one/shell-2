#!/bin/bash
before_time=`date -d '-5 minutes' '+%s'`
before_time=$before_time"000"
result=`curl -XGET 'http://10.10.9.72:9200/_all/_search?pretty' -d '
{
  "query": {
    "bool": {
    "must": [
    {
    "range": {
    "drone-log.time": {
    "from": "'${before_time}'"
    }
    }
    }
    ,
    {
    "wildcard": {
    "drone-log.content": "exit"
    }
    }
    ],
      "must_not": [],
      "should": []
    }
  },
  "size": 200,
  "sort": {"drone-log.time": { "order": "desc" }}
}'`
#echo "$result"
echo "$result"|grep 'with'|awk -F '"jobId":"' '{print $2}'|awk -F '","append"' '{print $1}'|sort|uniq -c |sort -rn
