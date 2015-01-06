---
layout: default
product: dav
title: WebDAV properties
---

Properties are close to the heart of WebDAV. Every resource and collection
has at least a few properties. Properties are retrieved by clients using
`PROPFIND`, and they can be updated using `PROPPATCH`.

There are two categories of properties, 'dead' properties and 'live'
properties. The best explanation is that 'live' properties generally are
calculated based on some value, and 'dead' properties don't do anything, they
are just set and retrieved.

Property storage plugin
-----------------------

Since version 2.0, sabredav ships with a plugin that is specifically
designed to store any webdav property that a client may send.

See [property storage][1] for more information.


[1]: /dav/property-storage/
