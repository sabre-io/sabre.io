---
title: NetDrive
type: client
---

**Editors note: This page was written for NetDrive 1, NetDrive seems to have
undergone a rewrite some time ago, so a lot of the criticism in this document
may no longer be true.**

[Netdrive][1] is a WebDAV client that mounts WebDAV shares as drives in windows.
It's a bit more straightforward to use than the Windows client, because it
doesn't require all sorts of registry settings to be changed, and it doesn't
share some of the bugs the windows client carries.

Implementor notes
-----------------

Netdrive does not support locking (or require it).

Under no circumstances Netdrive should be used in multi-user situations.
Netdrive will almost never check for updates from the server and will
completely assume WebDAV shares only ever get modified by the Netdrive user
itself. 

Unless you know absolutely sure it's only you who is modifying data, don't use
Netdrive.

Protocol details
----------------

Netdrive is not really a 'proper' WebDAV client, but thankfully it will only
do a small amount of simple requests, so it's easy for SabreDAV to handle.

Netdrive does not supply a user-agent http header, so it's not easy to
identify.

Netdrive does not do an `OPTIONS` request, to find out of the server supports
WebDAV. It will just start off with a PROPFIND request asking for 'allprops'.

After that it will ask for:

* `{DAV:}getcontentlength`
* `{DAV:}resourcetype`
* `{DAV:}creationdate`
* `{DAV:}lastaccessed (non-standard, should have been in another namespace)`
* `{DAV:}getlastmodified`

For any given directory, it will also do these requests for any subdirectories
(with depth 1), so it will always go 2 levels deep.

Netdrive appears to make heavy use of the 'Range' header, but in the cases
I've seen (smaller files) it actually uses the Range header to request the
entire file (pretty redundant).

When netdrive wants to save a file, it will first do a PROPFIND request, with
no elements in the 'prop' element. This was odd, and actually broke SabreDAV
(fixed in 0.8). 

After finding out (presumably that the file existed) it will delete the
original file, and then create a new one. This was all a bit odd to me because
it could have been performed in one step.

It was reported from the mailing list Netdrive actually never checks for
updates, it was mentioned that it's best to only use netdrive in single-user
situations.

[1]: http://www.netdrive.net/
