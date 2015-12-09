#!/bin/bash
s=$1
server=`mysql -h****** -uaifang -p****** -A server_info -e "select server from server_info where server='"$s"'"`
for s in $server
do
    if [[ $s != "server" ]];then
        echo $s
        host=`mysql -h****** -uzabbix -p****** -A zabbix -e 'select hostid from hosts where host = "'"$s"'";'`
        hostid=`echo $host|awk '{print $2}'`
        item=`mysql -h****** -uzabbix -p****** -A zabbix -e "select itemid from items where hostid = "$hostid" and key_ like 'system.cpu.util%' limit 1;"`
        itemid=`echo $item|awk '{print $2}'`
        graph=`mysql -h****** -uzabbix -p****** -A zabbix -e "select graphid from graphs_items where itemid="$itemid""`
        graphid=`echo $graph|awk '{print $2}'`
        echo $hostid
        echo $itemid
        echo $graphid
        zabbix_url="http://zabbix10.corp.anjuke.com/charts.php?hostid=$hostid&graphid=$graphid"
        echo $zabbix_url
        mysql -h****** -uaifang -p****** -A server_info -e 'update server_info set zabbix_url = "'"$zabbix_url"'" where server="'"$s"'"';        
sleep 1
    fi
done
