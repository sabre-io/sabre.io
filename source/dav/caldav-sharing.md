---
title: CalDAV Sharing
layout: default
type: plugin
plugin_name: caldav-sharing
plugin_since: 1.7.0
---

Since version 1.7 SabreDAV comes with experimental support for CalDAV-sharing.

**Early warning:** Currently SabreDAV provides no implementation for this. This
is, because in it's current state there is no elegant way to do this.
The problem lies in the fact that a real CalDAV server with sharing support
would first need email support (with invite notifications), and really also
a browser-frontend that allows people to accept or reject these shares.

In addition, the CalDAV backends are currently kept as independent as
possible, and should not be aware of principals, email addresses or
accounts.

Adding an implementation for Sharing to standard-sabredav would contradict
these goals, so for this reason this is currently not implemented, although
it may very well in the future; but probably not before SabreDAV 2.0.

The interface works however, so if you implement all this, and do it
correctly sharing _will_ work. It's not particularly easy, and I _urge you_
to make yourself acquainted with the following documents first:

* <https://trac.calendarserver.org/browser/CalendarServer/trunk/doc/Extensions/caldav-sharing.txt>
* <https://trac.calendarserver.org/browser/CalendarServer/trunk/doc/Extensions/caldav-notifications.txt>

An overview
-----------

Implementing this interface will allow a user to share his or her calendars
to other users. Effectively, when a calendar is shared the calendar will
show up in both the Sharer's and Sharee's calendar-home root.

Inviting people is not instant. There should be a notification system
that clients use to either accept or reject this.

A lot of the documentation can be found in the actual interfaces:
`Sabre\CalDAV\Backend\SharingSupport` and `Sabre\CalDAV\Backend\NotificationSupport`.
