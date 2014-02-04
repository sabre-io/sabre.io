---
layout: default
---

CardDAV directory
=================

CardDAV Directory is a non-standard extension to the CardDAV protocol,
implemented by iOS devices and OS/X Addressbook.

The directory acts as a global read-only addressbook. Both clients don't
actually allow you to simply browse them, and will always present just a
searching interface.

The user experience is very similar to browsing an LDAP directory.

What's provided
---------------

SabreDAV does not provide default backends to create your directories,
it provides just a simple interface which you must implement to make this work.

The interface `Sabre\CardDAV\IDirectory` flags the CardDAV plugin to mark an
addressbook as a directory.

Furthermore, you must also specify the paths to all global CardDAV directories
in the `Sabre\CardDAV\Plugin::$directories` property.

This last step is required, because iOS will request locations to CardDAV 
directories on the principal, so it must be globally known where these are.

To make sure the directory works everywhere, your node implementing
`Sabre\CardDAV\IDirectory` must also implement `Sabre\DAVACL\IACL`.

Client info
-----------

### OS/X 10.6 Addressbook

The OS/X 10.6 client will not request the list of directories, but it rather
assumes that there's one located at the /directory path on the root of the
server.

So if you want to support this client as well, ensure that that's the exact
location of the global addressbook. Because of this, this client will also not
be able to support more than 1 directory.

### OS/X 10.7 and 10.8

These clients do pick up on the directories property, but they will only
support 1 directory at most still.

### iOS 4, 5 and 6. 

The CardDAV spec dictates that clients should not do things like a
`Depth: 1` PROPFIND on the directory. iOS 4 & 5 do this though. When this
happens, simply don't return anything (empty array from `getChildren()`) rather
than throwing an error.

Throwing an error will break iOS 4 and 5, but this does appear to be fixed
in iOS6.
