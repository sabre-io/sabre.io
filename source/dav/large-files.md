---
title: Working with large files
layout: default
---

Using streams
-------------

In order to allow transfers of big files, SabreDAV makes use of streams
everywhere internally.

This allows you to deal with very large files (tried up to 15GB), without
requiring a high number for memory_limit.


PHP Configuration
-----------------

For this to work, output buffering _must_ be turned off. It appears to be
on for some php installations. Not turning this off will make PHP return
memory-related errors.

In php ini, this should be:

    output_buffering=off

Or if you're setting php settings through apache:

    php_flag output_buffering off

More information can be found on [webservers](/dav/webservers).


32bit vs 64bit
--------------

The maximum filesize we can currently represent on 32bit systems is 2 GB.
To support files larger than 2GB, make sure that your PHP is compiled for
64 bit.


PHP bugs
--------

We recently [found out][1] that PHP's [`fpassthru()`][2] method is [broken][3]
for large files, and does not allow files to be served over 2GB.

A fix has been made for SabreDAV 1.7.11 and 1.8.9. So make sure you are
running at least one of those two versions.

mod_security woes
-----------------

If you're running Apache, and particularly on a shared host, there's a
reasonable chance [mod_security][4] is deployed, which can limit the total
size of request bodies and thus restricts large uploads with `PUT`.

The main symptom for this is a server responding with the HTTP status code
`413 Request Entity Too Large.`

The setting to look for is called `SecRequestBodyLimit`.

[1]: http://evertpot.com/fpassthru-broken/
[2]: http://www.php.net/manual/en/function.fpassthru.php
[3]: https://bugs.php.net/bug.php?id=66736
[4]: http://www.modsecurity.org/
