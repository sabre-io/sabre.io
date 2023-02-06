---
product: vobject
layout: default
title: Installation
---

sabre/vobject must be installed using [Composer][1].

Requirements
------------

| sabre/vobject version | PHP version |
| --------------------- | ----------- |
| 4.x                   | 5.5         |
| 3.x                   | 5.3.1       |


Installing with composer
------------------------

If Composer is not yet on your system, [follow the instructions on
`getcomposer.org`][2] to do so.

From your project directory, the easiest is then to simply call:

    composer require sabre/vobject ~{{site.latest_versions.vobject}}

This rule ensures that you install the latest VObject package in the 3.4 range
of packages, but it does not install 3.5 or higher, which could result in a
backwards compatibility break.

After running this, sabre/vobject should be installed, and you can load it in
by including the autoloader:

    include 'vendor/autoload.php';

Source
------

The sabre/vobject source can be found on [GitHub][3].

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/sabre-io/vobject
