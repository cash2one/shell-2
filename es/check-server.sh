#!/bin/bash
. /home/www/publish-shell/es_config.sh

time=`date -d today +"%Y-%m-%d-%H"`
last_time=`date -d '-5 minutes' '+%s'`
last_time=$last_time"000"
echo  $last_time
result=`curl -XGET 'http://'$ES_IP':9200/logstash-user-accesslog/_search?pretty' -d '{
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "*",
          "analyze_wildcard": true
        }
      },
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
  "size": 0,
  "aggs": {
    "2": {
      "terms": {
        "field": "sent_http_ajk.raw",
        "size": 30,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}'`
#echo `date`
#echo "$result"


#server=`echo "$result"|grep 'app' |awk '{print $3}'`
all_server=`echo "$result"|grep 'app' |grep -v '_'|awk -F 'app' '{print $2}'|awk -F '"' '{print $1}'|sort`
rm /data1/logs/heimingdan/access_host
for server in $all_server
do
echo app$server
    echo app$server >> /data1/logs/heimingdan/access_host
done
wc -l /data1/logs/heimingdan/access_host


#          "query": "NOT url_path_reg.raw:\"/\" AND NOT http_x_forworded_for:10.10.* AND NOT  http_x_forworded_for:114.80.230.* AND NOT  http_x_forworded_for:211.151.3.6 AND NOT  http_x_forworded_for:61.144.221.177 AND NOT  http_x_forworded_for:119.254.70.5 AND NOT url_path_reg:\"/captcha-verify/\" AND NOT http_user_agent: bingbot AND NOT http_user_agent: Baiduspider AND NOT http_user_agent: Googlebot AND NOT http_user_agent: Sogou",
