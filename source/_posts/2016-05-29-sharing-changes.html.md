---
title: Changes to sharing in sabre/dav 3.2
product: dav
sidebar: none
date: "2016-05-29T19:32:29-04:00"
tags:
    - dav
    - carddav
    - caldav
    - sharing
---

We are currently working on sabre/dav 3.2. [A first beta has been released][1].
This release includes major changes to the sharing system.

If you are a user of sabre/dav and have never done any deep modifications to
the sharing system, this simply means that from that version onward, there's
a new calendar sharing feature.

To take advantage of that feature, you can just upgrade and then turn on the
sharing plugin:

    $server->addPlugin(new Sabre\DAV\Sharing\Plugin());

And to allow Apple clients and BusyCal to modify the list of who can access
your calendar, add the following second plugin:

    $server->addPlugin(new Sabre\CalDAV\SharingPlugin());

Now if you're completely new to this, you can stop reading this article right
here. However, if you did stuff with sharing before, read on.


The old situation
-----------------

Preliminary support for sharing to sabre/dav was added in version 1.7, which
was released back in 2012. However, this release only ever shipped with the
interfaces to allow an implementor to write a custom backend for this.

There were only a few people that have actually done that. This guide is for
those people.

The specification we used back then were 2 apple proprietary specifications:

1. [caldav-sharing][1].
2. [caldav-notifications][2].

The internal sabre/dav API's match the terminology from those specifications.
The API's allowed someone to write an implementation that allows a user to
invite another user to their calendar. The others get the invitation and can
accept or decline the invite.


New standardization effort
--------------------------

In 2014 the sabre/dav project and a couple of other vendors started on a new
effort, with the following primary goals:

1. Standardize the proprietary spec.
2. Extend the specification to also allow CardDAV (addressbook) sharing to be
   implemented.

To do this, we've split the standard into 4 separate specifications:

1. [draft-pot-webdav-notifications][3].
2. [draft-pot-webdav-resource-sharing][4].
3. [draft-pot-caldav-sharing][5].
4. And a future carddav sharing spec.

So in this process we're not only creating a separate CardDAV and CalDAV spec,
but also adding a generic 'WebDAV sharing' spec that can be used by
WebDAV file sharing systems, such as Owncloud.

On a high level the data-model is similar, but almost everywhere new XML
documents have been defined that are more descriptive, more generic or just
better for aestetic reasons.


The state of sharing in sabre/dav 3.2
--------------------------------------

The first place where the new specifications will be integrated, is CalDAV.
So 3.2 is also the first place where we actually ship a working implementation.

However, to do this properly, some big changes were made:

1. The internal API is 100% rewritten. All the properties and classes use
   terminology matching the _new_ specs and not the old specs.
2. A lot of the code has been moved from the `Sabre\CalDAV` to the
   `Sabre\DAV\Sharing` namespace.

But, another thing is really important. The new sharing specification allows
two workflows for sharing:

1. Sharing with a notification system. In this approach you can invite someone
   to a share, and that person then gets an opportunity to accept, decline or
   ignore the invite.
2. Instant sharing. In this workflow you invite someone, and then that person
   immediately has access to the share.

The old spec only has support for the first model, and this is true as well
for the sabre/dav implementation.

However, in sabre/dav 3.2 we initially only support model #2. So if you
require the notifation system, you can't yet do an upgrade.

We think model #1 is probably more appropriate for public consumer systems,
and #2 works better for systems supporting small teams.


Getting support for the old specifications
------------------------------------------

One drawback of using the new specs, is that old clients don't yet understand
them. So we've added a plugin to handle this.

If you add the `Sabre\CalDAV\SharingPlugin` plugin, this plugin supports the
old apple spec and automatically maps all incoming request to the new model.

This plugin can therefore only work if `Sabre\DAV\Sharing\Plugin` is _also_
up and running.

The old and the new classes
---------------------------

This table gives you an idea of the old classes and interfaces, and which
classes and interfaces you now need to look at for similar functionality.

### `Sabre\CalDAV\SharingPlugin`

This class split in two:

* `Sabre\DAV\Sharing\Plugin`
* `Sabre\CalDAV\SharingPlugin`

### `Sabre\CalDAV\ISharableCalendar` and `Sabre\CalDAV\ISharedCalendar

The old sabre/dav had two node types for shared calendars, one for the
original and one for the shared instances.

The new sabre/dav combines this into a single `Sabre\DAV\Sharing\ISharedNode`.
Which is used for 'all instances'.

However, there is still `Sabre\CalDAV\ISharedCalendar` which extends both
`Sabre\DAV\Sharing\ISharedNode` and `Sabre\CalDAV\ICalendar`.

### `Sabre\CalDAV\SharedCalendar` and `Sabre\CalDAV\ShareableCalendar`

Like the interfaces, the concrete classes also had two distinct nodes. In
the new system, there is just `Sabre\CalDAV\SharedCalendar`.

### `Sabre\CalDAV\Notifications`

This entire namespace must not be used in sabre/dav 3.2. It doesn't work and
it will go away.

### `Sabre\CalDAV\Backend\SharingSupport`

This interface still exists and still has the same goal, but it went through
a number of structual changes. It also no longer _requires_
`Sabre\CalDAV\Backend\NotificationSupport` as well.


The future
----------

The plan is to implement the notifications engine again, but take a different
approach than we originally did in old sabre/dav versions. The new system
should be better separated from CalDAV and support notifications for different
subsystems (CardDAV, CalDAV, etc).

We will also add support for CardDAV (addressbook) sharing soon.

Hopefully these releases will all be rolled out in 3.3 and 3.4 releases.

My advice for people that _require_ the notification subsystem for now is to
stick to 3.1 until we have a complete replacement. Some shifts will likely
happen until we land on a design we're actually happy with.

[1]: http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-sharing.txt
[2]: http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-notifications.txt
[3]: https://tools.ietf.org/html/draft-pot-webdav-notifications
[4]: https://tools.ietf.org/html/draft-pot-webdav-resource-sharing
[5]: https://tools.ietf.org/html/draft-pot-caldav-sharing-00
