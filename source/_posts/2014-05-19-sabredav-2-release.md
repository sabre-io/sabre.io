---
title: sabre/dav 2.0 released
product: dav
sidebar: none
date: "2014-05-16T00:22:44+00:00"
tags:
    - dav
    - release
---

We just released sabre/dav 2.0. The last major release (1.8) was in [2012][1],
so it's been a long time coming.

New features
------------

### WebDAV-Sync

Support for WebDAV-Sync ([rfc6578][2]) has been added. WebDAV-Sync is used by
an increasing number of popular Cal- and CardDAV clients. It allows clients to
request a list of changes that happened in calendar and/or addressbooks. This
can greatly reduce memory, bandwidth and cpu usage on both client and server,
and is well worth it.

It's available as a plugin and the appropriate interfaces have been added to
add support for WebDAV-Sync to the collections where you want to support it.

Furthermore, both the default Cal- and CardDAV PDO backends have out of the
box support.


### New packages

This is the first sabredav release that ships with [sabre/vobject][3] 3.0, and
is also the first release that has part of it's functionality split out into
two new packages: [sabre/event][4] and [sabre/http][5].


### Calendar subscription syncing

There's a proprietary protocol that allows calendar clients to sync
subscriptions with a server. Support for this has been added to the CalDAV
plugin, and is also available in the default PDO backend.

This protocol is at least supported by [BusyCal][6] and Apple's iOS and OS X
clients.


### jCal support

[jCal][7] is an upcoming standard for representing iCalendar objects in json.
sabre/dav now live converts back and forward between iCalendar and jCal, and
can return jCal everywhere it returns iCalendar.

We highly recommend using jCal over iCalendar. It's a much better format,
easier to parse, and likely to use less memory and cpu while parsing.


### New property system

A big part of DAV protocols is related to storing and retrieving properties
on resources such as files and calendars.

The property system got a complete overhaul for this release. This allowed
for a great reduction in property-related code and allows for a new feature:
[storage of arbitrary properties][8].

### New browser

The browser got a big overhaul. It hadn't changed much since when it was
introduced in 2009, so a visual refresh was long due.

The new browser plugin shows you a lot more information about webdav
properties as well, making it a more useful debugging tool.

### PHP 5.4

The minimum php version of sabre/dav has been increased to PHP 5.4. This was
needed for a number of reasons, such as better closure support and traits.


Upgrading
---------

A lot of things have changed in this release. If you are running a standard
server, it's likely that you only have to run the database upgrade script,
but if you did any sort of customizations, chances are that you need to make
changes in your code to keep stuff running.

**Make a backup.** and then head to the [migration instructions][9] for 2.0.

Support status
--------------

As of right now version **1.7** is no longer supported. **1.8** will be
supported for an entire year, until May 2015.


[1]: http://evertpot.com/sabredav-18-released-with-namespaces/
[2]: http://tools.ietf.org/html/rfc6578
[3]: /vobject
[4]: /event
[5]: /http
[6]: http://www.busymac.com/busycal/
[7]: http://tools.ietf.org/html/draft-ietf-jcardcal-jcal-10
[8]: /dav/properties
[9]: /dav/upgrade/1.8-to-2.0/
