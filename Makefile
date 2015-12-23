#!/bin/bash

DOMAIN = sabre.io
URL = http://${DOMAIN}

.PHONY: all, generate, do-deploy, server

all: generate do-deploy

generate: source/css/sabre.css
	sculpin install
	sculpin generate --env=prod --url=${URL}

deploy: 
	echo "Deploy directory does not exist!"
	exit 255

do-deploy: deploy
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

source/css/sabre.css: source/less/*.less
	./generate_css.sh source/less/sabre.less source/css/sabre.css

