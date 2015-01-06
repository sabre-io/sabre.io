---
product: xml 
layout: default
title: Installation
---

sabre/xml must be installed using [Composer][1].

Requirements
------------

You will need a recent version of PHP. sabre/xml currently requires PHP 5.4.

Installing with Composer
------------------------

If Composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to install it.

From your project directory, the easiest is then to simply call:

    composer require sabre/xml

After running this, sabre/xml should be installed, and you can load it in by
including the autoloader:

    include 'vendor/autoload.php';

Source
------

The sabre/xml source can be found on [GitHub][3].

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/fruux/sabre-xml

