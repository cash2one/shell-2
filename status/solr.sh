#!/bin/bash
from_name="solr_status"
from="jianqiangni@anjuke.com"
to="dl-tech-siteweb@anjuke.com leqinzhou@anjuke.com"
#to="leqinzhou@anjuke.com"
email_title=""
email_subject="solr状态异常"
file='/data1/logs/monitor_log/404.log'
`curl -s -o /data1/logs/monitor_log/solr_url "http://search.corp.anjuke.com/service.php"`
`cat /data1/logs/monitor_log/solr_url|grep 'd_running' -E4|grep "service_detail.php"|awk -F '">' '{print $2}'|awk -F '<' '{print $1}'|sort >/data1/logs/monitor_log/solr_config`
all=`cat /data1/logs/monitor_log/solr_config`
echo ''> ${file}
for a in $all
do
    url="http://10.10.6.51:8983/"$a"/select/?q=*:*"
    http_code=`curl -I -m 10 -o /dev/null/ -s -w %{http_code} $url`
    sleep 1
    if [ $http_code != "200" ];then
        echo "$url" >> ${file}
    fi
done

#第一次非200的 确认第二次
has_con=`cat ${file}`
echo ''> ${file}
for url in $has_con
do
    http_code=`curl -I -m 10 -o /dev/null/ -s -w %{http_code} $url`
    sleep 1
    if [ $http_code != "200" ];then
        echo "$url" >> ${file}
    fi
done

#经过2次确认还是异常的，发邮件通知
has_con=`cat ${file}`
if [[ ! -z $has_con ]];then
#    info=`cat ${file}`
    for t in $to
    do
        echo -e "To: \"${email_title}\" <${t}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${file}`" | /usr/sbin/sendmail -t
  #      url='http://ajksms.a.ajkdns.com/index.php?biz_id=2010&num='$t'&content='$info''
   #     url='http://ajksms.a.ajkdns.com/index.php?biz_id=2010&num='$t'&content=222222222'
   #     curl -I $url
    done
fi
