#!/bin/bash

if ! type "lessc" > /dev/null; then
    echo "The lessc compiler is not installed."
    echo ""
    echo "Please install lessc."
    exit
fi

YUICOMPRESSOR=yuicompressor
if ! type "yuicompressor" > /dev/null; then

    YUICOMPRESSOR=yui-compressor
    if ! type "yui-compressor" > /dev/null; then
        echo "Yuicompressor is not installed."
        echo ""
        echo "Please install yuicompressor."
        exit
    fi
fi

if [ $# -eq 0 ]; then
    echo "Usage: $0 [input file] [output file]"
    exit
fi

if [ ! -f $1 ]; then
    echo "File $1 does not exist yet."
    echo ""
    echo "Please run:"
    echo "sculpin generate"
    exit
fi

lessc --ru $1 | $YUICOMPRESSOR --type css > $2
