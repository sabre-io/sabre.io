---
title: DavFS 
type: client
---

DavFS is the most popular client for linux. You use the `mount` command to set
up new webdav mounts that directly integrate into your filesystem.

It's also one of the most solid clients out there.

Connecting
----------

Simply type in:

    Enter : mount -t davfs http://urltoyourwebdavserver mymountpoint 

Technical notes
---------------

DavFS requires A Class 2 server, otherwise it will go into read-only mode. It
is possible to go into a read-write mode without a Class 2 server, by
specifying the `nolocks` option.

By default DavFSv2 will do lots of buffering and caching. This means that even
though a user has written to a file locally, it can take a while before the
changes actually show up on the server. This can be quite confusing when
working in teams.

### Sample user agent

    davfs2/1.1.2 neon/0.26.2
    davfs2/1.4.7 neon/0.30.0

### Properties

DavFSv2 asks for the following properties from the `DAV:` namespace

* getetag
* getcontentlength
* creationdate
* getlastmodified
* resourcetype

And from the `http://apache.org/dav/props/` xml namespace

* executable

