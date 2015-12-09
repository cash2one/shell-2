#!/bin/bash
file='/tmp/memcache'
file_info="/tmp/memcache_info"
file_result='/tmp/memcache_result'
path=$1
if [ -z $path ];then
    echo 'please input path'
    exit
fi
#all_path=`ls $path|grep "config"|grep -v 'java'`
all_path=`ls $path|grep -v 'java'`
rm $file
rm $file_info
rm $file_result
grep -r 'port' $path|grep 'host'|grep -v '//'|grep -v 'dct'|grep -v '.log' >> $file
echo '-------------------------'
while read line
do
    echo $line|awk -F ':' '{print $2}'|grep 'host' >>$file_info
done <$file

for ((i=2;i<10;i++))
do
r=`cat $file_info|awk -F 'host' '{print $'$i'}'`
    if [[ "$r" =~ "port" ]];then
        echo "$r"
        echo "$r" >> $file_result
        echo "$r" >> /tmp/aaa
    fi
done

sed -i "s/ //g" `grep 'p' -rl $file_result`
sed -i "s/\t//g" `grep 'p' -rl $file_result`
sed -i "s/'//g" `grep 'p' -rl $file_result`
sed -i "s/=>//g" `grep 'p' -rl $file_result`
sed -i "s/port//g" `grep 'p' -rl $file_result`
sed -i "s/,/:/g" `grep 'p' -rl $file_result`
sed -i "s/)/:/g" `grep 'p' -rl $file_result`
cat $file_result |awk -F ':' '{print $1,$2}'|sort|uniq -c |sort -rn > $file_result
