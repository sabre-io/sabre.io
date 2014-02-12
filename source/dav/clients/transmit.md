---
title: Transmit
type: client
---

[Transmit][1] is a commercial WebDAV (as well as sftp and ftp) client for
OS/X. It can either browse WebDAV sites in a simple browser, but it's also
capable of mounting WebDAV drives using [MacFuse][2].

If you are ok with shelving out a few dollars, this is a _much_ better client
than [Finder](/dav/client/finder), and is well worth it.
 
Implementor notes
-----------------

Transmit 4 had issues with multiple namespace declarations (DAV: appeared
twice). This bug was promised to be fixed in a next version of Transmit,
but it's also fixed in SabreDAV since 1.2.0beta1.

Transmit's client is much better than the built-in OS/X one. It makes far less
request, as it seems to buffer all modifications for a while. Because of this
it's much more responsive uses far less HTTP requests / bandwidth.

Chunked Request Body problem
----------------------------

Transmit suffers from the same issue as the OS/X client, where it sends all
HTTP PUT requests as 'Chunked' transfer encoding. This is not supported by
many servers, such as lighttpd and nginx, as well as using apache + fastcgi.

If you plan to support Transmit you are strongly advised to just use
apache + mod_php.

**Note** The previous issue may well have been fixed since the last time we
looked.

Protocol details
----------------

Transmit uses the following user agent:

    WebDAVFS/1.2.7 (01278000) Transmit/4.0 neon/0.29.3

Transmit first does an `OPTIONS` request on the url, and then a propfind only
requesting the `{DAV:}resourcetype` property.

Once it's sure it's dealing with a collection, it requests the following
properties (depth: 1):

* `{DAV:}creationdate`
* `{DAV:}getcontentlength`
* `{DAV:}getlastmodified`
* `{DAV:}resourcetype`

When transmit is used to mount the webdav share, the following useragent is
used:

    WebDAVFS/1.2.7 (01278000) TransmitFSHelper/1.0 neon/0.29.3

It requests for the same properties as before, as well as the following:

* `{DAV:}quota-available-bytes`
* `{DAV:}quota-used-bytes`
* `{DAV:}quota`
* `{DAV:}quota-used`

The last 2 are non-standard.

Transmit (or OS/X) also seems to create a `.Trashes` folder as soon as the
connection is made.

[1]: http://www.panic.com/transmit/ 
[2]: http://code.google.com/p/macfuse/
