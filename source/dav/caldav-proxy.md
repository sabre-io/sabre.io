---
title: CalDAV delegation
layout: default
type: plugin
plugin_name: caldav-proxy
plugin_since: 1.4.0
---

Since version 1.4 SabreDAV comes with a calendar-proxy support. This feature
allows for calendar delegation.

Calendar delegation allows users to give other people access to their
calendars. This can be done either read-only or read-write.

Only entire accounts can be delegated. It's not possible to do per-calendar
sharing. This functionality is possible as well using [CalDAV sharing](/dav/caldav-sharing).

Client support
--------------

[iCal](/dav/clients/ical), [BusyCal](/dav/clients/busycal) and several other
clients now support this feature.

So for the moment it's required to manually add delegees using the database,
or by directly interfacing with the WebDAV API for this.

Once permissions are granted though, delegated calendars show up in the iCal
preferences interface.

Setting up
----------

To make sure delegation works, every single principal that needs this, will
need to have two sub-principals.

Example for creating a 'John Smith' account:

    INSERT INTO users (username, digesta1) VALUES ('jsmith',MD5('jsmith:SabreDAV:mypassword'));
    INSERT INTO principals (uri, email, displayname) VALUES ('principals/jsmith','jsmith@example.org','John Smith');

    -- Now the special principals
    INSERT INTO principals (uri) VALUES ('principals/jsmith/calendar-proxy-read');
    INSERT INTO principals (uri) VALUES ('principals/jsmith/calendar-proxy-write');

These two sub-principals act as groups.

To allow other users to access John Smiths calendars, they must be added to
either the read, or the write group.

You can do this through the `groupmembers` database table.

Using the correct Principal Collections
---------------------------------------

You must make sure that for the '/principals' collection at the root of your
server, you do not use the following class:

  * `Sabre\DAVACL\PrincipalCollection`

You have to use this instead:

  * `Sabre\CalDAV\Principal\Collection`

The CalDAV-specific collection ensures that the new proxy principals are
correctly created.

Manually giving users access to other accounts
----------------------------------------------

If you want to give user A access to user B's calendars, this means that
`principal/userA` needs to be part of the
`principal/userB/calendar-proxy-write` group.

To do this through the database, you need to look up the id for
`principal/userA` and `principal/userB/calendar-proxy-write`. You add these
id's to the `groupmembers` table.

The id for `principal/userA` will become the `member_id` field value, and the
id for `principal/userB/calendar-proxy-write` should be put in the
`principal_id` field.

== Reference ==

This feature is based on the specification published here:

<http://svn.calendarserver.org/repository/calendarserver/CalendarServer/trunk/doc/Extensions/caldav-proxy.txt>.
