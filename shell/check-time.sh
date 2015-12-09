#!/bin/bash
h=`date|cut -c 12-13`
m=`date|cut -c 15-16`
echo `date`
echo $h
echo $m
#if [[ $h -ge 17 && $m -gt 30 ]];then
if [[ $h -ge 18 ]];then
echo "stop"
/home/evans/release-bin/stop-release.sh
else
echo "ing"
fi
