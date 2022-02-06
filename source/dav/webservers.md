---
title: Webservers
layout: default
---

Apache
------

SabreDAV is known to work well on Apache 2 with mod_php. SabreDAV runs best in
a dedicated vhost.

Here's a sample of apache vhost configuration that has worked well for many
users:

    <VirtualHost *:*>

        # Don't forget to change the server name
        # ServerName dav.example.org

        # The DocumentRoot is also required
        # DocumentRoot /home/sabredav/

        RewriteEngine On
        # This makes every request go to server.php
        RewriteRule ^/(.*)$ /server.php [L]

        # Output buffering needs to be off, to prevent high memory usage
        php_flag output_buffering off

        # This is also to prevent high memory usage
        php_flag always_populate_raw_post_data off

        # This is almost a given, but magic quotes is *still* on on some
        # linux distributions
        php_flag magic_quotes_gpc off

        # SabreDAV is not compatible with mbstring function overloading
        php_flag mbstring.func_overload off

    </VirtualHost>

### Authentication over fastcgi

If you use PHP through CGI or FastCGI and Apache authentication headers are
not passed through by default. You can enable this with the following
mod_rewrite rule:

    RewriteEngine on
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]

If you already had a mod_rewrite rule to map all urls to a server file, you
might need to change this to something like:

    RewriteEngine on
    RewriteRule .* /server.php [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]

Note the /server.php. Make sure this reflects the correct location of your
server file.


### mod_reqtimeout

It was reported that Apache's [mod_reqtimeout][2] can stop large uploads from
completing. This module is currently enabled by default on Ubuntu, and perhaps
others as well.

To fix this, turn off this module.


### 405 Errors

If you're getting 405 errors on apache, it's typically because your distro
ships with apache configuration that disables WebDAV HTTP methods.

To resolve this, usually in your webserver configuration there should be
`Limit` or `LimitExcept` directives that should be removed.


Nginx
-----

Older versions of nginx have had issues with so-called "Chunked Transfer
Encoding", in particular when the _client_ submits requests in this transfer
encoding.

Known clients that use this include [OS X finder](/dav/clients/finder) and
[Transmit](/dav/clients/transmit). If you plan to support any of these, and you
are running into issues with empty (0 byte) files ending up on the server,
make sure you are running a recent version of nginx.

Nginx versions 1.3.9 or higher should work.

Lighttpd
--------

lighttpd versions 1.4.44 or higher should work.

IIS
---

Not a lot of testing has been done with IIS, but here's some tidbits:

IIS might not set HTTP_AUTHORIZATION automatically. According to the
[PHP manual][1], you can enable it. Quote from the manual:

> Also note that until PHP 4.3.3, HTTP Authentication did not work using
> Microsoft's IIS server with the CGI version of PHP due to a limitation of
> IIS. In order to get it to work in PHP 4.3.3+, you must edit your IIS
> configuration "Directory Security". Click on "Edit" and only check "Anonymous
> Access", all other fields should be left unchecked.

There's a [tutorial on myroundcube.com][3] to get sabredav running on IIS.

[1]: http://www.php.net/manual/en/features.http-auth.php
[2]: http://httpd.apache.org/docs/2.2/mod/mod_reqtimeout.html
[3]: https://myroundcube.com/how-to/installing-sabredav-on-iis
