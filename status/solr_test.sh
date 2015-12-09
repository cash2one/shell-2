#!/bin/bash
from_name="solr_status"
from="jianqiangni@anjuke.com"
to="dl-tech-siteweb@anjuke.com"
email_title=""
email_subject="solr状态异常"
file='/data1/logs/status/404.log'
all='ershoufang-01 ershoufang-02 ershoufang-03 ershoufang-04 ershoufang-05 ershoufang-06 ershoufang-07 ershoufang-08 ershoufang-09 ershoufang-10 ershoufang-11 ershoufang-12 ershoufang-13 ershoufang-14 ershoufang-15 ershoufang-16 ajk-saleauction zufang-01 zufang-02 zufang-03 zufang-04 zufang-05 zufang-06 zufang-07 zufang-08 zufang-09 zufang-10 zufang-11'
echo '' > ${file}
for a in $all
do
    url="http://10.10.6.51:8983/"$a"/select/?q=*:*"
    http_code=`curl -I -m 10 -o /dev/null/ -s -w %{http_code} $url`
    if [ $http_code != "200" ];then
        echo "$url" >> ${file}
    fi
done
has_con=`cat ${file}`
echo "$has_con"
