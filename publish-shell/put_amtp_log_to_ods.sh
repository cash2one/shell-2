#!/bin/bash
#set -x 
basedir=/data1/logs/chat_db
#exec 1>>$basedir/rsync.log
#exec 2>&1

echo `date`"************ start ***********"
#date=$1
#if [ -z "$date" ];then
#    date=`date -d yesterday +%Y-%m-%d`
#fi

. /etc/profile.d/jdk.sh

export HADOOP_USER_NAME=mysql

hadoop_command_prefix="/home/www/apps/hadoop-2.3.0-cdh5.1.0/bin/hadoop --config /home/www/apps/yarn-conf/ "
dfs_remote_dir=/mysql_tar_file/chat_db/

$hadoop_command_prefix dfs -mkdir $dfs_remote_dir
cd $basedir
pwd
ls|grep "msg"|grep -v 'dealed'| while read logfile
do
    /usr/bin/lzop -f -1 $logfile -o $logfile.lzo
    mv $logfile "dealed_"$logfile

    $hadoop_command_prefix dfs -put $logfile.lzo $dfs_remote_dir
    if [ $? -eq 0 ];then
        rm -f $logfile.lzo
    fi
    echo $logfile 
    if [ $? -eq 0 ];then
        $hadoop_command_prefix jar /home/www/apps/hadoop-2.3.0-cdh5.1.0/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer $dfs_remote_dir
    fi
done

echo `date`"************ end ***********"
