---
layout: default
---

Character encoding
==================

Urls and character encoding
---------------------------

HTTP does not define in what character-set urls are encoded. Urls are are
treated as binary strings. However, clients (as well as WebDAV clients) do
make assumptions about how these are encoded.

This poses a number of issues.

An ideal world
--------------

In any ideal world, clients only use US-ASCII for paths. The displayName
property should be used to present the client the filename, which, because
it's part of an xml body can be any valid XML encoding such as UTF-8.

Clients
-------

In general, only real webdav clients are affected by this, due to all
the different filenames. CalDAV and CardDAV stores are generally not affected
by this, because they tend to be pretty good at just sticking to safe
characters.

### Windows

Windows encodes files as ISO-8859-1 in request-urls. Starting SabreDAV
1.2.0alpha1 these will be automatically converted to their UTF-8 equivalents.

This only covers request-url's though, urls returned in PROPFIND bodies will
still be UTF-8. Some of these are reported to work, while others are not.

Read more on the [Windows](/dav/clients/windows) documentation page.

### OS/X Finder

OS/X finder uses UTF-8. In most cases this works without any issues. More
information can be found on the [Finder](/dav/clients/finder) page.

### Other clients

* [BitKinex](/dav/clients/bitkinex) is a known offender.

Internally
----------

All urls passed within SabreDAV are UTF-8 characters. Before 1.2.0alpha1
character sets were completely ignored, but now attempts are made to convert
to UTF-8 where possible.

In general this is only done to urls, specifically when urls are converted to
local paths and the reverse. This is all handled in `Sabre\DAV\URLUtil`.

Storage
-------

If you are using a database or other datastore to store your data (and url's),
you likely don't have to worry about this. Just make sure everything is UTF-8.

If you are using the filesystem to store files, this could be a little bit
problematic. Linux and OS/X treat files as binary strings. When displayed
in an application, the character encoding that will be used is based on the
current locale. This is actually great, because there's no need to worry about
these.

Windows is different though. NTFS uses UTF-16 internally to store filenames,
but PHP's filesystem wrappers appear to use ISO-8859-1. This is problematic,
because there's no clean mapping possible in many cases.

It might be useful in those cases to simply urlencode every filename before
storing. This will give a cross-platform consistent result and the files will
remain legible while checking it out with the console, etc.

[More information on this topic][1]

[1]: http://evertpot.com/filesystem-encoding-and-php/
