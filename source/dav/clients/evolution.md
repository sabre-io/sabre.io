---
name: Evolution 
type: client
---

Evolution is both a WebDAV client for contacts management (note: NOT CardDAV,
but it is compatible with the SabreDAV CardDAV implementation), and a CalDAV
client for Journals, Calendars and Tasks. Both clients are covered here.

The Evolution WebDAV client
---------------------------

The WebDAV client is used for managing addressbooks. It's a very simple client
(just does PROPFIND, GET and PUT). It also supports the use of the 'ctag' for
checking if the addressbook changed at all, and also verifies etags to see
if individual cards updated.

### Debugging

To enable debugging for this client, make sure evolution is fully stopped,
then restart e-addressbook-factory with the debug mode enabled as such:

    export WEBDAV_DEBUG=all
    ./e-addressbook-factory

If you start evolution after that, you will see the entire dialog.

### Issues

#### No UID

When evolution creates new contacts, it does not submit the UID property.
While this is valid for VCards themselves, vcards in CardDAV _must_ have
the property.

Until this issue is fixed, it will not be possible to create new contacts with
evolution.

Reference: <https://bugzilla.gnome.org/show_bug.cgi?id=640594>

This issue was fixed in evolution 3.6.2.

#### Statuscode

SabreDAV sent a HTTP 200 Ok statuscode for updating resources with PUT.
Evolution doesn't like this, as it requires 204 No Content if there is no
content in the response body.

This is actually correct per the HTTP standard, but hadn't been the case in
SabreDAV. This was fixed in SabreDAV 1.5.4.


The Evolution CalDAV client
---------------------------

### Connecting with evolution

Connecting to a CalDAV server is done through the "New > Create new calendar"
dialog. In this dialog it is possible to specify a CalDAV location.

The url must be a full url directly to the actual Calendar.  If you need
support for multiple calendars, these will all need to be setup through this
dialog.

To setup TODO lists through Evolution works the exact same (select New tasklist
instead of calendar).

### Technical notes

Some sample user agents:

    Evolution/2.28.1
    Evolution/3.2.3

Evolution makes use of the REPORT query to find all the events and TODO's.
It will start off with finding the ctag though, if the calendar has support
for it.

    PROPFIND /~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/ HTTP/1.1
    User-Agent: Evolution/2.28.1
    Depth: 0
    Content-Type: application/xml
    Content-Length: 113
    Host: localhost:80

    <propfind xmlns="DAV:" xmlns:CS="http://calendarserver.org/ns/">
      <prop>
        <CS:getctag/>
      </prop>
    </propfind>

Returning a list of all events in a specific timespan: (note that the exact
same request is made for TODO's, but VEVENT is replaced with VTODO.

    REPORT /~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/ HTTP/1.1
    User-Agent: Evolution/2.28.1
    Depth: 1
    Content-Type: application/xml
    Content-Length: 349
    Host: localhost:80

    <C:calendar-query xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:D="DAV:">
      <D:prop>
        <D:getetag/>
      </D:prop>
      <C:filter>
        <C:comp-filter name="VCALENDAR">
          <C:comp-filter name="VEVENT">
            <C:time-range start="20091228T060930Z" end="20100308T060930Z"/>
          </C:comp-filter>
        </C:comp-filter>
      </C:filter>
    </C:calendar-query>

Retrieving a specific list of events/todo's:

    REPORT /~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/ HTTP/1.1
    User-Agent: Evolution/2.28.1
    Depth: 1
    Content-Type: application/xml
    Content-Length: 726
    Host: localhost:80

    <C:calendar-multiget xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:D="DAV:">
      <D:prop>
        <D:getetag/>
        <C:calendar-data/>
      </D:prop>
      <D:href>/~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/115570AD-BBC2-4AF8-A206-C35EA5F32B0D.ics</D:href>
      <D:href>/~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/7E422880-3B9A-4C38-A427-3E49A7DAE7AB.ics</D:href>
      <D:href>/~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/8721297A-B66F-4B95-B7B2-45A726D00E7C.ics</D:href>
      <D:href>/~evert2/code/sabredav/acl3/calendars/admin/95D586E4-9E42-4FFF-88BF-3625D45A1B08/1B8B1474-56A7-4012-B9DA-48019D3FB268.ics</D:href>
    </C:calendar-multiget>


