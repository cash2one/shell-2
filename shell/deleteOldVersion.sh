#!/bin/bash
source ~/.bash_profile
cd /home/www/userops/daily_ops_tool/;
sleep 5;
/usr/local/bin/ansible all-server -i hosts -m shell -a "/home/www/publish-shell/deleteOldVersion.sh";

