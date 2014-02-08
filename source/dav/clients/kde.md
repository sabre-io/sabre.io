---
name: KDE 
type: client
---

KDE is a bit of a chatty client, doing a significant number of redundant
requests. But nowhere near as much as [Finder](/dav/clients/finder).

Technical details
-----------------

User agent:

    Mozilla/5.0 (compatible; Konqueror/4.4; Linux) KHTML/4.4.2 (like Gecko) Kubuntu

KDE identifies itself as it's browser 'Konqueror', presumably because the same
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

`{DAV:}executable` is non-standard. There's a [DAVFS](dav/clients/davfs)
pseudo-standard to find out if a file is an executable, but it's in a
different namespace.

