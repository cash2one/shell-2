#!/bin/bash
init(){
ip=$1
port=$2
email_content=$3
echo "" > $email_content       
port1=${port//,/ }
for p in $port1
do
    #result=`(sleep 1;echo "exit";)|telnet 10.10.9.36 ${p}` 
    for((i=1;i<=10;i++));
    do
        result=`check_status $ip ${p}`
        if [[ ! $result =~ "character"  ]];then
            info="telnet 10.10.9.36 $p fail"
            echo "$info" >> $email_content 
        fi
    done
done
if [[ `cat $email_content` != "" ]];then
    send_mail $email_content
fi
}

check_status(){
    (sleep 1;echo "exit";)|telnet $1 $2
}

send_mail(){
from_name="mss_status"
from="jianqiangni@anjuke.com"
to="jianqiangni@anjuke.com"
email_title=""
email_subject="mss异常"
email_content=$1
 echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t
}


init 10.10.9.36 8965,8966,1111,8967 /data1/logs/status/mss_error.log
