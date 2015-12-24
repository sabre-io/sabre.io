#!/bin/env bash

DOMAIN = sabre.io
URL = http://${DOMAIN}

# SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md")

SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md")

.PHONY: all, generate, do-deploy, server, output_dev, output_prod

all: do-deploy

generate: sculpin.lock output_prod

do-deploy: generate
	cd deploy && \
	echo "Fetching latest changes" && \
	git checkout master && \
	git pull && \
	echo "Copying over the latest website version" && \
	rm -r * && \
	cp -r ../output_prod/* . && \
	touch .nojekkyl && \
	echo $(DOMAIN) > CNAME && \
	git add -A && \
	git commit -m "Automatic deployment `date -u`" && \
	echo "Pushing changes" && \
	git push origin master && \
	echo "Deploy complete"

server:
	sculpin generate --watch --server

sculpin.lock: sculpin.json
	sculpin install

output_dev: output_dev/atom.xml ;

output_prod: output_prod/atom.xml ;

output_dev/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	sculpin generate --env=dev --url=$(URL)

output_prod/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	sculpin generate --env=prod --url=$(URL)


YUI = $(shell which yuicompressor || which yui-compressor)
LESSC = $(shell which lessc)

source/css/sabre.css: source/less/*.less
	@which $(YUI) > /dev/null
	@which $(LESSC) > /dev/null
	lessc --ru source/less/sabre.less | $(YUI) --type css > source/css/sabre.css

foo:
	echo $(SOURCE_MD_FILES)
