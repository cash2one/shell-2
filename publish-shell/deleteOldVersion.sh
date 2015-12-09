#!/bin/bash
clear_repo(){
    DAY_DIFF=1
    RELEASE_DIR=$1
    GA=`cat $2 | awk -F "_" '{print $1$2}'`
    BETA=`cat $3 | awk -F "_" '{print $1$2}'`
    MIN_NUM=$GA
    if [ "$GA" -ge "$BETA" ];then
        MIN_NUM=$BETA
    fi
    BEFORE=`expr $MIN_NUM -  $DAY_DIFF`
    if [[  -d "$RELEASE_DIR" ]]; then
       cd $RELEASE_DIR
       echo '---------------------------'$RELEASE_DIR
       echo 'GA:'$GA
       echo 'BETA:'$BETA
       echo 'KEEP:'$BEFORE
       find 20* -maxdepth 0| awk -F"_" '$1$2<"'$BEFORE'" {print $0}'| xargs -n 8 rm -rf
       rm -rf 952* 
    fi
}
clear_repo "/home/www/release/v2" "/home/www/conf/RELEASE_VERSION"  "/home/www/conf/RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/anjuke-jp" "/home/www/config/machine/JP_RELEASE_VERSION" "/home/www/config/machine/JP_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/anjuke-zu" "/home/www/config/machine/ZU_RELEASE_VERSION" "/home/www/config/machine/JP_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/anjuke_usersite" "/home/www/conf/anjuke_usersite_RELEASE_VERSION" "/home/www/conf/anjuke_usersite_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/zufang_usersite" "/home/www/conf/zufang_usersite_RELEASE_VERSION" "/home/www/conf/zufang_usersite_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/shangpu_usersite" "/home/www/conf/shangpu_usersite_RELEASE_VERSION" "/home/www/conf/shangpu_usersite_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/pad_usersite" "/home/www/conf/pad_usersite_RELEASE_VERSION" "/home/www/conf/pad_usersite_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/touch_usersite" "/home/www/conf/touch_usersite_RELEASE_VERSION" "/home/www/conf/touch_usersite_RELEASE_VERSION_BETA"
clear_repo "/data1/release/site/v2/member_usersite" "/home/www/conf/member_usersite_RELEASE_VERSION" "/home/www/conf/member_usersite_RELEASE_VERSION_BETA"
