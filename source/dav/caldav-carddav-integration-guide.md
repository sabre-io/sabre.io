---
title: CalDAV and CardDAV integration guide
layout: default
---

If you are looking at SabreDAV to add CalDAV or CarDAV functionality to your
existing application, you'll need to roll your own Backend classes. This guide
explains how and where to do this.


A simple CalDAV server
----------------------

The following example illustrates how you can setup a CalDAV server. This is
also how you'd want to build up your own server.

    <?php

    use
        Sabre\DAV,
        Sabre\CalDAV,
        Sabre\DAVACL;

    $pdo = new \PDO('sqlite:data/db.sqlite');
    $pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);

    //Mapping PHP errors to exceptions
    function exception_error_handler($errno, $errstr, $errfile, $errline ) {
        throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
    }
    set_error_handler("exception_error_handler");

    // Files we need
    require_once 'vendor/autoload.php';

    // Backends
    $authBackend = new DAV\Auth\Backend\PDO($pdo);
    $principalBackend = new DAVACL\PrincipalBackend\PDO($pdo);
    $calendarBackend = new CalDAV\Backend\PDO($pdo);

    // Directory tree
    $tree = array(
        new DAVACL\PrincipalCollection($principalBackend),
        new CalDAV\CalendarRoot($principalBackend, $calendarBackend)
    );	


    // The object tree needs in turn to be passed to the server class
    $server = new DAV\Server($tree);

    // You are highly encouraged to set your WebDAV server base url. Without it,
    // SabreDAV will guess, but the guess is not always correct. Putting the
    // server on the root of the domain will improve compatibility.
    $server->setBaseUri('/');

    // Authentication plugin
    $authPlugin = new DAV\Auth\Plugin($authBackend,'SabreDAV');
    $server->addPlugin($authPlugin);

    // CalDAV plugin
    $caldavPlugin = new CalDAV\Plugin();
    $server->addPlugin($caldavPlugin);

    // ACL plugin
    $aclPlugin = new DAVACL\Plugin();
    $server->addPlugin($aclPlugin);

    // Support for html frontend
    $browser = new DAV\Browser\Plugin();
    $server->addPlugin($browser);

    // And off we go!
    $server->exec();


To setup the sqlite database (or mysql, if you prefer), follow the
instructions on the [CalDAV](/dav/caldav) page.

Setting up a CardDAV server is extremely similar. For examples you can also
head over to the [CardDAV](/dav/carddav) page or check the examples/ directory
in the standard SabreDAV distribution.


Backends
--------

If you want to integrate CalDAV into your existing infrastructure, you can do
so by creating your own Authentication, Principal and Calendar backends.
Depending on your needs you may want to replace all of them, or just the ones
that make sense for your application.

Your Authentication class needs to implement the `Sabre\DAV\Auth\Backend\BackendInterface`
interface. If you want to use basic or digest authentication (the only widely
supported authentication methods) you can also extend
`Sabre\DAV\Auth\Backend\AbstractDigest` or `Sabre\DAV\Auth\Backend\AbstractBasic`.
`Sabre\DAV\Auth\Backend\PDO` is a decent example for digest authentication.

Your Calendar backend needs to extend `Sabre\CalDAV\Backend\AbstractBackend`. Take a
look at `Sabre\CalDAV\Backend\PDO` for an example.

Lastly, the principal backend must implement `Sabre\DAVACL\PrincipalBackend\BackendInterface`.
Principals are in the context of WebDAV either users or groups (or both).

For CardDAV, you may also want to extend `Sabre\CardDAV\Backend\AbstractBackend`,
check `Sabre\CardDAV\Backend\PDO` for an example.


Datamodel in a nutshell
-----------------------

Users are called 'principals' in WebDAV terminology. Principals are associated
to a url. If your username is homer, the url could be /principals/homer or
/principals/homer@example.org

CalDAV and CardDAV clients may use this url to gather more information about
the user. You must return this url from the Auth backend, and it will be used
in the Calendar backend to return all the calendars from a specific user.

Calendars are stored under for example:

    /calendars/homer@example.org/

A user has multiple calendars. An example of a calendar could for example be:

    /calendars/homer@example.org/work

Calendar objects (events, todo's, journals) are stored as resources under this
url:

    /calendars/homer@example.org/work/meeting.ics

Similarly, by default addressbooks will be stored under

    /addressbooks/homer@example.org

Specific addressbooks under there:

    /addressbooks/homer@example.org/book1

and vcards under there:

    /addressbooks/homer@example.org/book1/marge.vcf

UIDS, id's and urls
-------------------

There's a bunch of id's you will need to keep track off.

When CalDAV clients create new calendar objects, they will store them using a url.
This url can look like for example `/calendars/user@example.org/1b520550-d7ca-11df-937b-0800200c9a66/22bad740-d7ca-11df-937b-0800200c9a66.ics`.

The last part of this url is the calendar object. You must make sure that when a
CalDAV client stores a new object under a url, the client must be able to access
the object using that url.

This could mean you need to make a new database field for this url. Even though
most clients use the `[uuid].ics` format, you can't rely on the url to be an
uuid. Any string could be sent, and upper/lowercase can vary. Therefore it's
not a true uuid field.

The `Sabre\CalDAV\Backend\AbstractBackend` class also uses a generic 'id'
field. This id is never sent to the client. It can hold any content, but it's
specifically added to allow you to store for example a database id.


Calendar objects
----------------

Calendar objects are 'iCalendar' formatted files. They can hold events, todo's
or journals (although the latter is extremely uncommon).
Generally they only hold one event each, but in the case of a recurring event
with exceptions, they can hold multiple.

Now, there's a good chance you want to map Calendar objects to an existing
datamodel. If you do have to do this, you can do this with the
[VObject library][1], which is included with SabreDAV.

The VObject library provides a parser and interface to iCalendar objects very
similar to what simplexml does for xml.

Although it must be said that the iCalendar standard can be difficult,
especially when dealing with timezone and recurrence. If you need to parse
out data from the events and todo's to store them in separate fields, I would
still recommend keeping the actual full object around in a BLOB. This will
ensure that you can easily parse out the data you need, while ensuring all
the users' data is kept intact.

VCards
------

VCards' structure are very similarly structured as iCalendars. You can also
use the VObject library to work with them.

You still need a basic understanding how vcards are structured. The VObject
library just helps with parsing, traversing and manipulating them.

[1]: https://github.com/fruux/sabre-vobject "sabre-vobject" 
