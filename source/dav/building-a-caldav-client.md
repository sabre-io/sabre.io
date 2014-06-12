---
title: Building a CalDAV client
layout: default
---

This document is a general howto on how to build a CalDAV client.
The document is language-agnostic, and considering the massive scope of CalDAV,
not complete.

General synchronization concerns
--------------------------------

The primary formats for tranfering information is [iCalendar][rfc5545] for
calendar objects (events and tasks) and xml for most other data.

[CalDAV][rfc4791] is based on [WebDAV][rfc4918], which itself is an extension
to HTTP.

Some operations will be very familiar if you already have experience with HTTP
services (`GET`, `PUT` and `DELETE`), but many are added too (`PROPFIND`,
`PROPPATCH`, `REPORT`, `MKCOL`, `MKCALENDAR`, `ACL`).

Most HTTP clients should just support methods they don't know about, so it's
wise to simply use a stock HTTP client (or better yet, a DAV or CalDAV client).

One thing in which CalDAV differs from some other synchronization models, is
that the 'truth' is always on the server. There should in general never really
be a situation where there are conflicts, as the server is always correct.

One implication is that ideally the user should not be bothered by a
'Synchronize Now!' interface element. In an ideal world changes are submitted
to the server the very instant that the user has made them.

Every single event and task is encoded as an iCalendar object. I strongly
recommend _always_ retaining the iCalendar the server sent to you.

Clients may add non-standard properties to iCalendar objects. It is important
that when you GET and later on PUT an updated iCalendar object, any non-standard
properties you may not have built-in support for gets retained.


Syncing a calendar
------------------

Simple clients tend to just access CalDAV servers based on the follow 3 setting:

* username
* password
* calendar url

An example of this is [Thunderbird Lightning](/dav/clients/thunderbird). So
this is where we start.


### Retrieving calendar information

This is the recommended way to do an initial sync with SabreDAV. Every calendar
has a so-called `ctag`. This ctag works like a change id. Every time the ctag
has changed, you know something in the calendar has changed too.

An example request to get the ctag:

    PROPFIND /calendars/johndoe/home/ HTTP/1.1
    Depth: 0
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
      <d:prop>
         <d:displayname />
         <cs:getctag />
      </d:prop>
    </d:propfind>


The `PROPFIND` request is a HTTP request, defined by [WebDAV][rfc4918].
`PROPFIND` allos the client to fetch properties from a url.

CalDAV uses many properties like this, but in this case we just fetch the
'displayname', which is the human-readable name the user gave the calendar, and
the ctag. The ctag must be stored for subsequent requests.

The request will return something like:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/calendars/johndoe/home/</d:href>
            <d:propstat>
                <d:prop>
                    <d:displayname>Home calendar</d:displayname>
                    <cs:getctag>3145</cs:getctag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

This multistatus response is very common for Cal and WebDAV. Many requests
return an xml document in this exact format, so it is worthwhile writing a
standard parser.

The response gives us back the user, the values for the 2 properties and the
status.

If the user did not have access to these properties, it's also possible that you
get a response like this back:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/calendars/johndoe/home/</d:href>
            <d:propstat>
                <d:prop>
                    <d:displayname />
                    <cs:getctag />
                </d:prop>
                <d:status>HTTP/1.1 403 Forbidden</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

So it is important that when you parse the response, you make sure that the
status for the properties was actually 200 OK.

### Downloading objects

Now we download every single object in this calendar. To do this, we use a
`REPORT` method.

    REPORT /calendars/johndoe/home/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <c:calendar-query xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:prop>
            <d:getetag />
            <c:calendar-data />
        </d:prop>
        <c:filter>
            <c:comp-filter name="VCALENDAR" />
        </c:filter>
    </c:calendar-query>

This request will give us every object that's a VCALENDAR object, and its etag.

If you're only interested in VTODO (because you're writing a todo app) you can
also filter for just those:

    REPORT /calendars/johndoe/home/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <c:calendar-query xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:prop>
            <d:getetag />
            <c:calendar-data />
        </d:prop>
        <c:filter>
            <c:comp-filter name="VCALENDAR">
                <c:comp-filter name="VTODO" />
            </c:comp-filter>
        </c:filter>
    </c:calendar-query>

Similarly it's also possible to filter to just events, or only get events within
a specific time-range.

This report will return a multi-status object again:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/calendars/johndoe/home/132456762153245.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"2134-314"</d:getetag>
                    <c:calendar-data>BEGIN:VCALENDAR
                        VERSION:2.0
                        CALSCALE:GREGORIAN
                        BEGIN:VTODO
                        UID:132456762153245
                        SUMMARY:Do the dishes
                        DUE:20121028T115600Z
                        END:VTODO
                        END:VCALENDAR
                    </c:calendar-data>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/home/132456-34365.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"5467-323"</d:getetag>
                    <c:calendar-data>BEGIN:VCALENDAR
                        VERSION:2.0
                        CALSCALE:GREGORIAN
                        BEGIN:VEVENT
                        UID:132456-34365
                        SUMMARY:Weekly meeting
                        DTSTART:20120101T120000
                        DURATION:PT1H
                        RRULE:FREQ=WEEKLY
                        END:VEVENT
                        END:VCALENDAR
                    </c:calendar-data>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

This calendar only contained 2 objects. A todo and a weekly event.

So after you retrieved and processed these, for each object you must retain:

* The calendar data itself
* The url
* The etag

In this case all urls ended with .ics. This is often the case, buy you must not
rely on this. In this case the UID in the calendar object was also identical to
a part of the url. This too is often the case, but again not something you can
rely on, so don't make any assumptions.

The url and the UID have no meaningful relationship, so treat both those items
as separate unique identifiers.

### Finding out if anything changed

To see if anything in a calendar changed, we simply request the ctag again on
the calendar. If the ctag did not change, you still have the latest copy.

If it did change, you must request all the etags in the entire calendar again:

    REPORT /calendars/johndoe/home/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <c:calendar-query xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:prop>
            <d:getetag />
        </d:prop>
        <c:filter>
            <c:comp-filter name="VCALENDAR">
                <c:comp-filter name="VTODO" />
            </c:comp-filter>
        </c:filter>
    </c:calendar-query>

Note that this last request is extremely similar to a previous one, but we are
only asking fo the etag, not the calendar-data.

The reason for this, is that calendars can be rather huge. It will save a TON of
bandwidth to only check the etag first.

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/calendars/johndoe/home/132456762153245.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"2134-314"</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/home/fancy-caldav-client-1234253678.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"5-12"</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

Judging from this last request, 3 things have changed:

* The etag for the task has changed, so the contents must be different
* There's a new url, some other client must have added an object
* One object is missing, something must have deleted it.

So based on those 3 items we know that we need to delete an object from our
local list, and fetch the contents for the new item, and the updated one.

To fetch the data for these, you can simply issue GET requests:

    GET /calendars/johndoe/home/132456762153245.ics HTTP/1.1

But, because in a worst-case scenario this could result in a LOT of GET requests
we can do a 'multiget'.

    REPORT /calendars/johndoe/home/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <c:calendar-multiget xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:prop>
            <d:getetag />
            <c:calendar-data />
        </d:prop>
        <d:href>/calendars/johndoe/home/132456762153245.ics</d:href>
        <d:href>/calendars/johndoe/home/fancy-caldav-client-1234253678.ics</d:href>
    </c:calendar-multiget>

This request will simply return a multi-status again with the calendar-data and
etag.

### A small note about application design

If you read this far and understood what's been said, you may have realized that
it's a bit cumbersome to have a separate step for the initial sync, and
subsequent updates.

It would totally be possible to skip the 'initial sync', and just use
calendar-query and calendar-multiget REPORTS for the initial sync as well.


Updating a calendar object
--------------------------

Updating a calendar object is rather simple:

    PUT /calendars/johndoe/home/132456762153245.ics HTTP/1.1
    Content-Type: text/calendar; charset=utf-8
    If-Match: "2134-314"

    BEGIN:VCALENDAR
    ....
    END:VCALENDAR

A response to this will be something like this:

    HTTP/1.1 204 No Content
    ETag: "2134-315"

The update gave us back the new ETag. SabreDAV gives this ETag on updates back
most of the time, but not always.

There are cases where the caldav server must modify the iCalendar object right
after storage. In those cases an ETag will not be returned, and you should issue
a GET request immediately to get the correct object.

A few notes:

* You must not change the UID of the original object
* Every object should hold only 1 event or task.
* You cannot change an VEVENT into a VTODO.

Creating a calendar object
--------------------------

Creating a calendar object is almost identical, except that you don't have a
url yet to a calendar object.

Instead, it is up to you to determine the new url.

    PUT /calendars/johndoe/home/somerandomstring.ics HTTP/1.1
    Content-Type: text/calendar; charset=utf-8

    BEGIN:VCALENDAR
    ....
    END:VCALENDAR

A response to this will be something like this:

    HTTP/1.1 201 Created
    ETag: "21345-324"

Similar to updating, an ETag is often returned, but there are cases where this
is not true.

Deleting a calendar object
--------------------------

Deleting is simple enough:

    DELETE /calendars/johndoe/home/132456762153245.ics HTTP/1.1
    If-Match: "2134-314"


Speeding up Sync with WebDAV-Sync
---------------------------------

WebDAV-Sync is a protocol extension that is defined in [rfc6578][rfc6578].
Because this extension was defined later, some servers may not support this
yet.

SabreDAV supports this since 2.0.

WebDAV-Sync allows a client to ask *just* for calendars that have changed.
The process on a high-level is as follows:

1. Client requests sync-token from server.
2. Server reports token `15`.
3. Some time passes.
4. Client does a Sync REPORT on an calendar, and supplied token `15`.
5. Server returns vcard urls that have changed or have been deleted and returns token `17`.

As you can see, after the initial sync, only items that have been created,
modified or deleted will ever be sent.

This has a lot of advantages. The transmitted xml bodies can generally be a
lot shorter, and is also easier on both client and server in terms of memory
and CPU usage, because only a limited set of items will have to be compared.

It's important to note, that a client should only do Sync operations, if the
server reports that it has support for it. The quickest way to do so, is to
request `{DAV}sync-token` on the calendar you wish to sync.

Technically, a server may support 'sync' on one calendar, and it may not
support it on another, although this is probably rare.


### Getting the first sync-token

Initially, we just request a sync token when asking for calendar information:

    PROPFIND /calendars/johndoe/home/ HTTP/1.1
    Depth: 0
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
      <d:prop>
         <d:displayname />
         <cs:getctag />
         <d:sync-token />
      </d:prop>
    </d:propfind>

This would return something as follows:

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/calendars/johndoe/home/</d:href>
            <d:propstat>
                <d:prop>
                    <d:displayname>My calendar</d:displayname>
                    <cs:getctag>3145</cs:getctag>
                    <d:sync-token>http://sabredav.org/ns/sync-token/3145</d:sync-token>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

As you can see, the sync-token is a url. It always should be a url.
Even though a number appears in the url, you are not allowed to attach any
meaning to that url. Some servers may have use an increasing number,
another server may use a completely random string.

### Receiving changes

After a sync token has been obtained, and the client already has the initial
copy of the calendar, the client is able to request all changes since the
token was issued.

This is done with a `REPORT` request that may look like this:

    REPORT /calendars/johndoe/home/ HTTP/1.1
    Host: dav.example.org
    Content-Type: application/xml; charset="utf-8"

    <?xml version="1.0" encoding="utf-8" ?>
    <d:sync-collection xmlns:d="DAV:">
      <d:sync-token>http://sabredav.org/ns/sync/3145</d:sync-token>
      <d:sync-level>1</d:sync-level>
      <d:prop>
        <d:getetag/>
      </d:prop>
    </d:sync-collection>

This requests all the changes since sync-token identified by
`http://sabredav.org/ns/sync/3145`, and for the calendar objects that have been
added or modified, we're requesting the etag.

The response to a query like this is another multistatus xml body. Example:

    HTTP/1.1 207 Multi-Status
    Content-Type: application/xml; charset="utf-8"

    <?xml version="1.0" encoding="utf-8" ?>
    <d:multistatus xmlns:d="DAV:">
        <d:response>
            <d:href>/calendars/johndoe/home/newevent.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"33441-34321"</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/home/updatedevent.ics</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"33541-34696"</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/home/deletedevent.ics</d:href>
            <d:status>HTTP/1.1 404 Not Found</d:status>
        </d:response>
        <d:sync-token>http://sabredav.org/ns/sync/5001</d:sync-token>
     </d:multistatus>

The last response reported two changes: `newevent.ics` and `updatedevent.ics`.
There's no way to tell from the response wether those cards got created or
updated, you, as a client can only infer this based on the vcards you are
already aware of.

The entry with name `deltedevent.ics` got deleted as indicated by the `404`
status. Note that the status element is here a child of `d:response` when in
all previous examples it has been a child of `d:propstat`.

The other difference with the other multi-status examples, is that this one
has a `sync-token` element with the latest sync-token.

### Caveats

Note that a server is free to 'forget' any sync-tokens that have been
previously issued. In this case it may be needed to do a full-sync again.

In case the supplied sync-token is not recognized by the server, a HTTP error
is emitted. SabreDAV emits a `403`.


Discovery
---------

Ideally you will want to make sure that all the calendars in an account are
automatically discovered. The best user interface would be to just have to
ask for three items:

* Username
* Password
* Server

And the server should be as short as possible. This is possible with most
servers.

If, for example a user specified 'dav.example.org' for the server, the first
thing you should do is attempt to send a PROPFIND request to
`https://dav.example.org/`. Note that you SHOULD try the https url before the
http url.

This PROPFIND request looks as follows:

    PROPFIND / HTTP/1.1
    Depth: 0
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:">
      <d:prop>
         <d:current-user-principal />
      </d:prop>
    </d:propfind>

This will return a response such as the following:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/</d:href>
            <d:propstat>
                <d:prop>
                    <d:current-user-principal>
                        <d:href>/principals/users/johndoe/</d:href>
                    </d:current-user-principal>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

A 'principal' is a user. The url that's being returned, is a url that refers
to the current user. On this url you can request additional information about
the user.

What we need from this url, is their 'calendar home'. The calendar home is a
collection that contains all of the users' calendars.

To request that, issue the following request:

    PROPFIND /principals/users/johndoe/ HTTP/1.1
    Depth: 0
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
      <d:prop>
         <c:calendar-home-set />
      </d:prop>
    </d:propfind>

This will return a response such as the following:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:response>
            <d:href>/</d:href>
            <d:propstat>
                <d:prop>
                    <c:calendar-home-set>
                        <d:href>/calendars/johndoe/</d:href>
                    </c:calendar-home-set>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

Lastly, to list all the calendars for the user, issue a PROPFIND request with
`Depth: 1`.

    PROPFIND /calendars/johndoe/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/" xmlns:c="urn:ietf:params:xml:ns:caldav">
      <d:prop>
         <d:resourcetype />
         <d:displayname />
         <cs:getctag />
         <c:supported-calendar-component-set />
      </d:prop>
    </d:propfind>

In that last request, we asked for 4 properties.

The `resourcetype` tells us what type of object we're getting back. You must
read out the `resourcetype` and ensure that it contains at least a `calendar`
element in the CalDAV namespace. Other items _may_ be returned, including non-
calendar, which your application should ignore.

The displayname is a human-readable string for the calendarname, the ctag was
already covered in an earlier chapter.

Lastly, `supported-calendar-component-set`. This gives us a list of components
that the claendar accepts. This could be just `VTODO`, `VEVENT`, `VJOURNAL` or a
combination of these three.

If you are just creating a todo-list application, this means you should only
list the calendars that support the `VTODO` component.

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/" xmlns:c="urn:ietf:params:xml:ns:caldav">
        <d:response>
            <d:href>/calendars/johndoe/</d:href>
            <d:propstat>
                <d:prop>
                    <d:resourcetype>
                        <d:collection/>
                    </d:resourcetype>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/home/</d:href>
            <d:propstat>
                <d:prop>
                    <d:resourcetype>
                        <d:collection/>
                        <c:calendar/>
                    </d:resourcetype>
                    <d:displayname>Home calendar</d:displayname>
                    <cs:getctag>3145</cs:getctag>
                    <c:supported-calendar-component-set>
                        <c:comp name="VTODO" />
                    </c:supported-component-set>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/calendars/johndoe/tasks/</d:href>
            <d:propstat>
                <d:prop>
                    <d:resourcetype>
                        <d:collection/>
                        <c:calendar/>
                    </d:resourcetype>
                    <d:displayname>My TODO list</d:displayname>
                    <cs:getctag>3345</cs:getctag>
                    <c:supported-calendar-component-set>
                        <c:comp name="VTODO" />
                    </c:supported-component-set>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

### Advanced discovery topics

Read the [Service Discovery documentation](/dav/service-discovery)

[rfc5545]: https://tools.ietf.org/html/rfc5545
[rfc4791]: https://tools.ietf.org/html/rfc4791
[rfc4918]: https://tools.ietf.org/html/rfc4918
[rfc6578]: https://tools.ietf.org/html/rfc6578

