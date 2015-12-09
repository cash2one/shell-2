#!/bin/bash
#检查本次代码变更的文件语法状态
#注意：修改php路径！
#重要：执行该脚本前，先确定代码已提交。
WORK_DIR=$1
branch_name=$2
echo $1,$2 > /tmp/aaa
if [[ $WORK_DIR == "" ]];then
    echo "请输入代码仓库路径!"
    echo "脚本执行命令，例如：bash check_branch_syntax.sh /home/www/workspace/anjuke  pmt-12345-site-anjuke"
    exit
fi
if [[ $branch_name == "" ]];then
    echo "请输入分支名!"
    echo "脚本执行命令，例如：bash check_branch_syntax.sh /home/www/workspace/anjuke  pmt-12345-site-anjuke"
    exit
fi
if [ ! -d $WORK_DIR ];then
    echo $WORK_DIR '该路径不存在'
    exit
fi
cd $WORK_DIR
status=`git status | sed -n '/clean/p'`
if [[ ! $status ]];then
    echo '该工作目录有变更未处理，请先处理!'
    exit
fi
now_branch=`git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
if [[ $now_branch  == ${branch_name} ]];then
    git checkout master
    git branch -D ${branch_name}
fi
git fetch origin ${branch_name}:${branch_name}
git checkout ${branch_name}
#本次变更的文件
fileList=`git diff origin/master ${branch_name} --name-only|grep '.\php'`
rm /tmp/syntax/${branch_name}
for file in $fileList
do
    if [[ -f ${file} ]];then
        #PHP5.3与PHP5.5
        php -l $file
#        /usr/local/php-5.5/bin/php -l $file
        if [[ $? -ne 0 ]]; then
#            echo 'PHP5.3'  >> /tmp/syntax/${branch_name}
            php -l $file >> /tmp/syntax/${branch_name} 
#            echo 'PHP5.5'  >> /tmp/syntax/${branch_name}
#            /usr/local/php-5.5/bin/php -l $file >> /tmp/syntax/${branch_name}
            echo ${file} 
            echo 'php config must be syntax error.'
#            echo 'Bye'
#            exit 1
        fi
    fi
done
