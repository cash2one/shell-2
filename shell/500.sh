#!/bin/bash
curl -c cookie -d  "f1=beta" http://shanghai.anjuke.com/version/switch
urlAll="http://shanghai.anjuke.com/,http://shanghai.anjuke.com/sale/,http://shanghai.anjuke.com/ask"
urlList=${urlAll//,/ }
for url in $urlList
do
if [[ $url = "http://shanghai.anjuke.com/" ]];then
count=6
else
count=50
fi
for ((i=1;i<$count;i++));do
curl -b cookie $url >source.txt
html=`cat /home/evans/release-bin/source.txt`
keyword="二手房";
[[ "${html/$keyword/}" != "$html" ]] && app="2" || app="1"
if [[ $app = "1" ]];then
infoAll=`curl -b cookie -I $url`;
echo $infoAll|cut -c164-187 >/home/evans/release-bin/info.txt
info=`cat /home/evans/release-bin/info.txt`;
echo $info
touch /home/evans/release-bin/$1.txt
versionInfo=`cat /home/evans/release-bin/$1.txt`;
echo $info >>/home/evans/release-bin/$1.txt
fi
done
done

