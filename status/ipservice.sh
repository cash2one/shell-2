#!/bin/bash
init(){
ip=$1
email_content=$2
echo "" > $email_content       
#for((i=1;i<=2;i++));
#do
        result=`check_status ${ip}`
        if [[ ! $result =~ "\"status\":\"ok\""  ]];then
            echo "$result" >> $email_content 
        fi
#    done
if [[ `cat $email_content` != "" ]];then
    send_mail $email_content 
fi
}

check_status(){
    echo 'http://ipservice1.a.ajkdns.com:8888/ip2City/'$1
    curl 'http://ipservice1.a.ajkdns.com:8888/ip2City/'$1
    echo '------------------------------------------------------'
    echo 'http://ipservice2.a.ajkdns.com:8888/ip2City/'$1
    curl 'http://ipservice2.a.ajkdns.com:8888/ip2City/'$1
}

send_mail(){
from_name="ipservice_status"
from="jianqiangni@anjuke.com"
to="jianqiangni@anjuke.com daiyuanjie@58.com"
#to="jianqiangni@anjuke.com"
email_title=""
email_subject="ipservice异常"
email_content=$1
for t in $to
do
 echo -e "To: \"${email_title}\" <${t}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t
done
}


init 61.171.118.151 /data1/logs/monitor_log/ipservice_error.log
#init 65.171.118.151 /data1/logs/status/ipservice_error.log
