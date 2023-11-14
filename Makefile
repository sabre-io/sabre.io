# sabre.io
#
# vim: set fileencoding=utf-8:

DOMAIN = sabre.io
URL = https://${DOMAIN}

# SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md")

SOURCE_MD_FILES = $(shell find source/ -type f -name "*.md" -or -name "*.html")

.PHONY: all, server, output_dev, output_gh

all: output_dev, output_gh

gh-pages: composer.lock output_gh

server:
	vendor/bin/sculpin generate --watch --server

composer.lock: composer.json
	composer install

vendor/autoload.php:
	composer install

output_dev: output_dev/atom.xml

output_gh: output_gh/atom.xml

output_dev/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	vendor/bin/sculpin generate --env=dev --url=$(URL)

output_gh/atom.xml: source/css/sabre.css $(SOURCE_MD_FILES)
	# atom.xml always changes to the latest date and time, so we can use this
	# as the main target to figure out if the source changed at all.
	vendor/bin/sculpin generate --env=gh --url=$(URL)


YUI = $(shell which yuicompressor || which yui-compressor)
LESSC = $(shell which lessc)

source/css/sabre.css: source/less/*.less vendor/autoload.php
	@which $(YUI) > /dev/null
	@which $(LESSC) > /dev/null
	$(LESSC) --ru source/less/sabre.less | $(YUI) --type css > source/css/sabre.css

foo:
	echo $(SOURCE_MD_FILES)

clean:
	rm -Rvf output_dev/ source/components/* vendor/ source/*.css
