#!/bin/bash
if [ ! -d "deploy" ]; then
    echo "The deploy directory does not exist yet."
    echo ""
    echo "Please run:"
    echo "./setup_github_pages [remote url]"
    exit
fi;

sculpin install
sculpin generate --env=prod

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
