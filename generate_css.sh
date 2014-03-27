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

lessc $1 | yuicompressor --type css > $2
