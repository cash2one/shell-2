#!/bin/bash
#!/bin/bash
l=`cat s|wc -l`
for((i=1;i<=$l;i++));
do
branch_id=`cat s|awk '{print $1}'|awk "NR==$i"`
echo $branch_id
plist_id=`cat s|awk '{print $2}'|awk "NR==$i"`
echo $plist_id
echo '-----------------'
mysql -hlocalhost -udeploy -p123456 -e "use deploy;update version_list set plist_id=$plist_id where branch_id=$branch_id"
done

exit


for((i=1;i<=1886;i++));do
id=`cat s.sql |awk {'print $1'}|awk 'NR=='${i}''`
branch=`cat s.sql |awk {'print $2'}|awk 'NR=='${i}''`
remote=`cat s.sql |awk {'print $3'}|awk 'NR=='${i}''`
echo $id
echo $branch
echo $remote
echo  "http://deploy.corp.anjuke.com/project/update?branch=${branch}&id=${id}&remote=${remote}"
curl -I "http://deploy.corp.anjuke.com/project/update?branch=${branch}&id=${id}&remote=${remote}"
done


