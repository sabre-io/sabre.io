---
title: CardDAV
layout: default
type: plugin
plugin_name: carddav
plugin_since: 1.5.0
---

Since version 1.5, SabreDAV ships with a CardDAV plugin. CardDAV allows for
addressbook-syncing functionality in SabreDAV.

Database setup
--------------

Example sql files are supplied for postgres, sqlite and mysql. The latter two
are officially supported and unittested.

This example assumes you're using sqlite.

Create a 'data' directory where you're going to store the sqlite database.

    mkdir data/
    cat examples/sql/sqlite.* | sqlite3 data/db.sqlite

We'll add 1 addressbook for the admin user.

    INSERT INTO addressbooks (principaluri, displayname, uri, description, ctag) VALUES
    ('principals/admin','default calendar','default','','1');

Now, make sure the data/db.sqlite as well as it's containing directory are writable by the server. If you are lazy you could just do:

    chmod -Rv a+rw data/

Create the server endpoint
--------------------------

Simply run the following:

    cp examples/addressbookserver.php addressbookserver.php

Test in browser
---------------

Try opening the full url to your new server. Make sure you append a slash at the end of the url, without this the request will fail. Example:

    http://www.example.org/~every/sabredav/addressbookserver.php/

This url should prompt you with an authentication dialog. The default username and password are admin and admin.

Adding users
------------

SabreDAV does not provide an administrative interface. While this may happen
in the future, for now SabreDAV is mostly intended for developers. Adding new
users is done directly on the database.

In order to allow a user to log in, add them to the users table. You must also
add them to the principals table to enable addressbook access.

Related topics
--------------

* [Guide for integrating CalDAV & CardDAV in existing infrastructures](/dav/caldav-carddav-integration-guide).
