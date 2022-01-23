---
title: Installation
layout: default
---

SabreDAV can be installed using [composer][1]. We no longer provide releases as zip files.

Requirements
------------

SabreDAV runs on any PHP-capable webserver. For maximum compatibility,
apache 2 with mod_php is recommended. This is especially true if you plan to
a file server. Card- and CalDAV servers run fine through FastCGI as well.

It's recommended to avoid Lighttpd altogether. See [Webservers](/dav/webservers)
for more information.

For the PHP Version and module requirements, check out the [composer.json][5] file.


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


Source
------

The sabre/dav source can be found on [GitHub][4].

Next Steps
----------

Head over to [Getting Started](/dav/gettingstarted) to see what's next.

[1]: http://getcomposer.org/
[2]: https://getcomposer.org/doc/00-intro.md#installation-nix
[3]: https://github.com/sabre-io/dav/releases
[4]: https://github.com/sabre-io/dav
[5]: https://github.com/sabre-io/dav/blob/master/composer.json
