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
          "query": "NOT http_x_forworded_for:10.10.* AND NOT  http_x_forworded_for:114.80.230.*  AND NOT  http_x_forworded_for:211.151.3.6 AND NOT  http_x_forworded_for:61.144.221.177  AND NOT url_path_reg:\"/captcha-verify/\" AND NOT xff:123.125.71.* AND NOT xff:220.181.108.*  AND NOT xff:106.38.241.*  AND NOT xff:182.118.26.*  AND NOT xff: 123.126.113.* AND NOT xff:61.135.189.*  AND NOT xff:207.46.13.*  AND NOT xff:61.135.249.* AND NOT xff:66.249.79.* AND NOT xff:66.249.67.* AND NOT xff:157.55.39.*",
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
        "field": "xff.raw",
        "size": 10,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}'`
echo `date`
echo "$result"
num=`echo "$result"|grep '"doc_count" : ' |awk '{print $3}'|tac`
for n in $num
do
    if [[ $n -gt 6000 ]];then
    #ip=`echo "$result"|grep "$n" -E1|grep 'key'|awk -F '"key" : "' '{print $2}'|awk -F '",' '{print $1}'|grep '.'`
    ip=`echo "$result"|grep "$n" -E1|grep 'key'|awk -F '"key" : "' '{print $2}'|awk -F '",' '{print $1}'|grep '.'`
    if [[ $ip =~ "," ]];then
        ip=`echo $ip|awk -F ', ' '{print $NF}'`
    fi
    echo $ip
    echo $ip >> /data1/logs/monitor_log/ipduan$time
    curl "http://app10-137.i.ajkdns.com:1700/addBlack?ip=${ip}"
    fi
done


#          "query": "NOT url_path_reg.raw:\"/\" AND NOT http_x_forworded_for:10.10.* AND NOT  http_x_forworded_for:114.80.230.* AND NOT  http_x_forworded_for:211.151.3.6 AND NOT  http_x_forworded_for:61.144.221.177 AND NOT  http_x_forworded_for:119.254.70.5 AND NOT url_path_reg:\"/captcha-verify/\" AND NOT http_user_agent: bingbot AND NOT http_user_agent: Baiduspider AND NOT http_user_agent: Googlebot AND NOT http_user_agent: Sogou",
