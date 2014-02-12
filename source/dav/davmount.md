---
title: DavMount
layout: default
type: plugin
plugin_name: davmount
plugin_since: 1.0.2
---

The DavMount plugin adds support for [rfc4709][rfc4709]. This spec defines a
small document that can tell a client how to mount a WebDAV server.

This was proposed as a better alternative to urls such as `webdav://` or
`dav://`.

However, the specification has not proven to be very popular. I'm not aware
of any implementations other than the sabredav implementation.

This plugin was added in SabreDAV 1.0.2.

Using DavMount
--------------

Add the plugin to your server.

    $server->addPlugin(new \Sabre\DAV\Mount\Plugin());

After this, simply open a DAV url in your browser and add ?mount. This will return the davmount document.

[rfc4709]: http://tools.ietf.org/html/rfc4709
