---
layout: default
product: dav
title: The base uri
---

This document exists to explain the number one problem people have with
sabre/dav: setting a correct base uri.

Often after you set up any Cal-, Card- or WebDAV server, you may get an error
like this:

    <d:error>
      <s:sabredav-version>2.0.4</s:sabredav-version>
      <s:exception>Sabre\DAV\Exception\NotFound</s:exception>
      <s:message>File not found: sabredav in 'root'</s:message>
    </d:error>

The actual filenames vary, but usually it will be something like that.

This is a short guide to help you figure out how to solve this.

What is the base URI
--------------------

After you install sabredav, you may access your server through a url like
these:

    http://server.example.org/sabredav/server.php
    http://server.example.org/sabredav/calendarserver.php
    http://server.example.org/sabredav/addressbookserver.php
    http://server.example.org/sabredav/groupwareserver.php

Any of those urls are valid, and it's completely up to you in which directory
you run sabredav, or how you name your 'server file'. We strongly recommend
against calling your server file `index.php` because this causes additional
confusion. `server.php` is the best name.

After you set up this file, you need to tell sabredav what this url is.

Every example server file with contain a line such as this:

    $server->setBaseUri(...);

You need to make sure that whats specified as `...` here, matches the base
path to your server. For the first 4 examples we showed, the value would
be this:

    /sabredav/server.php
    /sabredav/calendarserver.php
    /sabredav/addressbookserver.php
    /sabredav/groupwareserver.php


Why is this important?
----------------------

In sabredav, a full url may look something like this:

    http://server.example.org/sabredav/server.php/files/photo.jpg

SabreDAV needs to split this up in two components, which are these two:

    http://server.example.org/sabredav/server.php
    /files/photo.jpg

SabreDAV only cares about the last part, but it can not easily figure out
where the 'script' ends and where the the other path starts.


I would like to use clean urls
------------------------------

It's entirely possible to change this url:

    http://server.example.org/server.php/files/photo.jpg

And use urls like this instead:

    http://server.example.org/files/photo.jpg

But please note that the answer to this, is _NOT_ changing the filename
to index.php.

Instead, you _must_ use 'url rewriting'.

You should only attempt this *after* you already have sabredav up and running
with an ugly url, as this will reduce the number of potential issues.

Using rewriting for this is different depending on which webserver you use.
For apache, you may have to create a virtual host, and add ruls such as this:

        RewriteEngine On
        # This makes every request go to server.php
        RewriteRule .* /server.php [L]

If you use .htaccess, it may instead look like this:

        RewriteEngine On
        # This makes every request go to server.php
        RewriteRule .* server.php [L]

However, configuration is completely different if you use nginx, IIS, or
anything else. Consult your server's manual to figure out how.

After you've made this change, you can change `server.php` to make the
baseUri look like this:

    $server->setBaseUri('/');

More information can also be found on the [Web Servers][1] page.

[1]: /dav/webservers/
