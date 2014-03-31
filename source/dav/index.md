---
product: dav
title: sabre/dav
layout: default
---

sabre/dav is the most popular WebDAV framework for PHP. Use it to create
WebDAV, CalDAV and CardDAV servers.

sabre/dav is increasingly becoming the #1 choice for application service
providers who wish to add Cal- and CardDAV to support to their application.

sabre/dav supports a [wide range][1] of internet standards related to these
protocols. The most relevant are:

* WebDAV
* CalDAV
* CardDAV
* vCard 2.1, 3.0, 4.0 and jCard
* iCalendar 2.0 and jCal
* current-user-principal
* Extended MKCOL
* WebDAV-sync
* CardDAV directories
* CalDAV delegation
* CalDAV sharing

Check out our [Standard support][1] page for all the details.

Target audience
---------------

The primary target audience for sabre/dav is business and individuals with
a base-line of technical capabilities. The first and foremost target for
sabre/dav are developers.

If you don't have the in-house capability to deploy sabredav, we do provide
[commercial support][2].

History
-------

sabre/dav was started in 2007 by [Evert Pot][3] to scratch an itch. I needed
to bring data from the database, and expose it to the user as a filesystem.

Since that existing system was fully written in PHP, WebDAV seemed like the
obvious choice.

In 2010 CalDAV was added to the server, which really caused a solid usage
spike, allowing Evert to dedicated more time on it, and no longer just in
the evening.

In 2013 [fruux][4] took over the project, allowing more people to focus on it
and provide enterprise backing.

Sub-projects
------------

<dl>
    <dt><a href="{{site.url}}/http">sabre/http</a></dt>
    <dd>An OOP abstraction layer for the PHP server api.</dd>
</dl>
<dl>
    <dt><a href="{{site.url}}/vobject">sabre/vobject</a></dt>
    <dd>A library for parsing and manipulating vCard, iCalendar, jCard and jCal.</dd>
</dl>
<dl>
    <dt><a href="{{site.url}}/event">sabre/event</a></dt>
    <dd>Utilities for lightweight event-based programming in PHP.</dd>
</dl>

[1]: /dav/standards-support/
[2]: http://localhost:8000/support
[3]: http://evertpot.com/
[4]: https://fruux.com/
