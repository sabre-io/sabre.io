---
title: CardDAV me-card
layout: default
---

Both the [iOS][1] as well as the [OS X][2] CardDAV client support a concept
called the 'me-card'.

The 'me-card' is a WebDAV property, stored on the 'addressbook home' that
contains a relative reference to a vcard associated with the current user.

It basically allows clients to discern which vCard is belongs to the user,
which results in a UI update, and can have influence on other parts of the
operating system (such as scheduling).

Setting the property results in a `PROPPATCH` request that looks like this:

    <?xml version="1.0" encoding="UTF-8"?>
    <A:propertyupdate xmlns:A="DAV:">
      <A:set>
        <A:prop>
          <C:me-card xmlns:C="http://calendarserver.org/ns/">
            <A:href>/addressbooks/evert/book1/E7213AAA-7206-4B97-926A-CDFECBD91C26-ABSPlugin.vcf</A:href>
          </C:me-card>
        </A:prop>
      </A:set>
    </A:propertyupdate>

As you can see it sets a complex WebDAV property `me-card` in the namespace
`http://calendarserver.org/ns/`.

Not supporting this property can result in crashes by the OS X address book
when the user selects a me-card.

Behavior in sabre/dav 1.6 until 2.1
-----------------------------------

Because sabre/dav can not yet support storing arbitrary complex properties
on any url, the carddav plugin takes any updates to this property and
automatically maps it to a different property:

    {http://sabredav.org/ns}vcard-url

There's three differences between these two properties:

1. It's stored in the `http://sabredav.org/ns` namespace and not
   `http://calendarserver.org/ns/`.
2. the vcard-url property is stored on a principal, not on the addressbook home.
3. the vcard-url property just holds a string value, whereas me-card is a
   complex property with a `href` sub-element.

The standard principals PDO backend has support for this property since 1.6
and will store it in the `principals` table.

Behavior as of sabre/dav 3.0
----------------------------

From sabre/dav 3.0 onwards, it's now possible to store any arbitrary complex
webdav property in any part of the webdav tree.

So starting from this version, the workaround to map it to the
`{http://sabredav.org/ns}vcard-url` has been removed. If you want support
for the me-card, you can simply enable the [property storage plugin][3].

[1]: /dav/clients/ios/
[2]: /dav/clients/osx-addressbook/
[3]: /dav/property-storage/
