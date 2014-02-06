---
name: iCal 
type: client
---

iCal (now known as just 'Calendar'), is one of the most feature-rich CalDAV
clients on there. A lot of testing with SabreDAV first happens with iCal,
as it tends to be the forerunner in supporting new standards, and also tends
to be the most correct implementation.

At the very least it has support for:

* [CalDAV][rfc4791]
* [Scheduling][rfc6638]
* [Calendar delegation](/dav/caldav-proxy)
* [Calendar sharing](/dav/caldav-sharing)

Technical information
---------------------

### Debugging

To enable the debug menu within ical, run the following on the command line:

    defaults write com.apple.iCal IncludeDebugMenu 1

Since OS X 10.9 (mavericks, this has changed to)

    defaults write com.apple.iCal CDB 1

To enable logging:

    defaults write com.apple.iCal LogHTTPActivity -boolean TRUE

Logging goes to 'Console.app'

### User agent

Some user agents we've seen:

    DAVKit/3.0.6 (661); CalendarStore/3.0.8 (860); iCal/3.0.8 (1287); Mac OS X/10.5.8 (9L31a)
    DAVKit/4.0.1 (730); CalendarStore/4.0.1 (973); iCal/4.0.1 (1374); Mac OS X/10.6.2 (10C540)

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

### Bugs

#### Assuming scheduling support

iCal appears to assume that any CalDAV server also supports from
CalDAV-scheduling features out of the box. iCal will use this to let the server
send emails, for things like an event invitation. 

If this is not supported, no emails for these types of actions will be sent.
This can be rather unexpected for users, as these expected emails just won't
arrive.

Since version 1.6 SabreDAV has a workaround for this. Read
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

[rfc4791]: http://tools.ietf.org/html/rfc4791
[rfc6638]: http://tools.ietf.org/html/rfc6638
