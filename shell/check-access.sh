#!/bin/bash
source ~/.bash_profile
cd /home/www/userops/usersite-ops-ansible
/usr/local/bin/ansible web -i logstash_host -m shell -a 'bash /home/www/publish-shell/access.sh';
