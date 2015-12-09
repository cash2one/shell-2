#!/bin/bash -l

. common-pages.sh

#~ 判断是否有人在上线
if [ -f cv-$1pages.lock ];then
    echo "Version is releasing,Please wait a moment! "
    exit
else
    touch ${BIN_ROOT}/cv-$1pages.lock
fi
    app=$1
    if [ ${app} == 'job'  ];then
        cd /home/www/userops/job-script
        git pull --rebase origin master
        git log -n10
        cd /home/www/userops/daily_ops_tool
        bash /home/www/userops/daily_ops_tool/update_config_script.sh 
    elif [ ${app} == 'silian'  ];then
        bash /home/evans/release-bin/baidu_silian.sh
    else
        cd $RELEASE_ROOT_PAGES/$app
        if [ ${app} == 'anjuke'  ];then
            svn up
        else 
            `git pull --rebase origin master`
        fi
        #!建议上线代码都取出以后，再一起去同步
        string_machines=''
        appServer= 
        #~  首字母大写
        upper_app=`echo $app|sed "s/\b[a-z]/\U&/g"`
        servers='arr'$upper_app'AppServer[@]'
        #~ 拼接服务器字符串
        for machine in ${!servers}
        do
            string_machines="${string_machines} -m ${machine} "
        done
    #    echo "现在正在同步到 ${string_machines}";
        `dsh -r ssh -c ${string_machines} "${SERVER_BIN_ROOT}/rsync-pages.sh"  $app`
         git log -n10
    fi
#~ 移除锁文件
rm ${BIN_ROOT}/cv-$1pages.lock
