---
title: Cyberduck
type: client
---

[Cyberduck][1] is a free GUI WebDAV client for OS X and Windows. It's a clean
and simple WebDAV client. It's also very fast.

Connecting with Cyberduck
-------------------------

1. Connect with cyberduck user either 'quick connect' and fill in a dav://hostname url
2. Or create a new 'WebDAV' bookmark and enter the full http:// address 

Technical details
-----------------

Sample user agent:

    Cyberduck/3.0.3 (4205)
    Cyberduck/4.6.5 (Mac OS X/10.10.2) (x86_64)

Cyberduck uses `{DAV:}allprop` to request properties. Cyberduck supports custom
WebDAV properties, but puts them all in the `SAR:` namespace.

Sample PROPPATCH:

```
PROPPATCH /public/hello/cyberduck/1912186_10202225988704112_1640507935_n.jpg HTTP/1.1
Content-Type: text/xml; charset=utf-8
Content-Length: 188
Host: sabredav.evert
User-Agent: Cyberduck/4.6.5 (Mac OS X/10.10.2) (x86_64)
Accept-Encoding: gzip,deflate

<?xml version="1.0" encoding="UTF-8" standalone="yes"?><propertyupdate xmlns="DAV:"><set><prop><s:X-FOO xmlns:s="SAR:">X-Bar</s:X-FOO></prop></set><remove><prop/></remove></propertyupdate>
Content-Type: text/xml; charset=utf-8
Content-Length: 188
Host: sabredav.evert
User-Agent: Cyberduck/4.6.5 (Mac OS X/10.10.2) (x86_64)
Accept-Encoding: gzip,deflate
Authorization: Basic YWRtaW46YWRtaW4=

<?xml version="1.0" encoding="UTF-8" standalone="yes"?><propertyupdate xmlns="DAV:"><set><prop><s:X-FOO xmlns:s="SAR:">X-Bar</s:X-FOO></prop></set><remove><prop/></remove></propertyupdate>
```

Cyberduck at least understands HTTP Basic. Digest is currently untested.

[1]: http://cyberduck.io/
