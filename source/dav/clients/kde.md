---
title: KDE
type: client
---

KDE is a great, stable and modern client. The KDE client is fast, and does
very little requests.

It also is able to do efficient `MOVE` operations. It also uses `COPY` but
unfortunately does not yet copy entire directory trees.

Technical details
-----------------

User agent:

    Mozilla/5.0 (compatible; Konqueror/4.4; Linux) KHTML/4.4.2 (like Gecko) Kubuntu
    Mozilla/5.0 (X11; Linux i686) KHTML/4.14.1 (like Gecko) Konqueror/4.14

KDE identifies itself as its browser 'Konqueror', presumably because the same
HTTP client library is used.

### Properties

* `{DAV:}creationdate`
* `{DAV:}getcontentlength`
* `{DAV:}displayname`
* `{DAV:}source`
* `{DAV:}getcontentlanguage`
* `{DAV:}getcontenttype`
* `{DAV:}executable`
* `{DAV:}getlastmodified`
* `{DAV:}getetag`
* `{DAV:}supportedlock`
* `{DAV:}lockdiscovery`
* `{DAV:}resourcetype`

`{DAV:}executable` is non-standard. There's a [DAVFS](/dav/clients/davfs)
pseudo-standard to find out if a file is an executable, but it's in a
different namespace. The `{DAV:}executable` actually no longer appears in
newer versions.

