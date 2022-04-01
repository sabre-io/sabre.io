---
title: iCal
type: client
---

iCal (now known as just 'Calendar'), is one of the most feature-rich CalDAV
clients out there. A lot of testing with SabreDAV first happens with iCal,
as it tends to be the forerunner in supporting new standards, and also tends
to be the most correct implementation.

At the very least it has support for:

* [CalDAV][rfc4791]
* [Scheduling][rfc6638]
* [Calendar delegation](/dav/caldav-proxy)
* [Calendar sharing](/dav/caldav-sharing)
* [Subscriptions](/dav/subscriptions)

Technical information
---------------------

### Debugging

To enable the debug menu within ical, run the following on the command line:

    defaults write com.apple.iCal IncludeDebugMenu 1

Since OS X 10.9 (mavericks), this has changed to

    defaults write com.apple.iCal CDB 1

To enable logging:

    defaults write com.apple.iCal LogHTTPActivity -boolean TRUE

Logging goes to 'Console.app'.

### Subscriptions

iCal allows server-side management of calendar subscriptions. This allows a
user to store their iCal feeds on a server, and have them stay in sync accross
different clients.

In OS X 10.7 and 10.8 new subscriptions are created using a `MKCOL` method. The
body contains a `{DAV:}resourcetype` with values `{DAV:}collection` and
`{http://calendarserver.org/ns/}subscribed`.

In OS X 10.9.2 they changed to using `MKCALENDAR` instead. We suspect that this
is a bug, but we're adding support for it in sabre/dav nonetheless.

### User agent

Some user agents we've seen:

    DAVKit/3.0.6 (661); CalendarStore/3.0.8 (860); iCal/3.0.8 (1287); Mac OS X/10.5.8 (9L31a)
    DAVKit/4.0.1 (730); CalendarStore/4.0.1 (973); iCal/4.0.1 (1374); Mac OS X/10.6.2 (10C540)
    Mac_OS_X/10.9.2 (13C64) CalendarAgent/176

### 10.5 iCal

To setup 10.5 iCal a full principal url must be provided. On this principal url, iCal will request the following:

    <?xml version="1.0" encoding="utf-8"?>
    <x0:propfind xmlns:x2="http://calendarserver.org/ns/" xmlns:x1="urn:ietf:params:xml:ns:caldav" xmlns:x0="DAV:">
     <x0:prop>
      <x1:calendar-home-set/>
      <x1:calendar-user-address-set/>
      <x1:schedule-inbox-URL/>
      <x1:schedule-outbox-URL/>
      <x2:dropbox-home-URL/>
      <x2:notifications-URL/>
      <x0:displayname/>
     </x0:prop>
    </x0:propfind>

What's mainly important here is the calendar-home-set, which contains a url with a reference to all the calendars.

On this calendar url, the following PROPFIND request is made:

    <?xml version="1.0" encoding="utf-8"?>
    <x0:propfind xmlns:x1="http://calendarserver.org/ns/" xmlns:x0="DAV:" xmlns:x3="http://apple.com/ns/ical/" xmlns:x2="urn:ietf:params:xml:ns:caldav">
     <x0:prop>
      <x1:getctag/>
      <x0:displayname/>
      <x2:calendar-description/>
      <x3:calendar-color/>
      <x3:calendar-order/>
      <x0:resourcetype/>
      <x2:calendar-free-busy-set/>
     </x0:prop>
    </x0:propfind>

### 10.6 iCal

10.6 iCal does not require a full principal url, as it can automatically
discover these. See [Service Discovery](/dav/service-discovery) for a bit
more detail.

It will request the following properties on the principal url.

* DAV: principal-collection-set
* CalDAV: calendar-home-set
* CalDAV: calendar-user-address-set
* CalDAV: schedule-inbox-URL
* CalDAV: schedule-outbox-URL
* CalendarServer: dropbox-home-URL
* CalendarServer: xmpp-uri
* DAV: displayname
* DAV: principal-URL
* DAV: supported-report-set

After finding the calendar-home-url, the following is requested for calendars:

    <x0:propfind xmlns:x0="DAV:" xmlns:x3="http://apple.com/ns/ical/"
      xmlns:x1="http://calendarserver.org/ns/" xmlns:x2="urn:ietf:params:xml:ns:caldav">
        <x0:prop>
            <x1:xmpp-server />
            <x1:xmpp-uri />
            <x1:getctag />
            <x0:displayname />
            <x2:calendar-description />
            <x3:calendar-color />
            <x3:calendar-order />
            <x2:supported-calendar-component-set />
            <x0:resourcetype />
            <x2:calendar-free-busy-set />
            <x2:schedule-calendar-transp />
            <x2:schedule-default-calendar-URL />
            <x0:quota-available-bytes />
            <x0:quota-used-bytes />
            <x2:calendar-timezone />
            <x0:current-user-privilege-set />
        </x0:prop>
    </x0:propfind>

### 10.7 and up

More details to follow

### 10.14 "Mojave" with `Calendar.app` v11.0

Under OS X 10.14 "Mojave", configuration with a `Server Path` of `/baikal/html/dav.php/principals/<username>` worked to successfully configure `Calendar.app` (version 11.0) with Baikal 0.9.2.  Note that https:// seems to be required in order for `Calendar.app` to successfully send credentials.

### Bugs

#### Assuming scheduling support

iCal versions before Mavericks (10.9) appear to assume that any CalDAV server
also supports some CalDAV-scheduling features out of the box. iCal will use
this to let the server send emails, for things like an event invitation.

If this is not supported, no emails for these types of actions will be sent.
This can be rather unexpected for users, as these expected emails just won't
arrive.

Since version 2.1 SabreDAV has support for [scheduling](/dav/scheduling/),
which can be enabled to fix this issue.

Before version 2.1 SabreDAV had a workaround for this. Read
[IMipHandler](/dav/imiphandler) for more details.

This issue has been discovered on at least 10.7 and 10.8 iCal, not yet sure about older versions.

#### Trailing slash (iCal 10.5 and iCal 10.6)

It was reported on several wiki's iCal needs a trailing slash for the url to
connect to (the principal url). This is not enough however, the `{DAV:}href`
element in the {DAV:}response element MUST also have this trailing url.

Without it errors such as the following can come up:

* "the server has not specified a calendar home ... "
* "here was an unexpected error with the request (domain CalDAVErrorDomain /
   error 5 / description 'The server has not specified a calendar home for the
   account at .."

A workaround is in place in SabreDAV.

#### iCal depends on a DAV: header to be set in all PROPFIND responses

Traditionally the DAV: header is only needed in the OPTIONS request. If
calendar-proxy support is required, this header must also be set in other
responses. In particular, iCal seems to pick up on it if it's set in a
PROPFIND response.

Since SabreDAV 1.5 we always send along the DAV: header for every PROPFIND
responses.

#### No percentage sign in usernames allowed

At least in OS X 10.11, iCal does not allow a `%` in usernames. Attempting this
will cause iCal to simply not send any username or password and fail with an
error.


### Random samples of HTTP requests iCal generates.

#### Creating a subscription in 10.7

    <A:mkcol xmlns:A="DAV:">
        <A:set>
            <A:prop>
                <B:subscribed-strip-attachments xmlns:B="http://calendarserver.org/ns/" />
                <B:subscribed-strip-todos xmlns:B="http://calendarserver.org/ns/" />
                <A:resourcetype>
                    <A:collection />
                    <B:subscribed xmlns:B="http://calendarserver.org/ns/" />
                </A:resourcetype>
                <E:calendar-color xmlns:E="http://apple.com/ns/ical/">#1C4587FF</E:calendar-color>
                <A:displayname>Jewish holidays</A:displayname>
                <C:calendar-description xmlns:C="urn:ietf:params:xml:ns:caldav">Sixteen annual Jewish holidays. Update every 2 weeks.</C:calendar-description>
                <E:calendar-order xmlns:E="http://apple.com/ns/ical/">19</E:calendar-order>
                <B:source xmlns:B="http://calendarserver.org/ns/">
                    <A:href>webcal://www.webcal.fi/cal.php?id=49&amp;rid=ics&amp;wrn=0&amp;wp=12&amp;wf=55</A:href>
                </B:source>
                <E:refreshrate xmlns:E="http://apple.com/ns/ical/">P1W</E:refreshrate>
                <B:subscribed-strip-alarms xmlns:B="http://calendarserver.org/ns/" />
            </A:prop>
        </A:set>
    </A:mkcol>


#### Creating a new subscription in 10.9.2

    <B:mkcalendar xmlns:B="urn:ietf:params:xml:ns:caldav">
        <A:set xmlns:A="DAV:">
            <A:prop>
                <B:supported-calendar-component-set>
                    <B:comp name="VEVENT" />
                </B:supported-calendar-component-set>
                <C:subscribed-strip-alarms xmlns:C="http://calendarserver.org/ns/" />
                <C:subscribed-strip-attachments xmlns:C="http://calendarserver.org/ns/" />
                <A:resourcetype>
                    <A:collection />
                    <C:subscribed xmlns:C="http://calendarserver.org/ns/" />
                </A:resourcetype>
                <D:refreshrate xmlns:D="http://apple.com/ns/ical/">P1W</D:refreshrate>
                <C:source xmlns:C="http://calendarserver.org/ns/">
                    <A:href>webcal://www.webcal.fi/cal.php?id=49&amp;amp;rid=ics&amp;amp;wrn=0&amp;amp;wp=12&amp;amp;wf=55</A:href>
                </C:source>
                <D:calendar-color xmlns:D="http://apple.com/ns/ical/">#1C4587FF</D:calendar-color>
                <D:calendar-order xmlns:D="http://apple.com/ns/ical/">19</D:calendar-order>
                <B:calendar-description>Sixteen annual Jewish holidays. Update every 2 weeks.</B:calendar-description>
                <C:subscribed-strip-todos xmlns:C="http://calendarserver.org/ns/" />
                <A:displayname>Jewish holidays</A:displayname>
            </A:prop>
        </A:set>
    </B:mkcalendar>


#### Requesting a list of calendars in 10.9.2

    <?xml version='1.0' encoding='UTF-8'?>
    <A:propfind xmlns:A="DAV:">
      <A:prop>
        <A:add-member/>
        <C:allowed-sharing-modes xmlns:C="http://calendarserver.org/ns/"/>
        <D:autoprovisioned xmlns:D="http://apple.com/ns/ical/"/>
        <E:bulk-requests xmlns:E="http://me.com/_namespace/"/>
        <D:calendar-color xmlns:D="http://apple.com/ns/ical/"/>
        <B:calendar-description xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <B:calendar-free-busy-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <D:calendar-order xmlns:D="http://apple.com/ns/ical/"/>
        <B:calendar-timezone xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <A:current-user-privilege-set/>
        <B:default-alarm-vevent-date xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <B:default-alarm-vevent-datetime xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <A:displayname/>
        <C:getctag xmlns:C="http://calendarserver.org/ns/"/>
        <D:language-code xmlns:D="http://apple.com/ns/ical/"/>
        <D:location-code xmlns:D="http://apple.com/ns/ical/"/>
        <A:owner/>
        <C:pre-publish-url xmlns:C="http://calendarserver.org/ns/"/>
        <C:publish-url xmlns:C="http://calendarserver.org/ns/"/>
        <C:push-transports xmlns:C="http://calendarserver.org/ns/"/>
        <C:pushkey xmlns:C="http://calendarserver.org/ns/"/>
        <A:quota-available-bytes/>
        <A:quota-used-bytes/>
        <D:refreshrate xmlns:D="http://apple.com/ns/ical/"/>
        <A:resource-id/>
        <A:resourcetype/>
        <B:schedule-calendar-transp xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <B:schedule-default-calendar-URL xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <C:source xmlns:C="http://calendarserver.org/ns/"/>
        <C:subscribed-strip-alarms xmlns:C="http://calendarserver.org/ns/"/>
        <C:subscribed-strip-attachments xmlns:C="http://calendarserver.org/ns/"/>
        <C:subscribed-strip-todos xmlns:C="http://calendarserver.org/ns/"/>
        <B:supported-calendar-component-set xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <B:supported-calendar-component-sets xmlns:B="urn:ietf:params:xml:ns:caldav"/>
        <A:supported-report-set/>
        <A:sync-token/>
      </A:prop>
    </A:propfind>

[rfc4791]: http://tools.ietf.org/html/rfc4791
[rfc6638]: http://tools.ietf.org/html/rfc6638
