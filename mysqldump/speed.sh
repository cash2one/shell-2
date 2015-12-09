#!/bin/bash
all=`cat speed_table`
for a in $all
do 
    echo $a
    mysqldump -h10.10.8.35 -u****** -p****** --lock-tables=false --add-locks=false --disable-keys=false -t black_box $a > d$a.sql
    mysqldump -h10.10.8.35 -u****** -p****** --lock-tables=false --add-locks=false --disable-keys=false -t black_box $a > t$a.sql
    sleep 1
    mysql -h10.126.103.230 -u****** -p****** black_box < d$a.sql
    mysql -h10.126.103.230 -u****** -p****** black_box < t$a.sql
    rm d$a.sql
    rm t$a.sql
    echo $a ok
    sleep 1
done

