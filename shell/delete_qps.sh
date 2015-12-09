#!/bin/bash
source ~/.bash_profile
cd /home/www/userops/daily_ops_tool
/usr/local/bin/ansible all -i hosts -m shell -a 'rm -rf /tmp/qps';
