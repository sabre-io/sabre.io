---
title: Android (iCalDAV)
type: client
---

[iCalDAV](https://github.com/iCalDAV/iCalDAV) is an open source Kotlin CalDAV
client library for Android and JVM applications. It provides a sync engine
with offline support and conflict resolution.

Supported features
------------------

* [CalDAV](/dav/caldav).
* [WebDAV ACL](/dav/acl).
* [SRV records and well-known urls](/dav/service-discovery).
* [WebDAV-Sync](/dav/sync).
* VTODO and VJOURNAL components.

Not yet supported:

* [CardDAV](/dav/carddav).
* [Scheduling](/dav/scheduling) (iTIP message building supported, but not full scheduling).
* [Calendar sharing](/dav/caldav-sharing).


Technical details
-----------------

iCalDAV is available on [Maven Central](https://central.sonatype.com/namespace/org.onekash)
under the `org.onekash` group ID.

```kotlin
dependencies {
    implementation("org.onekash:icaldav-client:2.6.2")
    implementation("org.onekash:icaldav-android:2.6.2")  // Android module
}
```

### User Agent

    iCalDAV/2.6.2 (Kotlin; Android)

### Properties

The client requests the following properties during calendar discovery:

* `{DAV:}resourcetype`
* `{DAV:}displayname`
* `{DAV:}current-user-principal`
* `{DAV:}principal-URL`
* `{urn:ietf:params:xml:ns:caldav}calendar-home-set`
* `{http://calendarserver.org/ns/}getctag`
* `{DAV:}sync-token`
* `{urn:ietf:params:xml:ns:caldav}supported-calendar-component-set`
* `{http://apple.com/ns/ical/}calendar-color`

### Sync Strategy

iCalDAV supports two sync strategies:

1. **WebDAV-Sync** (RFC 6578) - Preferred when server supports `sync-token`
2. **CTag-based sync** - Fallback using `{http://calendarserver.org/ns/}getctag`

The library uses `calendar-multiget` REPORT to fetch calendar objects efficiently.

### Provider Quirks

iCalDAV includes built-in handling for server-specific quirks:

* **iCloud**: CDATA response handling, namespace variations, regional redirects
* **Radicale**: Direct URL access (skip discovery)
* **Baikal/sabre-dav**: Standard CalDAV (no quirks needed)

Tested servers
--------------

iCalDAV maintains integration tests against:

* Baikal (sabre/dav based)
* Radicale
* Nextcloud
* iCloud

Links
-----

* [GitHub Repository](https://github.com/iCalDAV/iCalDAV)
* [Maven Central](https://central.sonatype.com/namespace/org.onekash)
* [Documentation](https://github.com/iCalDAV/iCalDAV#readme)