---
title: Thunderbird
type: client
---

[Thunderbird][1] itself is not a DAV client. But, this functionality can be
achieved using add-ons.

[Lightning][2] is a very popular calendar add-on for Thunderbird, and adds
support for [CalDAV](/dav/caldav).

The [Sogo Connector][3] is an add-on developed for the SOGo groupware platform,
and also allows people to use this to integrate with any standard
[CardDAV](/dav/carddav) server.

[CardBook][4] is an add-on that can synchronize contacts with any standard
[CardDAV](/dav/carddav) server.

Lightning
---------

Lightning adds CalDAV support to thunderbird.
To set this up, simply go through the "File > new calendar" dialog.

It's important to note that Lightning, unlike many other CalDAV clients
does not automatically find all the calendars that are associated with a user.

Instead, it requires the user to to add every individual CalDAV calendar
manually.

The url used to setup CalDAV for lightning must be the full url to a calendar.
In default sabredav installations this tends to have the following format:

    http://[domain]/calendars/[username]/[calendarname]/

So _not_ the principal url.


SOGo connector
--------------

SOGo connector integrates the Thunderbird addressbook with CardDAV.

To install this plugin, head to the [SOGo downloads page][3], and download
the connector.

After downloading, head to the Add-ons manager in Thunderbird, click the
cog icon and use 'Install from file'.

After intallation it's possible to add CardDAV addressbooks to the Thunderbird
Address Book. Note that just like Lightning, it is required to enter the
entire path to the addressbook, as such:

    http://[domain]/addressbooks/[username]/[addressbookname]/

### Known bugs

The current latest version (24.0.3) has a bug that prevents creation of new
contacts and updating.

More information:

* <http://www.sogo.nu/bugs/view.php?id=1624>
* <http://www.sogo.nu/bugs/view.php?id=2575>
* <https://github.com/inverse-inc/sogo-connector.tb24/issues/9>

[1]: http://www.mozilla.org/en-US/thunderbird/
[2]: https://addons.mozilla.org/en-US/thunderbird/addon/lightning/
[3]: http://www.sogo.nu/downloads/frontends.html
[4]: https://addons.thunderbird.net/addon/cardbook/
