---
name: Cyberduck
type: client
---

[Cyberduck][1] is a free GUI WebDAV client for OS X. It's a clean and simple
WebDAV client.

It only supports basic file up and download operations, and doesn't deal with
locking or properties.

Connecting with Cyberduck
-------------------------

1. Connect with cyberduck user either 'quick connect' and fill in a dav://hostname url
2. Or create a new 'WebDAV' bookmark and enter the full http:// address 

Technical details
-----------------

Sample user agent:

    Cyberduck/3.0.3 (4205)

Cyberduck requests the following properties:

* displayname
* getcontentlength
* getcontenttype
* resourcetype
* getlastmodified
* lockdiscovery

Cyberduck at least understands HTTP Basic. Digest is currently untested.


[1]: http://cyberduck.io/
