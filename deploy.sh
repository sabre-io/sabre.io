#!/bin/bash
if [ ! -d "deploy" ]; then
    echo "The deploy directory does not exist yet."
    echo ""
    echo "Please run:"
    echo "./setup_deploy [remote url]"
    exit
fi;

sculpin install
sculpin generate --env=prod
./generate_css.sh source/less/sabre.less source/css/sabre.css

cd deploy

echo "Fetching latest changes"
git checkout master
git pull

echo "Copying over the latest website version"
rm -r *
cp -r ../output_prod/* .

touch .nojekkyl

git add -A
git commit -m "Automatic deployment"

echo "Pushing changes"

git push origin master

echo "Deploy complete"
