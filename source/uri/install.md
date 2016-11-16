---
product: uri
layout: default
title: Installation
---

Requirements
------------

sabre/uri must be installed using [composer][1].

You will need a recent version of PHP. sabre/uri 2.x requires PHP 7, but 1.x
has an identical api and supports PHP 5.5 and up.

Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to install it.

From your project directory, the easiest is then to simply call:

    composer require sabre/uri ^{{site.latest_versions.uri}}

This rule ensures that you install the latest stable uri package, and you'll
get any future updates (which never break backwards compatibility).

After running this, sabre/uri should be installed, and you can load it in
by including the autoloader:

    include 'vendor/autoload.php';

Source
------

The sabre/uri source can be found on [GitHub][3].

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/fruux/sabre-uri

