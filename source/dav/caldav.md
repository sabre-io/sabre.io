---
title: CalDAV
layout: default
type: plugin
plugin_name: caldav
plugin_since: 1.1.0
versions:
    "1.8": /dav/1.8/caldav/
    "2.x": /dav/caldav/
thisversion: 2.x
---

The CalDAV plugin provides all the logic and extensions to turn
sabre/dav into a modern CalDAV server.

This document is a quick guide to help you set-up a simple caldav server.


Database setup
--------------

By default, the sabre/dav system requires either MySQL or SQLite.

### Sqlite

Assuming you are in your main project directory, we're going to create a `data`
directory that holds the sqlite data.

    mkdir data/
    cat examples/sql/sqlite.* | sqlite3 data/db.sqlite

After that, we have to make sure that the webserver has read privilege to the
server. A quick and dirty way to do this, is to simply run:

    chmod -Rv a+rw data/


### MySQL

MySQL is pretty simple as well. Make sure you have a mysql database called
`sabredav`.

After that, you can just create the tables by running:

    cat examples/sql/mysql.* | mysql -u root -p sabredav -h 127.0.0.1

Adjust the hostname and username to your setup. If you are used to using a
GUI tool to manage mysql, you can just use all the files from the
`examples/sql/` directory to get up and running.


Creating the server endpoint
----------------------------

After the database has been set-up, create the CalDAV server by simply copying
the example file to your main project directory:

    cp examples/calendarserver.php calendarserver.php

> Also want CardDAV support?
>
> Instead of using the `calendarserver.php`, just use `groupwareserver.php`.
> This server has a lot more default features, CardDAV being one of them.

### Change the database settings

If you used SQLite and you used the _exact path_ as desrcribed in the earlier
example, there's nothing else you need to do. If you used mysql or changed the
path to your database, read on.

Open up your new `calendarserver.php` and find the line that says:

    $pdo = new PDO('sqlite:data/db.sqlite');

This tells the server to use sqlite, and where to find the database file. If
you used MySQL, change this to something like this:

    $pdo = new PDO('mysql:dbname=sabredav;host=127.0.0.1', 'root', 'password');



Test in browser
---------------

Try opening the full url to your new server. Make sure you append a slash at
the end of the url, without this the request will fail. Example:

    http://www.example.org/~evert/sabredav/calendarserver.php/

This url should prompt you with an authentication dialog. The default username
and password are `admin` and `admin`.

**Note again:** The slash at the end of the url is **required** and you will
get an error without it.


Create a calendar
-----------------

Browse to `calendars/admin`. On this url you will get an option to create a
new calendar. You should create one calendar to make things work out of the
box for every client. Use `default` for the name, so the following examples
are all correct. The 'display name' can be anything you'd like.

If you also set-up carddav earlier, now is a good time to also create a first
address book.

Setting up clients
------------------

Clients typically need three pieces of information to setup CalDAV accounts:

1. A username
2. A password
3. A url

Which url that is, unfortunately depends on the client. If you followed the
instructions to the letter, there are potentially three relevant urls:


1. The base url, which is something like `http://example.org/caldav/calendarserver.php/`.
2. The principal url, which is something like `http://example.org/caldav/calendarserver.php/principals/admin/`.
3. The calendar url, which is something like `http://example.org/caldav/calendarserver.php/calendars/admin/default/`.

iOS, iCal, BusyCal, and many others typically require #2, and sometimes #1.
Thunderbird (with Lightning) requires a single calendar url, the `default`
calendar we just created, and #3.

Note that this is quite a long-winded and ugly url for people to set-up. If you
are fully in control over the domain, you can set-up your server so that most
clients only need the 'host' part to fully configure themselves. Read
[Service discovery documentation](/dav/service-discovery) for more information
about this. It is recommended to only do this after you are fully set-up though.

Adding users
------------

SabreDAV does not provide an administrative interface to add users. While this
may happen in the future, for now SabreDAV is mostly intended for developers.
Adding new users is done directly on the database.

In order to allow a user to log in, add them to the users table. You must also
add them to the principals table to enable calendar access.

Lastly, in order to enable support for calendar-delegation, the
calendar-proxy-read and calendar-proxy-write principals must be added. Look at
the sample .sql files for examples for these records.

Generally you should also always create the first calendar for a user to make
things work as expected.

Related topics
--------------

* [Guide for integrating CalDAV & CardDAV in existing infrastructures](/dav/caldav-carddav-integration-guide).
