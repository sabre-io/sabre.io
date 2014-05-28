---
title: Property Storage Plugin
layout: default
type: plugin
plugin_name: propertystorage
plugin_since: 2.0.0
---

Since version 2.0.0 sabre/dav comes with a Property Storage plugin. This
plugin allows you to store any arbitrary property on any resource.

It is possible to create different backends for this plugin, but sabre/dav
ships with a PDO plugin.

The database schema can be found in `examples/sqlite.propertystorage.sql` and
`examples/mysql.propertystorage.sql`.

To set this up, just run:

    $storageBackend = new Sabre\DAV\PropertyStorage\Backend\PDO($pdo):
    $propertyStorage = new \Sabre\DAV\PropertyStorage\Plugin($storageBackend);
    $server->addPlugin($propertyStorage);

Note on ACL
------------

ACL will be enforced everywhere. Keep in mind though that for nodes where
ACL is not defined, the server default is to give full permissions.


Note on server design
---------------------

Some people design their servers that any user who logs in, gets a different
'view'. Some fileservers may for instance always only show the files in a
server that the user owns.

A problem exists for these users, that everybody shares the same namespace.
Since properties are stored per path, users may end up overwriting each
others.

Restricting paths
-----------------

It's possible to restrict in which paths properties may be stored. The
`Sabre\DAV\PropertyStorage\Plugin` class has a `$pathFilter` property that
accepts a callback.

This callback will be called for each path and should return true or false,
depending on if storing properties is allowed, or not.

Example:

    $propertyStorage = new \Sabre\DAV\PropertyStorage\Plugin($storageBackend);
    $propertyStorage->pathFilter = function($path) {
        if (strpos('foo', $path)===0) {
            return false;
        } else {
            return true;
        }
    };

The preceding example does not allow storing properties in paths that start
with 'foo'.
