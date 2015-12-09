#!/bin/bash
from_name="es数据error"
from="jianqiangni@anjuke.com"
to="jianqiangni@anjuke.com"
email_title=""
email_subject="es数据与access_log不一致"
file='/tmp/logstash'
has_con=`cat ${file}`
if [[ ! -z $has_con ]];then
    for t in $to
    do
        echo -e "To: \"${email_title}\" <${t}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${file}`" | /usr/sbin/sendmail -t
        rm $file
    done
fi
