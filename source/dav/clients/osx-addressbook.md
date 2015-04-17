---
title: OS X addressbook
type: client
---

Addressbook.app (renamed to Contacts in OS X 10.9) is among the first CardDAV
clients, and it's shipped with OS X since version 10.6 (Snow Leopard). There
are many bugs in the 10.6 client though, most of which have been solved in
10.7.

Technical information
---------------------

### Debugging

To enable CardDAV traffic logging on 10.8 and above, run the following commands on the command line:

    defaults write com.apple.addressbook.carddavplugin EnableDebug -bool YES
    defaults write com.apple.addressbook.carddavplugin LogConnectionDetails -bool YES

Logs will be written to ~/Library/Logs/CardDAVPlugin and may be viewed with 'Console.app'.

### Directory support

AddressBook.app has support for a global read-only directory. Addressbook.app
does not allow simply browsing through the directory, it's used for searching
only (using the addressbook-query REPORT).

SabreDAV does have (very minimal) support for
[CardDAVDirectory](/dav/carddav-directory), by providing a simple interface:
`Sabre\CardDAV\IDirectory`.

### 'Me' card

AddressBook.app has the ability to mark a specific vcard as the users' own
vcard. Support for this is built-in since SabreDAV 1.6.

The 'Me card' is simply a property on the users' addressbook-collection-set.
In SabreDAV this would mean (in a default tree layout) that the property is
set on `/addressbooks/[username]`.

The request to set a "Me" card looks as follows:

    PROPPATCH /addressbooks/evert/ HTTP/1.1
    Host: ...
    User-Agent: AddressBook/6.1 (1083) CardDAVPlugin/200 CFNetwork/520.3.2 Mac_OS_X/10.7.3 (11D50)
    Content-Length: 280
    Accept: */*
    Accept-Language: en-us
    Accept-Encoding: gzip, deflate
    Content-Type: text/xml
    Pragma: no-cache
    Authorization: Digest ...
    Connection: keep-alive

    <?xml version="1.0" encoding="UTF-8"?>
    <A:propertyupdate xmlns:A="DAV:"><A:set><A:prop><C:me-card xmlns:C="http://calendarserver.org/ns/"><A:href>/addressbooks/evert/book1/E7213AAA-7206-4B97-926A-CDFECBD91C26-ABSPlugin.vcf</A:href></C:me-card></A:prop></A:set></A:propertyupdate>

I've noticed that if the Me card is not supported, Addressbook.app may crash.

More information can be found on the [me-card page](/dav/carddav-me-card/).

Bugs
----

### Domain root (10.6 issue)

**Affects: OS X 10.6**

The CardDAV server must absolutely run on the root of the domain. Addressbook
makes a lot of assumptions based around this, and running the CardDAV server
anywhere else will simply break.

In some cases it was enough (for me) to simply specify the domainname of the
CalDAV server, but I've also had cases where:

* I needed to specify a full principal url (e.g.: http://example.org/principals/username/)
* I needed to also include a HTTP port (e.g.: http://example.org:80/principals/username/)

Even after trying this, it seems to randomly forget the correct TCP port and
default back to 8008 (which is the standard port for Darwin Calendar Server).

### Single addressbook

**Affects: OS X 10.6 until OS X 10.9**

OS X addressbook can only ever work with 1 address book. Even though the
CardDAV standard makes it easy for users to own more than one addressbook,
this is not supported.

Unfortunately this means that if a user has more than one addressbook in their
account, only the 'first' will show up, and contacts from other addressbooks
are completely hidden to the user.

This can cause for a lot of confusion, and there is no obvious solution other
than simply _enforce_ a 1 address book limit for users.

### @ in username

**Affects: OS X 10.6**

This client does not support the usage of the @-character in usernames. This
means that it's not possible with this client to use email addresses as
usernames. The actual underlying problem is actually that @ does not get
urlencoded, and it will treat the part before the @ as the username, and prefix
the hostname for HTTP requests with the domainname of the email address.

A workaround is to replace @ with an underscore `_` instead, but this is really
only a good solution if you use HTTP Basic authentication, as with Digest using
a different username will also alter the hash. It's best to simply not use
email addresses for usernames if you plan to support (10.6) Addressbook.app.

This client can only use 1 addressbook. It will most likely use the first
addressbook in a users' collection of addressbooks.

### ctag is required

**Affects: at least OSX 10.6 and OSX 10.7**

This client requires impementation of the proprietary
'{http://calendarserver.org/ns/}getctag' property. Without it, it will simply
not request any vcards.
