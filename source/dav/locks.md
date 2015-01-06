---
title: WebDAV Locks 
layout: default
type: plugin
plugin_name: locks
plugin_since: 0.1
---

WebDAV has a 'locking' feature that allows a client to use the `LOCK` and
`UNLOCK` methods on resources.

When a resource is locked, other users are prevented from changing the
resource.

This feature is often used for WebDAV servers, and several clients such as
[davfs][1] and [Finder][2] require locks to work in order to enable
read-write support. Without it, they fall back to a read-only state.

Enabling locking
----------------

To enable locks, the easiest thing to do, is to use use the PDO backend.
To do this, you must first create a sqlite or mysql database, and create
the table as specified in one of these files:

* examples/sql/sqlite.locks.sql
* examples/sql/mysql.locks.sql

After the database has been created, connect to it using PDO and add the
locking plugin to your server.

    // Connnect to the database
    $pdo = new PDO('sqlite:data/locks.sqlite');

    // Create the backend
    $locksBackend = new Sabre\DAV\Locks\Backend\PDO();

    // Add the plugin to the server.
    $locksPlugin = new Sabre\DAV\Locks\Plugin(
        $locksBackend
    );
    $server->addPlugin($locksPlugin);



Other backends
--------------

SabreDAV also ships with a plugin that stores the data in a file, to use it,
just instantiate it with a filename that the server has write-access to:

    $locksBackend = new Sabre\DAV\Locks\Backend\File('/tmp/davlocks');

We don't recommend this. SQlite is effectively a 'single file' storage format,
and will work much better for these purposes.

It's also possible to create your own, by extending
`Sabre\DAV\Locks\Backend\AbstractBackend`.


[1]: /dav/clients/davfs/
[2]: /dav/clients/finder/
