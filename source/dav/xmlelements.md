---
title: SabreDAV xml elements
layout: default
---

SabreDAV defines a few new elements, added as an extension to the WebDAV
protocol. They are categorized as WebDAV properties (that can be queried
using PROPFIND) and some others, which can appear in various responses.

All SabreDAV properties appear in the `http://sabredav.org/ns` namespace.


Properties
----------

### s:email-address

This property is defined on Principals. If you are making use of
`Sabre\DAVACL\AbstractPrincipalCollection` / `Sabre\DAVACL\Principal` this
property may be defined. It contains the email address of a principal.

### s:tempFile

This property is added by the [TemporaryFileFilterPlugin](/dav/temporary-files).
If a PROPFIND is done on a file that's matched by the TemporaryFileFilter, this
property will contain 'true'.

This property also appears in 'allprops' responses.

### s:vcard-url

THis property is defined on principals. It contains a relative url, pointing
to the users' own vcard. This property maps to Addressbook's
`{http://calendarserver.org/ns/}me-card` property. The reason for making this
into a separate property, is because this me-card property is defined on the
addressbook-home, which doesn't make a ton of sense.

Non-property xml elements
-------------------------

### s:code

The code element appears in error responses. It will contain an errorcode. In
most cases the errorcode will be 0, only if an external exception defined an
errorcode it will show up here.

### s:exception

The exception element appears in error responses. It will contain the classname
of the exception that was thrown.

### s:file

The file element appears in error responses. It contains the php filename where
the error originated.

### s:line

The line element appears in error responses. It contains the line number where
the error occurred.

### s:message

The message element appears in error responses. It will contain a
human-readable error description.

### s:sabredav-version

The sabredav-version element appears in error responses. It contains the
sabredav version number.

### s:header

The header can show up in error responses. It will contain the name of the HTTP header that triggered the error. Currently only implemented for the PreconditionFailed error,

### s:stacktrace

The stacktrace element appears in error responses. It will contain the full
stacktrace for the the error.

