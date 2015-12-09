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
#rm $file
rm $file_info
rm $file_result
echo '-------------------------'
all=`cat $file |awk -F ':' '{print $1}'|sort|uniq -c|sort -rn|grep php`
for a in $all
do
    all_memcache=`echo $a|grep "php"`
    for ar in $all_memcache
    do
        sed -i '/[0-9]\+/{N;s/\n//g}' `grep 'php' -rl $ar`
        for ((i = 11000; i <= 11550 ; i++)){
            r=`grep -r "$i" $ar`
            if [[ $r != "" ]];then
                echo $ar >> $file_info
                echo "$r"  >> $file_info
            fi
        }
    done
done
for ((i=2;i<10;i++))
do
r=`cat $file_info|awk -F 'host' '{print $'$i'}'`
    if [[ "$r" =~ "port" ]];then
        echo "$r"
        echo "$r" >> $file_result
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
