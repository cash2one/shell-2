#!/bin/bash
init(){
servers=$1
servers1=${servers//,/ }
email_content=$2
echo > $email_content
for server in $servers1
do
#    ping -q -c 3 $server -W 2
    ping -q -c 1 $server -W 2
    if (( $? == 1 ));then
        echo $server >> $email_content
    fi
done
if [[ `cat $email_content` != "" ]];then
#    send_mail $email_content
echo $email_content
fi
}

send_mail(){
from_name="server_alive_monitor_log"
from="jianqiangni@anjuke.com"
to="18516272352@wo.com.cn jianqiangni@anjuke.com"
email_title=""
email_subject="server not alive"
email_content=$1
for t in $to
do
 echo -e "To: \"${email_title}\" <${t}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t
done

# echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t
}

init app10-021,app10-024,app10-025,app10-050,app10-051,app10-052,app10-069,app10-070,app10-071,app10-073,app10-074,app10-101,app10-110,app10-111,app10-115,app10-116,app10-117,app10-118,app10-119,app10-124,app10-125,app10-126,app10-127,app10-128,app10-129,app10-137,app10-147,app10-148,app10-149,app10-150,app10-151,app10-152,app10-153,app10-154,app10-177,app10-198,app10-199,app10-200,app10-201,app10-202,app10-205,app10-261,xapp10-180,xapp10-191,xapp10-194,xapp10-195,xapp10-196,xapp10-222 /data1/logs/monitor_log/alive_error.log 
