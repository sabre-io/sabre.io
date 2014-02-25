---
title: BitKinex
type: client
---

BitKinex is a freeware WebDAV client for Windows. BitKinex is a simple
application that allows browsing WebDAV servers.

Technical details
-----------------

BitKinex will request the following properties:

* `{DAV:}getlastmodified`
* `{DAV:}getcontentlength`
* `{DAV:}getcontenttype`
* `{DAV:}resourcetype`
* `{DAV:}getetag`
* `{DAV:}lockdiscovery`

UTF-16
------

As of version 3.2.1, BitKinex sends all PROPFIND request encoded as UTF-16.
This was problematic for SabreDAV, because PHP's DOMDocument class did not seem
to support this.

A workaround has been implemented, which is released with SabreDAV 1.2.2.

Bugs
----

BitKinex seems to be very bad at any non-latin characters, or anything that
needs to be percent encoded.

For instance, if file `my picture.jpg` is sent, it will be encoded as
`my%2520picture.jpg`, instead of the expected `my%20picture.jpg`. This
indicates that the filename is double-percent encoded.

SabreDAV will comply with the incorrect filename. After BitKinex uploads the
file, it will check if the file exists. The incorrect filename now exists, but
BitKinex thinks it doesn't. As a remedy it will simply keep on trying to
upload and checking until a certain number of errors has been reached.

Therefore we don't recommend BitKinex unless it's for very simple usage and these concerns are not an issue.

User agent
----------

BitKinex sends the following user agent:

    BitKinex/3.2.1

