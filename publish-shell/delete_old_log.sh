#!/bin/bash
#删除无用log脚本
#crontab -e 添加0 0 9 * * bash /home/www/publish-shell/delete_old_log.sh  >> /data1/logs/delete_old_log.log 2>&1 
clear_log(){
    log_dir=$1
    month=$2
    year=$4
    if [[  -d "$log_dir" ]]; then 
        cd $log_dir 
        if [[ -z $year ]];then
            #如果没有规定月份，默认删除一个月前数据
            if [[ -z $month ]];then
                m=1
            fi
            if [[ $month =~ ',' ]];then
                all_month=${month//,/ }
                for m in $all_month
                do
                   ym=`date -d "-${m} month"  +"%Y${3}%m"`
                   delete_log $ym
                done
            else
                ym=`date -d "-${m} month"  +"%Y${3}%m"`
                delete_log $ym
            fi
        else
           delete_log $year
       fi
    else
        echo 该目录不存在：$log_dir
    fi
}

delete_log(){
    ym=$1
    echo $ym
    fileList=`find $floder |grep "$ym"`
    pwd
    for file in $fileList
    do
        echo '本次被清除的日志为：'$file
#        rm -rf $file
    done
}
#调用脚本
clear_log /data1/logs/ 1,2,3,4,5 -
clear_log /data1/logs/ 1,2,3,4,5 - 2014
clear_log /data1/logs/ 1,2,3,4,5 - 2013
clear_log /data1/logs/ 1,2,3,4,5 - 2012
clear_log /data1/logs/ 1,2,3,4,5 - 2012
clear_log /data1/logs/ 1,2,3,4,5 - 2011
clear_log /data1/logs/ 1,2,3,4,5 - 2010
echo '清理后磁盘空间如下'
df -h
