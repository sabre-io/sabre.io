---
title: Gnome
type: client
---

The Gnome client is a solid and efficient WebDAV client.

Technical details
-----------------

### Spotted user agent(s):

    gvfs/1.4.1
    gvfs/1.20.1


### Properties

Gnome will request the following properties:

* `{DAV:}creationdate`
* `{DAV:}displayname`
* `{DAV:}getcontentlength`
* `{DAV:}getcontenttype`
* `{DAV:}getetag`
* `{DAV:}getlastmodified`
* `{DAV:}resourcetype`

### Redirect references

Gnome seems to specify the header:

    Apply-To-Redirect-Ref: T

This is defined in [rfc4437][rfc4437], and seems to indicate it has support
for this. This is very interesting, because it might mean it perhaps supports
hopping from server to server, or softlinks. (needs some investigation).

### Copying directories

If you are running a Gnome version older than 3.0.2, you may be affected by
this (pretty serious) issue. Later versions should have this fixed though.

Copying directories completely fails. GVFS does a GET on the source url, and a
PUT on the destination url. While this works fine for files, for directories
it's broken.

Often times this results in a file being created at the destination, with the
contents of whatever a GET on the source was, often a html index. 

Reference: [Gnome bug 551339][1].

### URL Encoding

Gnome did not seem to like url-encoding of ( and ). While these have no
special meaning in http urls, these are considered 'reserved' and encoded by
for example php's urlencode.

SabreDAV 1.0.12 and 1.2.0alpha1 will ship with a custom urlencoder for this
purpose.

A more severe issue is that recent versions don't deal well with encoded
characters at all. SabreDAV defaults to encoding characters to lower-case
(`%c3%a1`), while Nautilus only seems to accept them as upper-case (`%C1%A1`).

### Creating empty files

Reference: [Gnome bug 603422][2].

Gnome has a feature to create a new empty document using the Nautilus
interface. Gnome will do this with a PUT request with no body. It also doesn't
send a Content-Length header, which might cause a problem for some webservers,
which could respond with '411 Length Required'

[rfc4437]: http://tools.ietf.org/html/rfc4437
[1]: https://bugzilla.gnome.org/show_bug.cgi?id=551339
[2]: https://bugzilla.gnome.org/show_bug.cgi?id=603422
