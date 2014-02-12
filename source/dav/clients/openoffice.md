---
type: client
name: OpenOffice 
---

You can easily use urls in the Open Office file dialog. You should make sure
you are using open office dialogs, and not the standard operating system ones.
You can change this in: Tools, Options menu. (or the Preferences menu in OS/X).

Technical details
-----------------

OpenOffice is a very simple client, and doesn't seem to use any locking. In
general it's pretty lightweight, but I did notice if I'm entering a new
filename (when saving) it will try to make sure the file exists for every
character I entered. So if you have a 10-character filename, at least 10
requests will be done while you're typing.

### Authentication

OpenOffice does both Digest and Basic authentication.

### Properties

The following properties are requested for each client:

In the DAV: namespace

* getcontentlength
* getlastmodified
* creationdate
* resourcetype

From the `http://ucb.openoffice.org/dav/props/` namespace:

* TargetUrl
* IsHidden
* IsVolume
* IsRemote
* IsRemovable
* IsFloppy
* IsCompactDisc

The properties are a bit odd, I'm unsure what most of these do.
