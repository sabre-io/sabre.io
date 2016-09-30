---
title: 0 byte files
layout: default
---

There are a number problems that can cause empty files to appear on the server.
Because there are a number of different scenarios that can result in 0 byte
files, it's good to try to figure out which specific issue is the one you're
dealing with.


Webserver and chunked transfer encoding
---------------------------------------

There are a number of clients, in particular [OS X's Finder](/dav/clients/finder)
and [Transmit](/dav/clients/transmit) that use the so-called 'chunked tranfer'
encoding to create new files.

There are many webservers that do not support this. We recommend to use Apache
with mod_php (not fastcgi) or **a recent version** of nginx. Avoid Lighttpd.

When servers don't properly support chunked transfer encoding, the end result
seems to consistently be that either:

1. A `411 Length Required` error is returned.
2. Or: r the server completely discards the request body (from `PUT`) and
   effectively tells PHP and SabreDAV that an empty file was submitted.

See [Webservers](/dav/webservers) for more information.


Clients submitting files in two phases
--------------------------------------

There are a lot of WebDAV clients out there that create new files in two steps:

1. PUT an empty file
2. PUT again, but this time overwrite the original with the actual file data.

As a result, it may simply seem that there is an empty, broken `PUT` coming
in, when the real one still has to arrive.

This can be a bit problematic for people who write custom storage mechanisms
for SabreDAV ([Virtual filesystems](/dav/virtual-filesystems)). So keep in
mind that as you're writing custom nodes, and you want to support standard
WebDAV clients, receiving an empty 0-byte file first is expected.

Locking
-------

Furthermore, there are clients that support `LOCK`. Clients may `LOCK` a url
before creating a new file. The idea is that while the file is locked, some
other client cannot start creating a file with the same name.

How `LOCK` should behave on a non-existant url is a bit confusing, because the
initial webdav standard ([rfc2518][1]) differs from the updated standard
([rfc4918][2]). SabreDAV follows the recomendation from the latest
specification.

That is: If a client makes a `LOCK` request on a url that _does not yet_
exist, SabreDAV itself will create an empty file at that location.

So this is another situation where an empty file may be created before the
_actual_ file comes in.

Another reason might be, that the lock-file could not be created due to a nonexisting folder or insuficient permissions.
Check your logfiles for errors.

What if there is no follow-up PUT?
----------------------------------

If files stay empty, and there is no `PUT` request after the initial `LOCK`
or preflight `PUT`, the only explanation that can be given is, "there's a bug
somewhere".

It is possible that this bug is in your WebDAV client, it's also possible that
it's in SabreDAV.

The best recommendation we have is to fire up [Charles][4] and start
inspecting the traffic. You may simply come across a PHP error in charles that
explains everything. Note that the problem may not be in the actual `PUT`
request, but it could also be in surrounding requests such as `PROPFIND`

After that, we would just suggest to head to the [mailing list][3] so we can
investigate. 9 times out of 10 this tends to be a configuration mistake or a
bug somewhere in custom written code.

We will _almost always_ need a charles capture or a publically accessible
server though. Have this prepared to get to a solution quicker.

[1]: https://tools.ietf.org/html/rfc2518
[2]: https://tools.ietf.org/html/rfc4918
[3]: https://groups.google.com/forum/#!forum/sabredav-discuss
[4]: http://www.charlesproxy.com/
