#!/bin/bash
cd /home/www/userops/daily_ops_tool
ansible anjuke-zu-config -i test-hosts -m shell -a  '' 
