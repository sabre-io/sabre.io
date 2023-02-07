---
product: http
layout: default
title: Installation
---

sabre/http must be installed using [composer][1].

Requirements
------------

You will need a recent version of PHP. `sabre/http` currently requires PHP 5.4.

Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on
Composer's website][2] to install it.

From your project directory, the easiest way is then to simply call:

    composer require sabre/http ~{{site.latest_versions.http}}

This rule ensures that you install the latest HTTP package in the 2.0 range
of packages, but it does not install 2.1 or higher, which could result in a
backwards compatibility break.

After running this, `sabre/http` should be installed, and you can load it in
by including the autoloader:

    include 'vendor/autoload.php';

Source
------

The `sabre/http` source can be found on [GitHub][3].

[1]: https://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/sabre-io/http
