#!/bin/bash --login
set -x

version=$1
appType=$2

if [ -z $1 ]; then
    echo "Please input {VERSION (YYYY_MM_patch)}.";
    exit;
fi

exec 1> /tmp/rsync.log.$version.$appType
exec 2>&1
echo "`date` ================begin============="

case $appType in
    'haozu')
        dir_ext='anjuke-zu/'
        ;;
    'jinpu')
        dir_ext='anjuke-jp/'
        ;;
    'wechat')
        dir_ext='wechat/'
        ;;
    'system')
        dir_ext='system/'
        ;;
    'system-ext')
        dir_ext='system-ext/'
        ;;
    'user-site')
        dir_ext='user-site/'
        ;;
esac
release_dir=/data1/release/site/v2/${dir_ext}$1/
if [ ! -d ${release_dir} ]; then
    mkdir -p ${release_dir}
#    chown evans:www-data -R /data1/release/
fi
#old=`cat /home/www/publish-shell/old_version`
#old_dir=/data1/release/site/v2/${dir_ext}$old/
#rsync -a $old_dir $release_dir
#~ 要跟common中的RELEASE_ROOT_TEMP 一致
machine_tag=${HOSTNAME}
rsync --delete-after -avzP -e ssh evans@app10-089.i.ajkdns.com:/home/evans/release/git/${appType}/ ${release_dir} --exclude=.git
#~ 记录日志
if [ $? -eq 0 ]; then
    ssh app10-089  'flock -e -w 3 /home/evans/release-bin/releaselog/'${version}'/rsync.log -c \
    "echo '${machine_tag}':`date`:'${appType}' rsync success ! |  \
    cat >> /home/evans/release-bin/releaselog/'${version}'/rsync.log"'
else
    echo '${machine_tag}':`date`:'${appType}' rsync failure !
    ssh app10-089  'flock -e -w 3 /home/evans/release-bin/releaselog/'${version}'/rsync.log -c \
    "echo '${machine_tag}':`date`:'${appType}' rsync failure ! |  \
    cat >> /home/evans/release-bin/releaselog/'${version}'/rsync.log"'
fi
echo "`date` ================end============="
