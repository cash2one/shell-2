<?php
$ip=$_GET['ip'];
if ($ip == ""){
    echo 'please input ip';
    exit;
}
system("/data1/logs/heimingdan/addBlack.sh $ip");
