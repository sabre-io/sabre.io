---
layout: default
product: dav
title: WebDAV Sync
---

Since version 1.9.0alpha1, sabre/dav comes with support for [WebDAV Sync][1].
WebDAV Sync provides a way for webdav servers to track what has been changed,
and send the list of changes back to client.

WebDAV-Sync has been implemented by almost every Cal- and CardDAV client, and
it has the ability to greatly reduce the number of HTTP requests needed, and
reduces memory usage, cpu and bandwidth on the sabredav server. It's very much
worth it to implement for these reasons alone.

The standard [CalDAV][2] and [CardDAV][3] PDO backends already provide support
for this, and therefore, all you need to do to enable this, is to add the
plugin to your server:

    $server->addPlugin(
        new Sabre\DAV\Sync\Plugin()
    );

CalDAV and CardDAV custom backends
----------------------------------

If you created your own custom backend, you will need to add a few more
methods to allow webdav-sync support to work.

To enable sync, your own backend class _must_ implement the
`Sabre\CalDAV\Backend\SyncSupport` interface, or for CardDAV
`Sabre\CardDAV\Backend\SyncSupport`.

A _lot_ of documentation on how to do this can be found in the actual
interfaces. It's best to simply read the documentation there:

* [CalDAV Backend SyncSupport documentation][2]
* [CardDAV Backend SyncSupport documentation][3]

What it comes down to is this:

> For every change, that is, an addition, deletion or modification of a
> calendar object, a vcard, a calendar or an addressbook, you must track
> this change and store it somewhere.
>
> When clients use webdav sync, they will start by receiving a token.
> The next time a client syncs, it will provide this token and ask the
> server to request all changes since that token was issued.


Adding Sync support to your other collections
---------------------------------------------

It is possible to add sync support to any custom collection. To do so, make
sure your collection implements the `Sabre\DAV\Sync\ISyncCollection` interface.

This interface only requires two new methods. It's also here best to just read
the [in-line documentation][4] as it's quite complete.

[1]: https://tools.ietf.org/html/rfc6578
[2]: https://github.com/fruux/sabre-dav/blob/master/lib/Sabre/CalDAV/Backend/SyncSupport.php
[3]: https://github.com/fruux/sabre-dav/blob/master/lib/Sabre/CardDAV/Backend/SyncSupport.php
[4]: https://github.com/fruux/sabre-dav/blob/master/lib/Sabre/DAV/Sync/ISyncCollection.php
