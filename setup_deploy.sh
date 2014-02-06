#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 [github remote url] [branch]"
    exit
fi

mkdir deploy/
cd deploy/

git init
git remote add origin $1
git pull
git checkout $2
