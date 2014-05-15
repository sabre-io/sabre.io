---
title: Installation
layout: default
---

SabreDAV can either by installed using [composer][1], or manually, using a zip file.
it is highly recommended to use the former.

Requirements
------------

You will need a recent version of PHP. SabreDAV currently requires PHP 5.3, but
the next major release will require PHP 5.4

SabreDAV runs on any PHP-capable webserver. For maximum compatibility,
apache 2 with mod_php is recommended. This is especially true if you plan to
a file server. Card- and CalDAV servers run fine through FastCGI as well.

It's recommended to avoid Lighttpd altogether. See [Webservers](/dav/webservers)
for more information.

PHP Version requirements:

| SabreDAV version | PHP Version | First stable release | End of support      |
| ---------------- | ----------- | -------------------- | ------------------- |
| 1.5              | 5.2         | August 2011          | February 2013 (EOL) |
| 1.6              | 5.3         | February 2012        | November 2013 (EOL) |
| 1.7              | 5.3         | October 2012         | May 2014            |
| 1.8              | 5.3         | November 2012        |                     |
| 2.0 (in beta)    | 5.4         |                      |                     |

Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to do so.

To start a new sabredav-based project, create a new empty directory. In this
directory, create a file named `composer.json`.

This file should look like this:

    {
        "require" : {
            "sabre/dav" : "1.8.*"
        }
    }


This rule ensures that you install the latest SabreDAV package in the 1.8
range of packages, but does not install 1.9 or higher, which would likely
result in breaking stuff.

After you have created this file, you can install sabredav with the following
command:


    composer update sabre/dav

The autoloader is in `vendor/autoload.php`.


Manual installation
-------------------

You can also [download][3] the latest package manually. This package is
distributed as a zip file.

To use it, just unzip it and include the `autoload.php` file in the `vendor/`
directory.

Source
------

The sabre/dav source can be found on [GitHub][4].

Next Steps
----------

Head over to [Getting Started](/dav/gettingstarted) to see what's next.

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/fruux/sabre-dav/releases
[4]: https://github.com/fruux/sabre-dav
