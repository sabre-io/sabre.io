---
layout: default
---

Webservers
==========

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

    </VirtualHost *:*>


Nginx
-----

Older versions of nginx have had issues with so-called "Chunked Transfer
Encoding", in particular when the _client_ sumbits requests in this transfer
encoding.

Known clients that use this include [OS X finder](dav/clients/finder) and
[Transmit](dav/clients/transmit). If you plan to support any of these, and you
are running into issues with empty (0 byte) files ending up on the server,
make sure you are running a recent version of nginx.

Nginx versions 1.3.9 or higher should work.

Lighttpd
--------

Using lighttpd is generally not recommended. Development has been incredibly
slow in recent years, and lighttpd does not have support for many required
HTTP methods, such as `MKCALENDAR`, `MKCOL`, `ACL`, etc.


