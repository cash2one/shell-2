#!/bin/bash
. /home/www/publish-shell/es_config.sh

xff=$1
time=`date -d today +"%Y-%m-%d-%H"`
last_time=`date -d '-5 minutes' '+%s'`
last_time=$last_time"000"
#          "query": "NOT url_path_reg.raw:\"/\" AND NOT http_x_forworded_for:10.10.* AND NOT  http_x_forworded_for:114.80.230.*  AND NOT  http_x_forworded_for:211.151.3.6 AND NOT  http_x_forworded_for:61.144.221.177 AND NOT url_path_reg:\"/captcha-verify/\"",
result=`curl -XGET 'http://'$ES_IP':9200/logstash-user-accesslog/_search?pretty' -d '{
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "NOT url_path_reg.raw:\"/\" AND NOT http_x_forworded_for:10.10.* AND NOT  http_x_forworded_for:114.80.230.*  AND NOT  http_x_forworded_for:211.151.3.6 AND NOT  http_x_forworded_for:61.144.221.177 AND NOT url_path_reg:\"/captcha-verify/\" AND '${xff}'",
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
        "field": "http_x_forworded_for.raw",
        "size": 10,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}'`
#echo "$result"
all_ip=`echo "$result"|grep '"key" : ' |awk '{print $NF}'`
#echo $num
list=${all_ip//,/ }
last=`echo $list|awk '{print $NF}'`
echo "{\"ip\":["
for n in $list
do
    echo $n
    ip=`echo "$n"|grep -Po '[0-9]+.[0-9]+.[0-9]+.[0-9+]+'`
    if [[ $n == $last ]];then
        echo {\"ip\":\"$ip\"}
    else
        echo {\"ip\":\"$ip\"},
    fi
    echo $ip >> /data1/logs/monitor_log/addblack$time
    `curl -s "http://site-api.a.ajkdns.com/tools/ip-shield/?act=addBlack&ip=${ip}"`
   # curl "site-api.a.ajkdns.com/tools/ip-shield/?act=setWhite&ip=${ip}"
done
echo ]}

