---
title: Character Encoding
layout: default
---

Main recommendation
-------------------

If you are either a client or a server developer, and you have to create
paths for things I would highly recommend using characters from this list.

This includes:

    A-Z // uppercase
    a-z // lowerchase
    0-9 // numbers
    - // dash
    _ // underscore
    . // full stop

This is the list of unreserved characters, with one exception: it doesn't
include the tilde (`~`).

These characters are pretty much guaranteed to work correctly across the
board. Everything else may be [percent encoded][1], depending on the client.

Problems with percent encoding
------------------------------

The following three urls are technically equivalent:

    http://example.org/~evert
    http://example.org/%7eevert
    http://example.org/%7Eevert

Bad clients may just look at those urls and consider them all as different
urls. This causes really weird bugs.

A second problem is characters that are not part of ascii, such as ü.

The ü (u-umlaut) may be encoded in different ways, usually either UTF-8 or
ISO-8859-1 (or CP-1252 or latin1, etc).

HTTP urls don't specify any encodings, they are just lists of bytes. As a
result a client may encode the url `http://example.org/üvert` as one of
the following:

    http://example.org/%FCvrt // latin-1
    http://example.org/%C3%BCvrt // utf-8 normalization form C
    http://example.org/u%CC%88vrt // utf-8 normalization form D

The last three urls are 'identical' for a user, but from a HTTP perspective
they are all distinct urls.

SabreDAV will accept either form and internally encode everything to UTF-8,
but we cannot fix bad-behaving clients.

Clients
-------

An imcomplete list of clients that have issues with this:

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

[More information on this topic][2]

[1]: http://en.wikipedia.org/wiki/Percent-encoding
[2]: http://evertpot.com/filesystem-encoding-and-php/
