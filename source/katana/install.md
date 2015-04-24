---
title: sabre/katana
product: katana
layout: default
---

If you downloaded sabre/katana as an archive, skip the pre-requisites.

Pre-requisites
--------------

To grab dependencies of the project, make sure you have [Composer] installed,
and then run:

    composer install

Also, make sure you have [Bower] installed, and then run:

    bower install

Then, to install sabre/katana, you have two options.

In your browser
---------------

You need to start an HTTP server; example with the PHP built-in server:

    php -S 127.0.0.1:8888 -t public public/.webserver.php

If you use another HTTP server, take a look at
`data/etc/configuration/http_servers/`, you will find more configuration files.

Then open [`127.0.0.1:8888`](http://127.0.0.1:8888) in your browser, you will be
redirected to the installation page.

In your terminal
----------------

You need to execute the following command:

    bin/katana install

If you are using Windows or you don't want a fancy interface, try:

    bin/katana install --no-verbose


[Composer]: http://getcomposer.org/
