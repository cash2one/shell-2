#!/bin/bash
 ps -ef|grep -v 'dct-agent'|awk '{print $8,$9,$10,$11,$12,$13,$14,$15,$16}'|sort|uniq -c|sort -rn|head -n20|awk '$4!="" && $1 >1 '
