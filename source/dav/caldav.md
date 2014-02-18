---
title: CalDAV
layout: default
type: plugin
plugin_name: caldav
plugin_since: 1.1.0
---

The CalDAV plugin provides all the logic and extensions to WebDAV to get
calendar-access working.

CalDAV depends on the [ACL](/dav/acl) plugin to be available too. This document
provides a simple explanation to get your server setup.

Database setup
--------------

Example sql files are supplied for postgres, sqlite and mysql. The latter two
are officially supported and unittested.

This example assumes you're using sqlite.

Create a 'data' directory where you're going to store the sqlite database.

    mkdir data/
    cat examples/sql/sqlite.* | sqlite3 data/db.sqlite

We'll add a calendar for the admin user.

    INSERT INTO calendars (principaluri, displayname, uri, description, components, ctag, transparent) VALUES
    ('principals/admin','default calendar','default','','VEVENT,VTODO','1', '0');

Now, make sure the data/db.sqlite as well as it's containing directory are
writable by the server. If you are lazy you could just do:

    chmod -Rv a+rw data/

Create the server endpoint
--------------------------

Simply run the following:

    cp examples/calendarserver.php calendarserver.php

Test in browser
---------------

Try opening the full url to your new server. Make sure you append a slash at
the end of the url, without this the request will fail. Example:

    http://www.example.org/~evert/sabredav/calendarserver.php/

This url should prompt you with an authentication dialog. The default username
and password are admin and admin.

Now you can use the url:

    http://www.example.org/~evert/sabredav/calendarserver.php/

for [iCal](/dav/clients/ical) and [iOS](/dav/clients/ios) (with iOS version
less than 6), or

    http://www.example.org/~evert/sabredav/calendarserver.php/principals/admin

for [iOS](/dav/clients/ios) (with iOS version 6 and up), or

    http://www.example.org/~evert/sabredav/calendarserver.php/calendars/admin/default

for [Lightning](/dav/clients/thunderbird) or [Evolution](/dav/clients/evolution).

Note that the iCal and iPhone clients can auto-detect the principal url, if
SabreDAV runs at the root of the domain.

For more information about the auto-detection system, read the
[Service discovery documentation](/dav/service-discovery).

Adding users
------------

SabreDAV does not provide an administrative interface. While this may happen
in the future, for now SabreDAV is mostly intended for developers. Adding new
users is done directly on the database.

In order to allow a user to log in, add them to the users table. You must also
add them to the principals table to enable calendar access.

Lastly, in order to enable support for calendar-delegation, the
calendar-proxy-read and calendar-proxy-write principals must be added. Look at
the sample .sql files for examples for these records.

Related topics
--------------

* [Guide for integrating CalDAV & CardDAV in existing infrastructures](/dav/caldav-carddav-integration-guide).
