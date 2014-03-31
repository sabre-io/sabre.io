---
product: event
layout: default
title: Installation
---

sabre/event must be intalled using [composer][1].

Requirements
------------

You will need a recent version of PHP. sabre/event currently requires PHP
5.4.

Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to install it.

From your project directory, the easiest is then to simply call:

    composer require sabre/event ~{{site.latest_versions.event}}

This rule ensures that you install the latest event package in the 1.0 range
of packages, but it does not install 1.1 or higher, which could result in a
backwards compatibility break.

After running this, sabre/event should be installed, and you can load it in
by including the autoloader:

    include 'vendor/autoload.php';

Source
------

The sabre/event source can be found on [Github][3].

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/fruux/sabre-event

