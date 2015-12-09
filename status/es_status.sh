#!/bin/bash
from_name="es_status"
from="jianqiangni@anjuke.com"
to="jianqiangni@anjuke.com"
email_title=""
email_subject="es集群异常"
status=`curl 'http://app10-268:9200/_cluster/health'|grep 'green'`
if [[ ! $status != "" ]];then
    echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\nes集群异常" | /usr/sbin/sendmail -t
fi
