---
title: Scalability
layout: default
---

While the default library suffices for small-scall WebDAV installations, there are areas that can be optimized for maximum perfmance, and operations in a load-balanced environment.

This manual aims to cover the most important bits.

ObjectTree
----------

All operations are done on Nodes managed by the ObjectTree. In order for the ObjectTree to find the nodes, it must traverse the entire tree.

You should optimize `getChildren()` and `getChild()` in your nodes as much as possible to accomodate for it.

You can avoid traversing the tree by subclassing `Sabre\DAV\ObjectTree` and overriding `getChild`, `getChildren` and `childExists` with your own methods.

If this really helps you highly depends on your situation. Profile first, optimize after.

### Move and Copy

Move and Copy operations can be slow, especially when moving/copying bigger objects.

Each of these methods traverses the entire tree, and operates on them one-by-one, as an example, a move of a directory follows the following pattern:

* The ObjectTree tranverses the entire source tree, for each item it will
  * do a get() on the source file, and a createFile on the destination (heavy)
  * make subdirectories if directories are encountered
  * copy all the properties over in a similar fashion (if IProperties is used)
* Next, (if it was a move operation) it will traverse the entire source tree again, deleting all files and directories one-by-one

You can override the copy and move functionality by subclassing the ObjectTree, if this makes sense for you. In addition, if you purely use SabreDAV to expose a filesystem, you can choose to use `Sabre\DAV\Tree\Filesystem` instead of `Sabre\DAV\ObjectTree`. This class is specifically optimized for plain filesystems.

### Delete

Deleting files has similar problems, as it will also generally traverse the objecttree. If you have created your own File and Directory objects, you might be able to optimize access by overriding `delete()`, if your backends allow it.

CalDAV
------

If you created your own CalDAV backend, it may make sense to try to optimize `calendarQuery`. The `Sabre\CalDAV\Backend\AbstractBackend` class provides a standard implementation, that fetches every object for a calendar and tries to see if the query filters out the object, or not.

The `Sabre\CalDAV\Backend\PDO` class tries to optimize this, by filtering a bunch of common queries and directly applying them to the SQL queries.

In some cases it's confident enough to know that no further iCalendar parsing is needed to figure out the final results.

It is also recommended to make sure that your `getCalendarObjects` method does not return the iCalendar object, but it does return the 'size' and 'etag' property.

This allows the server to not have to fetch the objects at all for certain large operations, which can save a lot of memory.

Load Balanced SabreDAV
----------------------

SabreDAV has a few standard utilities for locking and catching 'temporary files'. These classes (`Sabre\DAV\TemporaryFileFilterPlugin` and `Sabre\DAV\Locks\Backend\FS`) store information on the filesystem.

It would be possible to store these files on a network location instead, as long as the network filesystem has proper support for flock() (which NFS as an example doesn't).

Storing locks could be implemented in a database server or caching layer such as memcached, the temporary files are a bit bigger, so that might pose some issues. We chose to not supply any plugins for these alternative backends, as there are a lot of options out there and impossible to cover them all. Instead it was made really easy to extend these subsystems.

Currently 'temporary files' don't get cleaned up, and a cron job should be made to delete older files (>1 hour).

Large Files
-----------

Read: [Working with large files](dav/working-with-large-files).
