#!/bin/bash
all=`netstat -anp|grep "$1"|awk -F 'ESTABLISHED' '{print $2}'|awk -F '/' '{print $1}'`
for a in $all
do
    ps -ef|grep "$a"|grep -v 'grep'
done
