---
title: Installation
layout: default
---

SabreDAV can either by installed using [composer][1], or manually, using a zip file.
it is highly recommended to use the former.

Requirements
------------

You will need a recent version of PHP. SabreDAV currently requires PHP 5.4

SabreDAV runs on any PHP-capable webserver. For maximum compatibility,
apache 2 with mod_php is recommended. This is especially true if you plan to
a file server. Card- and CalDAV servers run fine through FastCGI as well.

It's recommended to avoid Lighttpd altogether. See [Webservers](/dav/webservers)
for more information.

PHP Version requirements:

| SabreDAV version | PHP Version | First stable release | End of support      |
| ---------------- | ----------- | -------------------- | ------------------- |
| 2.1              | 5.4         | November 2014        | June 2016           |
| 3.0              | 5.4         | June 2015            | January 2017        |
| 3.1              | 5.5         | January 2016         | June 2017           |
| 3.2              | 5.5         | June 2016            |                     |


Installing with composer
------------------------

If composer is not yet on your system, [follow the instructions on getcomposer.org][2]
to do so.

To add the sabre/dav dependency to your project, simply run the following
command from the root of your project:

    composer require sabre/dav ~{{site.latest_versions.dav}}


This rule ensures that you install the latest stable sabre/dav.

After you've done this, you later on upgrade sabredav with the following
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
