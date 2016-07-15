---
title: WebDAV Sharing
layout: default
type: plugin
plugin_name: sharing
plugin_since: 3.2.0 
---

Since version 3.2, sabre/dav has support for a WebDAV sharing feature. This
feature allows a client to share a file, folder, calendar or address book
to another user on the same system.

sabre/dav also supplies a sample implementation for this in the CalDAV plugin.
For more information on how to enable the plugin in CalDAV, read the
[caldav-sharing][1] documentation instead.

The specifications that sabre/dav supports are the following:

* [draft-pot-webdav-resource-sharing-04][2].
* [draft-pot-caldav-sharing-00][3].
* [calendarserver-caldav-sharing][4] (the old spec).

In the future we also hope to add support for:

* [draft-pot-webdav-notifications][5].
* [calendarserver-webdav-notifications][6] (the old spec for notifications).
* [draft-pot-carddav-sharing][7].


Adding support for WebDAV sharing to your custom filesystem
-----------------------------------------------------------

The biggest thing you will need to do, is add support for
`Sabre\DAV\Sharing\ISharedNode` to your custom filesystem nodes. This interface
supplies information about who has access to a node, and also provides a
function that will be called when the list of shares is updated.

It is up to *you* as an implementor to make sure that when `updateInvites()` is
called, something actually happes in your filesystem that causes a second
user to see the share.

I would also highly recommend reading the actual [sharing specification][2] to
get a better idea of the data-model and concept behind WebDAV sharing.

Also, make sure that you add `Sabre\DAV\Sharing\Plugin` to your server to
enable the sharing `POST` requests and WebDAV properties.

[1]: /dav/caldav-sharing/
[2]: https://tools.ietf.org/html/draft-pot-webdav-resource-sharing-04
[3]: https://tools.ietf.org/html/draft-pot-caldav-sharing-00
[4]: http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-sharing.txt
[5]: https://tools.ietf.org/html/draft-pot-webdav-notifications
[6]: http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-notifications.txt
[7]: https://tools.ietf.org/html/draft-pot-carddav-sharing
