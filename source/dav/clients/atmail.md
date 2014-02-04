---
name: Atmail
type: client
---

Atmail is a proprietary webmail client with calendar support. Instead of providing a
custom calendar, CalDAV is used for the underlying datastore.

Note: this small document has been written based on an older version of atmail (5.0),
Atmail now actually has a built-in SabreDAV-based server, so this document is no
longer relevant.

Connecting with Atmail
----------------------

Using your own CalDAV server can be configured through the 'Settings' tab.

Currently Atmail only appears to support HTTP Basic authentication.
This is problematic for SabreDAV, as most authentication backends are all
Digest based.

Implementor notes
-----------------

Atmail sends the following user agent:

    Atmail 5.0

