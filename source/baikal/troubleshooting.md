---
product: baikal 
title: Troubleshooting
layout: default
---

Authentication issues
---------------------

Please refer to the following two documents for a list of common authentication-
related issues:

* [Webservers][1]
* [Authentication][2]


Can't connect with OS X Yosemite
--------------------------------

To connect with OS X Yosemite, it's required that you have two redirects in
place from the _root_ of your webserver.

This means that if your baikal is hosted under:

    http://dav.example.org/baikal/html/

The following two urls _must_ exist:

    http://dav.example.org/.well-known/caldav
    http://dav.example.org/.well-known/carddav

Both of these must redirect to

    http://dav.example.org/baikal/html/dav.php/

For an example of how to set this up, check out the sample configration on the [install][3] doc.

Can't connect with Windows 10
-----------------------------

The Windows 10 client does not support Digest authentication. So if you want
to support Windows 10, you _must_ use Basic auth. (and please, use SSL).


[1]: /dav/webservers/
[2]: /dav/authentication/
[3]: /baikal/install/
