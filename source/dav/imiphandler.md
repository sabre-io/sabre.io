---
title: IMipHandler
layout: default
---

**Note: this feature is removed as of sabre/dav 2.1. Read
[scheduling][scheduling] for more details.**

The IMipHandler is responsible for sending emails. This is used since version
1.6.

The reason this was added, was because iCal wrongfully assumes that a CalDAV
server supports some parts of the CalDAV scheduling extension.

So by using the IMipHandler, SabreDAV will be able to send the following
emails on your behalf:

  * Invitation to an event
  * Accepting an event
  * Declining an event
  * Deleting an event

In the future this system will also be used for other caldav-scheduling
features.

Usage
-----

To use the IMipHandler, simply attach it to `Sabre\CalDAV\Plugin`.


    $caldavPlugin = new \Sabre\CalDAV\Plugin();
    $caldavPlugin->setIMipHandler(
        new \Sabre\CalDAV\Schedule\IMip('no-reply@example.org')
    );

You must specify a proper From: address. This class uses PHP's mail() function
under the hood. To use some other system, it's possible to subclass it.

[scheduling]: /dav/scheduling/
