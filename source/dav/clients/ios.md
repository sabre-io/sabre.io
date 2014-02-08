---
name: iOS
type: client
---

iOS contains both a CalDAV and a CardDAV client for quite a few versions.
It is one of the best clients out there.

Supported features
------------------

* [CalDAV](/dav/caldav).
* [CardDAV](/dav/carddav).
* [Scheduling](/dav/scheduling).
* [SRV records and well-known urls](/dav/service-discovery).
* [Calendar sharing](/dav/caldav-sharing).
* [CardDAV directory](/dav/carddav-directory).

Not supported:

* [Calendar delegation](/dav/caldav-proxy).


Technical details
-----------------

Very incomplete list of user agent's we've come across:

  DataAccess/1.0 (8J2)
  iOS/6.0 (10A403) dataaccessd/1.0
  DAVKit/4.0 (728.4); iCalendar/1 (42.1); iPhone/3.1.3 7E18

### Properties

The client will ask for the following additional properties on principals when
setting up carddav.

* `{DAV:}principal-collection-set`
* `{DAV:}supported-report-set`
* `{DAV:}resource-id (no idea what this one is)`
* `{DAV:}displayname`
* `{http://calendarserver.org/NS}email-address-set`
* `{urn:ietf:params:xml:ns:carddav}addressbook-home-set`
* `{urn:ietf:params:xml:ns:carddav}directory-gateway`

When setting up caldav:

* `{urn:ietf:params:xml:ns:caldav}calendar-home-set`
* `{urn:ietf:params:xml:ns:caldav}calendar-user-address-set`
* `{urn:ietf:params:xml:ns:caldav}schedule-inbox-URL`
* `{urn:ietf:params:xml:ns:caldav}schedule-outbox-URL`
* `{http://calendarserver.org/ns/}dropbox-home-URL`
* `{DAV:}displayname`

The client will perform the following PROPFIND request on the 
`addressbook-home-set`:

    <?xml version="1.0" encoding="UTF-8"?>
    <A:propfind xmlns:A="DAV:">
      <A:prop>
        <A:add-member/>
        <E:bulk-requests xmlns:E="http://me.com/_namespace/"/>
        <A:current-user-privilege-set/>
        <A:displayname/>
        <D:max-image-size xmlns:D="urn:ietf:params:xml:ns:carddav"/>
        <D:max-resource-size xmlns:D="urn:ietf:params:xml:ns:carddav"/>
        <C:me-card xmlns:C="http://calendarserver.org/ns/"/>
        <A:owner/>
        <C:push-transports xmlns:C="http://calendarserver.org/ns/"/>
        <C:pushkey xmlns:C="http://calendarserver.org/ns/"/>
        <A:quota-available-bytes/>
        <A:quota-used-bytes/>
        <A:resource-id/>
        <A:resourcetype/>
        <A:supported-report-set/>
        <A:sync-token/>
      </A:prop>
    </A:propfind>


And the following on a single addressbook:

    <?xml version="1.0" encoding="UTF-8"?>
    <A:propfind xmlns:A="DAV:">
      <A:prop>
        <C:getctag xmlns:C="http://calendarserver.org/ns/"/>
        <A:sync-token/>
      </A:prop>
    </A:propfind>

It will use the addressbook-multiget REPORT to fetch contents of cards.

On the calendar-home-set it will request:

* `{DAV:}displayname`
* `{urn:ietf:params:xml:ns:caldav}calendar-description`
* `{http://calendarserver.org/ns/}getctag`
* `{http://apple.com/ns/ical/}calendar-color`
* `{urn:ietf:params:xml:ns:caldav}supported-calendar-component-set`
* `{DAV:}resourcetype`
* `{DAV:}current-user-privilege-set`

On calendars it may use REPORT to find all events within a certain time range:

    <x0:calendar-query xmlns:x0="urn:ietf:params:xml:ns:caldav" xmlns:x1="DAV:">
        <x1:prop>
            <x1:getetag />
            <x1:resourcetype />
        </x1:prop>
        <x0:filter>
            <x0:comp-filter name="VCALENDAR">
                <x0:comp-filter name="VEVENT">
                    <x0:time-range start="20100420T150000Z" />
                </x0:comp-filter>
            </x0:comp-filter>
        </x0:filter>
    </x0:calendar-query>


The last report is only used to find out of any event changed. The
calendar-multiget report is used to download the actual changes:

    <x0:calendar-multiget xmlns:x0="urn:ietf:params:xml:ns:caldav" xmlns:x1="DAV:">
        <x1:prop>
            <x1:getetag />
            <x0:calendar-data />
        </x1:prop>
        <x1:href>/calendars/admin/default/524022B0-8AA8-44BD-8E6A-F1B41FBBC9E2.ics</x1:href>
    </x0:calendar-multiget>



Base urls in iOS6
-----------------

It was reported that iOS switches to extremely buggy behavior if the CardDAV
server is not running on the root of the server, more specifically.. when the
user sets up the CardDAV server and the 'server' they fill in is not _just_ a
domainname, iOS breaks severely.

If you must have a carddav server that's not running off the root, you can
workaround this by setting up a 'well-known' endpoint for CardDAV, as
described in [ServiceDiscovery](/dav/service-discovery).

Base urls in iOS7
-----------------

iOS7 also has issues with servers not running on a root domain, although the
problem appears to have changed a bit in nature (need more details).

Setting up the Cal and CardDAV server by using a *full principal url* seems to
almost always fix these problems.

This issue also appeared in very old iOS versions (iOS 3).

Directory support
-----------------

iOS has support for a global read-only directory. iOS does not allow simply
browsing through the directory, it's used for searching only (using the
addressbook-query REPORT).

SabreDAV does have (very minimal) support for
[CardDAV directory](/dav/carddav-directory).

Encoding of HTTP/1.1 200 Ok
---------------------------

Apparently older iOS versions (1.4.2) require HTTP/1.1 200 Ok to be encoded in
uppercase (OK rather than Ok). This is fixed in SabreDAV version 1.5.3.
