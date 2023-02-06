---
title: sabre/dav 3.0 released
product: dav 
sidebar: none
date: "2015-06-02T13:06:13-04:00"
tags:
    - dav
    - release
    - major
---

We just tagged and zipped the sabre/dav 3.0 release. This is only a year after
the 2.0 release, but 6 years after the 1.0 release.

This means we needed 440% less time to release. If we continue to increase
speed at this rate, it means we should get a 4.0 release in august, and
somewhere in september we will average 1 major release per hour.

Lets hope that's not the case though, because writing these blogposts would get
old rather quickly.

Anyway, back to the subject at hand:

New Features
------------

### Browser upgrades

The [browser plugin][6] has received a lot of subtle upgrades that should make
it easier to use. We've removed some of the information that was not useful 99%
of the time, and added the ability to create new principals in the browser.


### Authentication system overhaul

The authentication system and backends got a new API, which allows for cleaner
implementation in many cases, and also adds the ability to run multiple
authentication backends cooperatively.

This allows the implementor to support HTTP Auth, as well as for example
OAuth2, or any custom schemes.


### Nearly all XML code got rewritten

Back in 2009 I first started experimenting with the idea of replacing all
[DOM][7] code with code with PHP's [XMLReader][8]/[XMLWriter][9]. 

Back then these api's were rather unstable and had a big number of problems.
In 2012 I started again, and since then have been working on a separate
sabre/dav branch to implement this.

After many hundreds of commits, it's finally done. The new xml system is based
on a new [sabre/xml][10] library and has made the xml code a lot more legible
and in some cases faster.

Furthermore, it will in the future allow us to make further optimizations that
were not possible before, due to the fact that this new system can read and
write XML from and to streams, whereas the DOM had no other option but to keep
objects in memory (which would become in some instances absolutely massive).


### `MKCOL` can now create new principals

If your backend has support for it, new principals can now be programmatically
created.


### Support for a "home"-like collection

We added a new collection type that can automatically create a "home"
directory for every principal, protected by ACL rules.


### Property storage can now store any complex XML property

Before, the [property storage][11] plugin was only able to store simple string
values for custom XML properties. This has now been changed to allow *any*
complex XML value to be stored, thanks to [sabre/xml][10].

### ChangeLog

A lot of smaller changes have been made since version 2.1. You can find more
details in the [ChangeLog][1]. Read from 2.2.0-alpha1 onwards, as most changes
have been made in the alpha versions.

Installation
------------

As always, the zip can be found on the [github releases page][2], but the
recommended installation method is using composer:

    composer require sabre/dav ~3.0.0

Upgrading
---------

A few backwards compatibility breaks have been made in this release.

If you are running a standard server, it's likely that you only have to run
the database upgrade script, but if you did any sort of customizations,
chances are that you need to make changes in your code to keep stuff running.

**Make a backup.** and then head to the [migration instructions][3] for 3.0.

Drop a line on the [mailing list][4] if you run into any issues, or
[get in touch with us][5] for our commercial support options.


Support status
--------------

Due to the 3.0 release, 2.1 now enters maintenance mode. This means that
version 2.1 of sabre/dav will be actively maintained for the next 12 months.

More information about previous versions and their support status can be found
on the [upgrade][12] page.

**Thanks as always!!!**

[1]: https://github.com/sabre-io/dav/blob/3.0.0/CHANGELOG.md
[2]: https://github.com/sabre-io/dav/releases
[3]: https://sabre.io/dav/upgrade/2.1-to-3.0/
[4]: https://groups.google.com/group/sabredav-discuss
[5]: /support/
[6]: /dav/browser-plugin/
[7]: https://php.net/manual/en/book.dom.php
[8]: https://php.net/manual/en/book.xmlreader.php
[9]: https://php.net/manual/en/book.xmlreader.php
[10]: /xml/
[11]: /dav/property-storage/
[12]: /dav/upgrading/
