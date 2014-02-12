---
layout: default
---

SimpleCollection
================

The `Sabre\DAV\SimpleCollection` class allows you to easily build up static
trees in your webdav filesystem.

This is very useful if there is a part in your directory tree that's read-only
and doesn't often change.

Using the SimpleCollection class is very simple, all it takes is a name
argument and a set of childnodes.

Usage
-----


    use
        Sabre\DAV;

    $root = new DAV\SimpleCollection('root',array(
        new DAV\SimpleCollection('users'),
        new DAV\SimpleCollection('files'),
        new DAV\SimpleCollection('home')
    ));

    $server = new DAV\Server($root);

As you can see, the children argument is optional. The children can be any
object implementing `Sabre\DAV\INode`.

Note that since SabreDAV 1.4, you don't have to ever specify a top-level
object, as it is automatically created by SabreDAV, if you pass an array to
the constructor.

Example:

    use
        Sabre\DAV;

    $root = array(
        new DAV\SimpleCollection('users'),
        new DAV\SimpleCollection('files'),
        new DAV\SimpleCollection('home')
    );

    $server = new DAV\Server($root);
