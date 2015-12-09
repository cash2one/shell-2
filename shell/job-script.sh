#!/bin/bash
cd /home/www/userops/job-script
git pull --rebase origin master
cd /home/www/userops/daily_ops_tool
bash /home/www/userops/daily_ops_tool/update_config_script.sh 
