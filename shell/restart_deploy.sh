#!/bin/bash
port=`netstat -ntpl|grep 4063`
if [[ $port == "" ]];then
    cd /home/www/releases/testDeploy
    nohup /usr/local/bin/python manage.py runserver 0.0.0.0:4063 > nohup.out 2>&1 &
fi
p=`echo $port|awk -F 'LISTEN' '{print $2}'|awk -F '/python' '{print $1}'`
if [[ $p == "" ]];then
    exit
fi
info=`ps -ef|grep ${p}|grep -v 'grep'`
num=`echo "$info"|grep -c 'evans'`
echo $num
if [[ $num == "1" ]];then
    kill $p
    cd /home/www/releases/testDeploy
    nohup /usr/local/bin/python manage.py runserver 0.0.0.0:4063 > nohup.out 2>&1 &
    echo `date` 'restart'
fi
