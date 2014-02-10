---
layout: default
---

Virtual Filesystems
===================

SabreDAV is built to easily adapt existing business logic onto a virtual
network filesystem. This document explores how this can be setup.

* It is assummed in this tutorial that the reader has already went through the
  [GettingStarted](/dav/gettingstarted) and [FAQ](/dav/faq) manuals.
* In the code examples it is assumed all mentioned classes are currently
  loaded in through an include.

High-level API
--------------

SabreDAV is shipped with an API that should ease creating directory-tree structures.

Files and Directories
---------------------

Files and Directories both implement the `Sabre\DAV\INode` interface, this interface dictates the following methods should be implemented:

* `delete()` - deletes the file/directory.
* `getName()` - returns the file/directory name.
* `setName($newName)` - renames the directory.
* `getLastModified()` - returns the last modification time as a unix timestamp.

Additionally File objects need to implement the following methods:

* `put($data)` updates the data in the file.
* `get()` returns the contents of the file.
* `getETag()` - returns a unique identifier of the current state of the file. If the file changes, so should the etag. Etags are surrounded by quotes.
* `getContentType()` - returns the mime-type of the file.
* `getSize()` - returns the size in bytes.

Directories/Collections objects add the following:

* `getChild($name)` - Returns a File or Directory object for the child-node of the given name.
* `getChildren()` - Returns an array of File and/or Directory objects.
* `createFile($name,$data)` - Creates a new file with the given name.
* `createDirectory($name)` - Creates a subdirectory with the given name.
* `childExists($name)` - Returns true if a child node exists.

Inheritance tree
----------------

    Sabre\DAV\INode (base interface for all nodes in a tree)
     +-Sabre\DAV\IFile (base interface for all files)
     |  +-Sabre\DAV\File (base helper class)
     |
     +-Sabre\DAV\ICollection (base interface for all directories)
        +-Sabre\DAV\Collection (base helper class)

Next to the interfaces, there are two helper classes in this diagram (`Sabre\DAV\File` and `Sabre\DAV\Collection`). These classes are an easy starting point, as they will lock down most operations by default (by reporting 'permission denied'), so we can start with a read-only filesystem.

Implementation
--------------

Our read-only filesystem is going to be based off the standard server filesystem.

### Getting the classes ready

For this demonstration we need to create 2 classes, one for a directory and one for a file. We'll start out with the Directory class:

    use Sabre\DAV;

    class MyDirectory extends DAV\Collection {

      private $myPath;

      function __construct($myPath) {

        $this->myPath = $myPath;

      }

      function getChildren() {

        $children = array();
        // Loop through the directory, and create objects for each node
        foreach(scandir($this->myPath) as $node) {

          // Ignoring files staring with .
          if ($node[0]==='.') continue;
          $children[] = $this->getChild($node);

        }

        return $children;

      }

      function getChild($name) {

          $path = $this->myPath . '/' . $name;

          // We have to throw a NotFound exception if the file didn't exist
          if (!file_exists($path)) {
            throw new DAV\Exception\NotFound('The file with name: ' . $name . ' could not be found');
          }

          // Some added security
          if ($name[0]=='.')  throw new DAV\Exception\NotFound('Access denied');

          if (is_dir($path)) {

              return new MyDirectory($path);

          } else {

              return new MyFile($path);

          }

      }

      function childExists($name) {

            return file_exists($this->myPath . '/' . $name);

      }

      function getName() {

          return basename($this->myPath);

      }

    }

In the example is shown the absolute minimum of methods that need to be implemented in order to create a read-only directory. I'm hoping the code will speak for itself.

Same goes for the MyFile class:

    use Sabre\DAV;

    class MyFile extends DAV\File {

      private $myPath;

      function __construct($myPath) {

        $this->myPath = $myPath;

      }

      function getName() {

        return basename($this->myPath);

      }

      function get() {

        return fopen($this->myPath,'r');

      }

      function getSize() {

        return filesize($this->myPath);

      }

      function getETag() {

        return '"' . md5_file($this->myPath) . '"';

      }

    }

It's important thing to note is, that you should usually not pass strings around. Although the `get()` method can just return a string, especially with larger files it's recommended to use streams (as shown with fopen). The `put()` and `createFile()` methods will always get a readable stream resource as arguments.

### Setting up

I'm explaining the usage of your newly created server through code comments

    use Sabre\DAV;

    // Make sure there is a directory in your current directory named 'public'. We will be exposing that directory to WebDAV
    $publicDir = new MyDirectory('public');

    // The object tree needs in turn to be passed to the server class
    $server = new DAV\Server($publicDir);

    // We're required to set the base uri, it is recommended to put your webdav server on a root of a domain
    $server->setBaseUri('/');

    // And off we go!
    $server->exec();

### This is not virtual

Thats right! This is where you come in. You can make your MyFile and MyDirectory classes completely independent from the actual underlying filesystem. The list of items returned from `getChildren` could be a list of blogposts, and the 'get' method could return html data.

Write support
-------------

In order to get writing/modification support you should implement all the remaining methods. A good example of a completely built-out system like this can be found in the `Sabre\DAV\FS` directory. This system should closely mimic apache's mod_dav. Implementation of these is up to you (and optional) and is not written out in this manual, because at this point this should be fairly simple.

However, this is not enough. [OS/X Finder](/dav/clients/finder) and
[DavFS](/dav/clients/davfs) will demand you add locking support to your
filesystem.

Locking support
---------------

Locking helps ensuring no 2 people can overwrite each others changes. WebDAV has a system to accommodate locking. The simplest way to implement locking, is to use the Locks Plugin. Simply attach the Lock Manager to your Object Tree class, and you're off. The last example is extended to add a lock manager.

    use
        Sabre\DAV;

    // Make sure there is a directory in your current directory named 'public'. We will be exposing that directory to WebDAV
    $publicDir = new MyDirectory('public');

    // The root directory is passed to Sabre\DAV\Server.
    $server = new DAV\Server($publicDir);

    // We're required to set the base uri, it is recommended to put your webdav server on a root of a domain
    $server->setBaseUri('/');

    // Also make sure there is a 'data' directory, writable by the server. This directory is used to store information about locks
    $lockBackend = new DAV\Locks\Backend\File('data/locks.dat');
    $lockPlugin = new DAV\Locks\Plugin($lockBackend);
    $server->addPlugin($lockPlugin);

    // And off we go!
    $server->exec();
