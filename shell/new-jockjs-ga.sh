#!/bin/bash
version=$1
file=$2
which=$3
cd /home/www/userops/daily_ops_tool
echo 'version: '$version
if [[ $which == "" ]];then
ansible all-server -i hosts -m shell -a  ' echo '${version}' > /home/www/conf/'${file}'_jockjs_RELEASE_VERSION'
else
ansible $which -i hosts -m shell -a  ' echo '${version}' > /home/www/conf/'${file}'_jockjs_RELEASE_VERSION'
fi
