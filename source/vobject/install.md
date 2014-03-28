---
product: vobject
layout: default
title: Installation
---

sabre/vobject must be intalled using [composer][1].

Requirements
------------

You will need a recent version of PHP. sabre/vobject currently requires
PHP 5.3, but the next major release will require PHP 5.4

Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to do so.

From your project directory, the easiest is then to simply call:

    composer require sabre/vobject ~{{site.latest_versions.vobject}}

This rule ensures that you install the latest vobject package in the 3.1 range
of packages, but it does not install 3.2 or higher, which could result in a
backwards compatibility break.

After running this, sabre/vobject should be installed, and you can load it in
by including the autoloader:

    include 'vendor/autoload.php';

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/fruux/sabre-dav/releases
