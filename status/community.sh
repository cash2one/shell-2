#!/bin/bash
from_name="community_status"
from="jianqiangni@anjuke.com"
to="dl-tech-siteweb@anjuke.com"
#to="leqinzhou@anjuke.com"
email_title=""
email_subject="community接口状态异常"
file='/data1/logs/monitor_log/community_404.log'
echo ''> ${file}
url="http://community.internal.a.ajkdns.com/communities/5400;1713;660;1245;115954;580163;655792;116797;14461;"
http_code=`curl -i -m 10 -o /dev/null/ -s -w %{http_code} $url`
echo $http_code
sleep 1
if [ $http_code != "200" ];then
    echo "$url" >> ${file}
fi

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
    for t in $to
    do
        echo -e "To: \"${email_title}\" <${t}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${file}`" | /usr/sbin/sendmail -t
    done
fi
