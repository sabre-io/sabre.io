---
title: Building a CardDAV client
layout: default
---

What is this document?
----------------------

As server developers, we get a lot of questions on how to interact with a
CardDAV server. This document explains how to integrate correctly with a
CardDAV server.

This document (should) apply for _any_ CardDAV server, not just SabreDAV.

Clients
-------

Before you build your own client, there's a chance there's already a client
avaible for your programming language.

We've developed a PHP client that does _some_ DAV-related stuff and makes it
a tad easier. More information can be found [on this wiki](/dav/davclient).

We'd love to have a list here for CardDAV clients. So know one?
[contact](/contact) us.


High-level protocol
-------------------

CardDAV is defined by [rfc6352][rfc6352]. CardDAV is heavily inspired by it's
counterpart CalDAV, and is mostly regarded as simpler.

CardDAV builds on [WebDAV][rfc4918]. WebDAV itself extends HTTP.

Some operations will be very familiar if you already have experience with HTTP
services (`GET`, `PUT` and `DELETE`), but a number of new methods have been
added to this list (`PROPFIND`, `PROPPATCH`, `REPORT`, `MKCOL`, `MKCALENDAR`,
`ACL`).

Most HTTP clients should just supports methods they don't know about. So it's
very wise to simply use a stock HTTP client for your platform, if your
platform does not already have a CardDAV client.

vCards
------

Every contact is submitted as a vCard. Every compliant CardDAV client or
Server _must_ support vCard 3.0 ([rfc2425][rfc2425] and [rfc2426][rfc2426]).
vCard 2.1 is way too old and should always be rejected.

vCard 4.0 ([rfc6350][rfc6350]) also exists though, and is in many respects a
massive improvement over vCard 3.0. vCard 4 must now always be encoded as
UTF-8, and many inconsistencies and problems have been fixed.

However, compliant servers must specifically advertise that they support
vCard 4.0, and clients must be willing to send vCard 3.0 if the server does
not support it.

The current SabreDAV server does not yet support vCard 4. In a future release
we will want to start accepting vCard 4, and automatically convert between
vCard 3 and 4. As soon as SabreDAV does this, vCard 4 will also immediately
become the preferred format.

One thing we specifically want to warn people for, is that even though the
vCard format seems easy to parse and generate, there are a lot of little rules
that make it complicated.

A simple vCard may look like this:

    BEGIN:VCARD
    VERSION:4.0
    FN:Evert Pot
    N:Pot;Evert;;;
    END:VCARD

Don't fall into the trap of thinking every line is simply in the format
`propertyname colon propertyvalue`.

There's:

* Mixed character encoding, sometimes differing per line
* Different escaping mechanisms of values, which depends on the _name_ of the
  value.
* Parameters, with different escaping mechanisms and a new (rfc6868) standard
  escaping mechanism that noone supports yet.
* Line-folding. Sometimes single multi-byte UTF-8 characters are split up with
  a new-line.
* Two styles of new-lines, sometimes in the same document (`\n` and `\r\n`).
* Quoted-printable encoding and base64 encoding.
* Parameters that have their name omitted, because it's implied from their
  values.
* Properties can be grouped together with a special syntax that alters the
  encoding of a property group.

Why did I write this list? Because if you're going to parse and generate
vCards, you should either:

* Be fully aware of the scope of doing so, or:
* Use a parser that somebody already wrote for your programming language.

### vCard parsers, per language

| Language | Library |
| -------- | ------- |
| PHP      | [sabre/vobject][1]
| Java     | [ez-vcard][2]
| Ruby     | [vcard][3]


Know of any other good vCard parsers? Let me know so I can list them.

XML
---

CardDAV servers also use XML for various things:

* Getting a list of all vCards
* Getting information about an addressbook
* Finding out if vCards or addressbooks have changed.

Retain full vCards!
-------------------

In most cases, when integrating with foreign API's, you will figure out the
remote data model, and write code to map that to the data model in your
application. This tends to be some mapping code that is bi-directional and
simply converts one datamodel (such as json or xml) to something local (such
as an mvc model, database record or object property).

When integrating with CardDAV, it is not quite as simple.

The problem with simply mapping the vcard to your local data model, is that
there is an potentially a lot of information to map. vCards can contain all
sorts of information, and even allow application to define new properties.

> vCards can contain _lot_ of different information, and information about
> information.

If your data model is simpler than the vCard data model, this inheritly means
that data can get lost during conversion. E.g.: mapping back and forward, and
reversing this again tends to be a 'lossy' process.

To illustrate, lets at the protocol from a very high level. Simplisticly we
will be doing a `GET` request (or equivalent) and later on a `PUT` request to
update a vcard.

You _must absolutely_ make sure that none of the information you received in a
`GET` is lost when you perform the `PUT`.

Almost every client on the planet will even embed custom non-standard data
in vCards. If you discard this data when performing `PUT`, you are destroying
your users data.

So a common trick that implementors use **AND WE DON'T RECOMMEND** is

1. Go through all the properties of a vCard
2. Map the properties you support to a local data model
3. Store all the properties that are not supported by the local data model in
   a separate place.

Then when the vCard is uploaded again with `PUT`, the 'unknown' properties
are stitched back in.

We consider this to be a bad idea, because it ignores several vCard features:

* Parameters you may or may not support
* Property groups
* And a little bit less important: the order in which items appear can be
  relevant to the user.

### Our recommendation

1. Download the vCard
2. Retain the entire vCard and store it locally, or at least in some
   lossless way
3. Parse the vCard and populate your models with the information that is
   relevant to you.
4. Keep a reference to which vCard property maps to what information in the
   model.

Now when something changes in a model (e.g.: a user changes an email address
in your UI.)

1. Model receives change (email address updated)
2. Find the property in the vCard that originally mapped to the information in
   the model.
3. Update the value in the vCard.
4. Upload the vCard.

In an ideal world, your vCard _is_ your model though.

Regardless of how this issue is solved (there may be better suggestions, we
would love to hear it), _not_ ensuring that original vCard is kept as close
to the original as possible is guaranteed to trigger bugs and edge-cases for
all sorts of CardDAV clients.

Typical urls
------------

Note that the following url structure is typical for SabreDAV, but may be
different for other servers. All these urls should be discovered by a client,
but listing these here helps with illustrating the examples that follow:

url | description
--- | -----------
`http://dav.example.org/` | Root
`http://dav.example.org/principals/johndoe/` | A principal url
`http://dav.example.org/addressbooks/johndoe/` | The addressbook home
`http://dav.example.org/addressbooks/johndoe/contacts/` | An addressbook
`http://dav.example.org/addressbooks/johndoe/contacts/foobarapp-2357-aeaat34.vcf` | A vcard

Authentication
--------------

Servers typically use HTTP Digest or HTTP Basic authentication. Your client
should already support these. The Google CardDAV API uses OAuth2.

Operations
----------

### Retrieving addressbook information

To receive information about a URL, we use the `PROPFIND` method.
In this case we're going to ask for the addressbooks display name and a
so-called 'ctag'.

    PROPFIND /addressbooks/johndoe/contacts/ HTTP/1.1
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
`PROPFIND` allows the client to fetch properties from an url.

CardDAV uses many properties like this, but in this case we just fetch the
'displayname', which is the human-readable name the user gave the addressbook, and
the ctag. The ctag must be stored for subsequent requests.

The request will return something like:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/</d:href>
            <d:propstat>
                <d:prop>
                    <d:displayname>My Address Book</d:displayname>
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

It is possible that a server does not support the ctag. In that case it will
likely return `404 Not Found` for the ctag, and `200 OK` for the displayname. 

Example:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/</d:href>
            <d:propstat>
                <d:prop>
                    <d:displayname>My Address Book</d:displayname>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
            <d:propstat>
                <d:prop>
                    <cs:getctag>3145</cs:getctag>
                </d:prop>
                <d:status>HTTP/1.1 404 Not Found</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

So take note from this last response. Here we display that the status, such
as the `404` and the `200` are _not_ related to the existence of the url
(`/addressbooks/johndoe/contacts`). The statuscodes are re-used to return
infromation about the individual properties.

### Downloading objects

Now we download every single object in this addressbook. To do this, we use a
`REPORT` method.

    REPORT /addressbooks/johndoe/contacts/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <card:addressbook-query xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:prop>
            <d:getetag />
            <card:address-data />
        </d:prop>
    </c:addressbook-query>

This request will return a large xml object with _all_ the vCards, and their
etags.

This report will return a multi-status object again:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/abc-def-fez-123454657.vcf</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"2134-314"</d:getetag>
                    <card:address-data>BEGIN:VCARD
                        VERSION:3.0
                        FN:My Mother
                        UID:abc-def-fez-1234546578
                        END:VCARD
                    </card:address-data>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/someapplication-12345678.vcf</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"5467-323"</d:getetag>
                    <card:address-data>BEGIN:VCARD
                        VERSION:3.0
                        FN:Your Mother
                        UID:foo-bar-zim-gir-1234567
                        END:VCARD
                    </card:address-data>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

This addressbook only contained 2 contacts.

So after you retrieved and processed these, for each object you must retain:

* The vCard data itself
* The url
* The etag

In this case all urls ended with `.vcf`. This is often the case, buy you must
not rely on this. In this case the UID in the vCards was also identical to
a part of the url. This too is often the case, but again not something you can
rely on, so don't make any assumptions.

The url and the UID have no meaningful relationship, so treat both those items
as separate unique identifiers.

### Finding out if anything changed

To see if anything in an addressbook changed, we simply request the ctag again
on the addressbook. If the ctag did not change, you still have the latest copy.

This is the purpose of the ctag. Every time _anything_ in the address book
changes, the ctag must also change.

If it did change, you should request all the etags in the entire addressbook
again:

    REPORT /addressbooks/johndoe/contacts/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <card:addressbook-query xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:prop>
            <d:getetag />
        </d:prop>
    </c:addressbook-query>


Note that this last request is extremely similar to a previous one, but we are
only asking for the etag, not the address-data.

The reason for this, is that addressbooks can be rather huge. It will save a TON
of bandwidth to only check the etag first.

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/abc-def-fez-123454657.vcf</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"2134-888"</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
        <d:response>
            <d:href>/addressbooks/johndoe/contacts/acme-12345.vcf</d:href>
            <d:propstat>
                <d:prop>
                    <d:getetag>"9999-2344""</d:getetag>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

Judging from this last request, 3 things have changed:

* The etag for the first contact has changed, so it must have been updated.
* There's a new url, some other client must have created a new contact.
* The second contact we saw earlier is no longer in the list, so it must have
  been deleted.

So based on those 3 points, we know that we need to remove a contact from the
local addressbook, and fetch the vCards for both the new item, and the updated
one.

To fetch the data for these, you can simply issue GET requests:

    GET /addressbooks/johndoe/contacts/abc-def-fez-123454657.vcf

But that does not scale up well, in case a few hundred contacts have changed.
It's better to batch the GET's together with `multiget`.

    REPORT /addressbooks/johndoe/contacts/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <card:addressbook-multiget xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:prop>
            <d:getetag />
            <c:addressbook-data />
        </d:prop>
        <d:href>/addressbooks/johndoe/contacts/abc-def-fez-123454657.vcf</d:href>
        <d:href>/addressbooks/johndoe/contacts/acme-12345.vcf</d:href>
    </card:addressbook-multiget>

This request will simply return a multi-status again with the addressbook-data and
etag.

### A small note about writing code for this.

If you read this far and understood what's been said, you may have realized that
it's a bit cumbersome to have a separate step for the initial sync, and
subsequent updates.

It would totally be possible to skip the 'initial sync', and just use
addressbook-query and addressbook-multiget REPORTS for the initial sync as well.

Updating a contact 
------------------

Updating a vCard is rather simple:

    PUT /addressbook/johndoe/contacts/some-contact.vcf HTTP/1.1
    Content-Type: text/vcard; charset=utf-8
    If-Match: "2134-314"

    BEGIN:VCARD
    ....
    END:VCARD

A response to this will be something like this:

    HTTP/1.1 204 No Content
    ETag: "2134-315"

The update gave us back the new ETag. SabreDAV returns this ETag on updates
most of the time, but not always.

There are cases where the CarddAV server must modify the vCard immediatly
after receiving it, for various reasons. In those situations an ETag will
_not_ be returned, and you should ideally issue a GET request immediately
after to figure out how the server changed the contact.

Many clients skip the `GET` step though.

A few notes:

### Don't change the UID 

The `UID` and the url of the object are important to not change. Changing
either will highly confuse other clients and the server _should_ reject those
changes (although they don't always).

Creating a contact
------------------

Creating a contact is almost identical, except that you (as a client) are
responsible for determining the url of the object, and UID.

    PUT /addressbooks/johndoe/contacts/somerandomstring.vcf HTTP/1.1
    Content-Type: text/vcard; charset=utf-8

    BEGIN:VCARD
    VERSION:3.0
    UID:some-other-random-string
    ....
    END:VCARD

A response to this will be something like this:

    HTTP/1.1 201 Created
    ETag: "21345-324"

Similar to updating, an ETag is often returned, but there are cases where this
is not true.

Deleting a contact
------------------

Deleting is simple enough:

    DELETE /addressbooks/johndoe/contacts/132456762153245.vcf HTTP/1.1
    If-Match: "2134-314"

Discovery
---------

Ideally you will want to make sure that all the addressbooks in an account are
automatically discovered. The best user interface would be to just have to
ask for three items:

* Username
* Password
* Server

And the server should be as short as possible. This is possible with most
servers.

If, for example a user specified 'dav.example.org' for the server, the first
thing you should do is attempt to send a `PROPFIND` request to
`https://dav.example.org/`. Note that you _should_ try the https url before the
http url.

This `PROPFIND` request looks as follows:

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

    <d:multistatus xmlns:d="DAV:">
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

What we need from this url, is their 'addressbook home'. The addressbook home
is a collection that contains all of the users' addressbooks.

To request that, issue the following request:

    PROPFIND /principals/users/johndoe/ HTTP/1.1
    Depth: 0
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
      <d:prop>
         <card:addressbook-home-set />
      </d:prop>
    </d:propfind>

This will return a response such as the following:

    HTTP/1.1 207 Multi-status
    Content-Type: application/xml; charset=utf-8

    <d:multistatus xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
        <d:response>
            <d:href>/</d:href>
            <d:propstat>
                <d:prop>
                    <c:addressbook-home-set>
                        <d:href>/addressbooks/johndoe/</d:href>
                    </c:addressbook-home-set>
                </d:prop>
                <d:status>HTTP/1.1 200 OK</d:status>
            </d:propstat>
        </d:response>
    </d:multistatus>

Lastly, to list all the addressbooks for the user, issue a PROPFIND request
with `Depth: 1`.

    PROPFIND /addressbooks/johndoe/ HTTP/1.1
    Depth: 1
    Prefer: return-minimal
    Content-Type: application/xml; charset=utf-8

    <d:propfind xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/">
      <d:prop>
         <d:resourcetype />
         <d:displayname />
         <cs:getctag />
      </d:prop>
    </d:propfind>

In that last request, we asked for 3 properties.

The `resourcetype` tells us what type of object we're getting back. You must
read out the `resourcetype` and ensure that it contains at least an
`addressbook` element in the CardDAV namespace. Other items _may_ be returned,
including non-addressbooks, which your application should ignore.

### Advanced discovery topics

Read the [Service Discovery documentation](/dav/service-discovery)

[1]: https://packagist.org/packages/sabre/vobject
[2]: https://code.google.com/p/ez-vcard/
[3]: http://rubygems.org/gems/vcard

[rfc2425]: https://tools.ietf.org/html/rfc2425
[rfc2426]: https://tools.ietf.org/html/rfc2426
[rfc5545]: https://tools.ietf.org/html/rfc5545
[rfc4791]: https://tools.ietf.org/html/rfc4791
[rfc4918]: https://tools.ietf.org/html/rfc4918
[rfc6350]: https://tools.ietf.org/html/rfc6350
[rfc6352]: https://tools.ietf.org/html/rfc6352
