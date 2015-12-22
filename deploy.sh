#!/bin/bash

domain=sabre.io
url=http://$domain

if [ ! -d "deploy" ]; then
    echo "The deploy directory does not exist yet."
    echo ""
    echo "Please run:"
    echo "./setup_deploy [remote url]"
    exit
fi;

./generate_css.sh source/less/sabre.less source/css/sabre.css

sculpin install
sculpin generate --env=prod --url=$url


cd deploy

echo "Fetching latest changes"
git checkout master
git pull

echo "Copying over the latest website version"
rm -r *
cp -r ../output_prod/* .

touch .nojekkyl
echo $domain > CNAME

git add -A
git commit -m "Automatic deployment `date -u`"

echo "Pushing changes"

git push origin master

echo "Deploy complete"
