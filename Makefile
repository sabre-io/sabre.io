#!/bin/bash
# EC 20160824 - why /bin/bash?

DOMAIN = sabre.io
URL = http://${DOMAIN}

# SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md")

SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md" -or -name "*.html")

.PHONY: all, generate, do-deploy, server, output_dev, output_prod

all: do-deploy

generate: composer.lock output_prod

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
	vendor/bin/sculpin generate --watch --server

composer.lock: composer.json
	composer install

output_dev: output_dev/atom.xml ;

output_prod: output_prod/atom.xml ;

output_dev/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	vendor/bin/sculpin generate --env=dev --url=$(URL)

output_prod/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	vendor/bin/sculpin generate --env=prod --url=$(URL)


YUI = $(shell which yuicompressor || which yui-compressor)
LESSC = $(shell which lessc)

source/css/sabre.css: source/less/*.less
	@which $(YUI) > /dev/null
	@which $(LESSC) > /dev/null
	lessc --ru source/less/sabre.less | $(YUI) --type css > source/css/sabre.css

foo:
	echo $(SOURCE_MD_FILES)

clean:
	rm -Rvf output_dev/ source/components/* vendor/ source/*.css


# Dockerization:

DOCKER_ENABLED=$(shell which docker; echo $$?)

docker_check:
ifeq ($(DOCKER_ENABLED), 1)
	@printf "cannot built target '%s' - docker not available or not running\n\n" $@
	@exit 1
endif
ifndef DOCKER_IMAGE
    # Assumes the existence of fruxx/sabre.io in hub.docker.com
    override DOCKER_IMAGE=fruxx/sabre.io
endif


docker_image: docker_check
	docker build -t $(DOCKER_IMAGE) --rm=true .

docker_push: docker_check
	docker push $(DOCKER_IMAGE)

docker_run: docker_check
	docker run --rm --name="sabre.io" -h "sabre.io" -p "8000:8000" -v $(shell pwd):"/var/www/html" $(DOCKER_IMAGE)

