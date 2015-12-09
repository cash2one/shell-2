#!/bin/bash --login

machine_tag=${HOSTNAME}
for((i=1;i<=500;i++))
do
    #~ sleep 1s
    ssh app10-089  'flock -e -w 3 /home/evans/release-bin/releaselog/2013_01_01/create-version.log -c "echo '${machine_tag}':`date` |  \
    cat >> /home/evans/release-bin/releaselog/2013_01_01/create-version.log"'
done
