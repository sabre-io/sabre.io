---
title: Scalability
layout: default
---

While the default library suffices for small-scale WebDAV installations, there
are areas that can be optimized for maximum performance, and operations in a
load-balanced environment.

This manual aims to cover the most important bits.

Tree
----

All operations are done on Nodes managed by the `Tree` class. In order for the
ObjectTree to find the nodes, it must traverse the entire tree.

You should optimize `getChildren()` and `getChild()` in your nodes as much as
possible to accommodate for it.

You can avoid traversing the tree by subclassing `Sabre\DAV\Tree` and
overriding `getChild`, `getChildren` and `childExists` with your own methods.

If this really helps you highly depends on your situation. Profile first,
optimize after.

### Move and Copy

Move and Copy operations can be slow, especially when moving/copying bigger objects.

Each of these methods traverses the entire tree, and operates on them one-by-one, as an
example, a move of a directory follows the following pattern:

* The Tree traverses the entire source tree, for each item it will
  * do a get() on the source file, and a createFile on the destination (heavy)
  * make subdirectories if directories are encountered
  * copy all the properties over in a similar fashion (if IProperties is used)
* Next, (if it was a move operation) it will traverse the entire source tree
again, deleting all files and directories one-by-one

It's possible to optimize `move` a great deal by implementing
`Sabre\DAV\IMoveTarget`. This interface allows a collection to 'receive' a
node that's being moved.

There's currently not an equivalent for `copy`, because moves are typically
an operation that can be optimized in a lot of systems if it's a simple
'rename', but this is often not true for copy operations.

To optimize copy, you must subclass the `Tree` class and reimplement the
function there.


### Delete

Delete operations might also by default traverse the tree and delete nodes one
by one. If your backend allows it, you might be able to optimize quickly
deleting subtrees simply by making modifications to a Node-specific
`delete` function.


CalDAV
------

If you created your own CalDAV backend, it may make sense to try to optimize
`calendarQuery`. The `Sabre\CalDAV\Backend\AbstractBackend` class provides a
standard implementation, that fetches every object for a calendar and tries to
see if the query filters out the object, or not.

The `Sabre\CalDAV\Backend\PDO` class tries to optimize this, by filtering a
bunch of common queries and directly applying them to the SQL queries.

In some cases it's confident enough to know that no further iCalendar parsing
is needed to figure out the final results.

It is also recommended to make sure that your `getCalendarObjects` method does
not return the iCalendar object, but it does return the 'size' and 'etag'
property.

This allows the server to not have to fetch the objects at all for certain
large operations, which can save a lot of memory.

Multiget
--------

If you use CalDAV, CardDAV or WebDAV-Sync operations, the server often has to
access many nodes by name.

This can be optimized by nodes by implementing the `Sabre\DAV\IMultiGet`
interface. This is implemented by default by the CalDAV and CardDAV backends.

Load Balanced SabreDAV
----------------------

SabreDAV has a few standard utilities for locking and catching 'temporary
files'. These classes (`Sabre\DAV\TemporaryFileFilterPlugin` and
`Sabre\DAV\Locks\Backend\File`) store information on the filesystem.

It would be possible to store these files on a network location instead, as
long as the network filesystem has proper support for flock() (which NFS as an
example doesn't).

The Locks backend in particular also comes in a `Sabre\DAV\Locks\Backend\PDO`
flavour, which can store locks in MySQL or PostgreSQL database.

Currently 'temporary files' don't get cleaned up, and a cron job should be
made to delete older files (>1 hour).

Large Files
-----------

Read: [Working with large files](/dav/large-files).
