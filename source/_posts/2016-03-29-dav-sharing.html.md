---
title: CalDAV, CardDAV and WebDAV sharing
product: dav 
sidebar: none
date: "2016-03-29T20:13:07-04:00"
tags:
    - dav
    - sharing
---

CalDAV/CardDAV sharing is something [we've worked on][1] for quite some time.
Our goal is to have out of the box CalDAV sharing working in the next sabre/dav
version

It's taking a long time to implement, because we're not just writing the code,
we're also writing the standard.

These are the current drafts:

* [WebDAV notifications][3].
* [WebDAV resource sharing][2].
* [CalDAV sharing][4].

Today I wrote an article on my own blog about how it works and the current
status. [Read it here][5].

We'll be at CalConnect 36 in Hong Kong next month to discuss this more. If
you're in the area and want to discuss calendaring or sabre/dav, drop us a line!

[1]: https://github.com/sabre-io/dav/pull/696
[2]: https://tools.ietf.org/html/draft-pot-webdav-resource-sharing
[3]: https://tools.ietf.org/html/draft-pot-webdav-notifications
[4]: https://tools.ietf.org/html/draft-pot-caldav-sharing
[5]: https://evertpot.com/webdav-caldav-carddav-sharing/
