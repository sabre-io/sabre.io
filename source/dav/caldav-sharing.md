---
title: CalDAV Sharing
layout: default
type: plugin
plugin_name: caldav-sharing
plugin_since: 1.7.0
versions:
    "1.7-3.1": /dav/3.1/caldav-sharing/
    "3.2": /dav/sharing/
thisversion: 3.2
---

Since version 1.7 SabreDAV comes with experimental support for CalDAV-sharing.
CalDAV sharing got a major overhaul in version 3.2, supporting updated
standards and it now also comes with a default implementation in the CalDAV
PDO backend.

To enable CalDAV sharing, make sure you have the following plugin enabled:

    $server->addPlugin(new Sabre\DAV\Sharing\Plugin());

If you want to allow clients such as OS X and BusyCal to be able to manipulate
who has access to a share, you must add another plugin, which is responsible
for a compatibility layer until these clients are up-to-date with the specs:

    $server->addPlugin(new Sabre\CalDAV\SharingPlugin());

Please note that you need both!

If you are writing you own CalDAV Backend, you can implement CalDAV sharing
by making sure your CalDAV Backend class implements the following interface:

    Sabre\CalDAV\Backend\SharingSupport

More information about implementing this interface can be found in the
[sabre/dav source][1].

The following specifications are supported:

* [draft-pot-webdav-resource-sharing-03][2].
* [draft-pot-caldav-sharing-00][3].
* [calendarserver-caldav-sharing][4].

[1]: https://github.com/sabre-io/dav/blob/master/lib/CalDAV/Backend/SharingSupport.php
[2]: https://tools.ietf.org/html/draft-pot-webdav-resource-sharing-03
[3]: https://tools.ietf.org/html/draft-pot-caldav-sharing-00
[4]: http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-sharing.txt
