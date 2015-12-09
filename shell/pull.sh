#!/bin/bash
path='/home/evans/release/test'
cd $path
all=`ls`
for a in $all
do
    cd $path/$a
    git rd
    git co master 
    git pull --rebase origin master
done
