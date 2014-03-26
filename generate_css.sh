#!/bin/bash

if ! type "lessc" > /dev/null; then
    echo "The lessc compiler is not installed."
    echo ""
    echo "Please install lessc."
    exit
fi

if ! type "yuicompressor" > /dev/null; then
    echo "Yuicompressor is not installed."
    echo ""
    echo "Please install yuicompressor."
    exit
fi

if [ ! -d "output_dev" ]; then
    echo "The output_dev directory does not exist yet."
    echo ""
    echo "Please run:"
    echo "sculpin generate"
    exit
fi;

if [ $# -eq 0 ]; then
    echo "Usage: $0 [name of main less file without extension]"
    exit
fi

if [ ! -f ./output_dev/less/$1.less ]; then
    echo "File $1.less does not exist yet."
    echo ""
    echo "Please run:"
    echo "sculpin generate"
    exit
fi

cd output_dev

# remove less.js from html
find . -name "*.html" -exec sed -i '' '/less.min.js/ d' {} \;

# replace less stylesheet with css
find . -name "*.html" -exec sed -i '' 's/stylesheet\/less/stylesheet/ g' {} \;
find . -name "*.html" -exec sed -i '' 's/less\/\(.*\).less/css\/\1.css/ g' {} \;

# compile and compress less files
rm -rf css
mkdir css

lessc ./less/$1.less | yuicompressor --type css > ./css/$1.css

# remove less directory for deployment
rm -rf less
