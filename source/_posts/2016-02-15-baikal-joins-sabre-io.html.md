---
title: Baïkal joins sabre.io
product: baikal 
sidebar: none
date: "2016-02-15T16:28:57-05:00"
tags:
    - baikal 
---

<img src="/img/baikal.png" style="width: 100%; max-width: 300px; float: right; padding: 10px" />

For a long time Baïkal has been one of the most popular implementations of
sabre/dav. Baïkal fills one of the biggest gaps that out-of-the-box sabre/dav
has: an easy to use installer and admin interface. It's the best choice if
you're looking for a light-weight caldav/carddav server.

However, since a while development for this project has stagnated a little bit.
The last release (0.2.7) was from January 2014. The result of this was that
many users of Baïkal were on an older version of sabre/dav and there were quite
a bit of open support tickets on Github.

A lot of this had to do with the development of Baïkal 2. This version was
going to be a complete rewrite based on Symfony components and React. While
much of the development focus had been on that new version, users of the
existing system did not get all the attention they needed.

So we've had a talk with the lead maintainer for Baïkal (Jérôme Schneider from
[Netgusto][1]), and proposed to bring Baïkal under the 'sabre.io' umbrella of
projects. What this means in practice is that:

* We're moving the existing website and documentation over from
  baikal-server.com to sabre.io.
* We're now helping with support, and closed over a hundred tickets already.
* We're taking over maintenance of Baikal 0.x, and today we're releasing 0.3.1.
* Eventually we will release a 1.0 version of Baikal, unless Baikal 2 is ready
  first.

Baïkal 0.3.1
------------

Baïkal 0.3.1 is now the recommended version of Baïkal. This release fixes the
most reported issues with Baikal, and also:

* Upgrades sabre/dav from version 1.8 to 3.1.
* Supports PHP 7.
* Makes the minimum PHP version 5.5.
* Adds support for calendar/addressbook export.
* Adds support for WebDAV-Sync.

Effective immediately, this is the only supported Baïkal version.

We will also continue to make fixes and improvements in this branch of
development, as they come up.

Downloads are now distributed via [Github][2]. If you are upgrading from
version 0.2.7, you can find the upgrade instructions [here][3].

Relationship between Baïkal, Baïkal 2 & sabre/katana
----------------------------------------------------

For those following this project, you might also be aware that we've already
had a project with very similar goals on sabre.io called [katana][4].
So with Baïkal, Baïkal 2 and sabre/katana combined, there are effectively
three active projects that all overlap in the use-case they address.

We haven't fully decided yet what route to take with these. Eventually we would
like to end up with a single active project that addresses this main use-case.
So down the road we'll try to find some way to merge these projects and combine
the best parts of all of them. Baïkal 2 in particular has a beautiful
interface, and sabre/katana had strong benefits because its goal was to make it
fully run as a javascript fat client, allowing it to be used for other
sabre/dav implementations such as Owncloud, and even non-sabre/dav
installations.

The biggest factor in development of the katana project is simply lack of
funding, which means that we can't afford to spend time on it to bring it to a
1.0. This is not unlike Baïkal and Baïkal 2, which has for a large part been a
"labor of love" by it's author Jérôme Schneider.

So what we at sabre.io and fruux commit to is:

* Continuous maintenance and support for Baikal 0.x.
* Eventually release this as Baikal 1.0.

As for sabre/katana and Baïkal 2... It's hard to make promises. They are done
when they are done, and we'll keep a look at for companies interested in
funding or sponsoring development of these. Also, we're looking for more
maintainers / developers for these. If you're interested, drop us a line! Any
level of experience welcome.

[1]: http://netgusto.com/
[2]: https://github.com/fruux/Baikal/releases
[3]: /baikal/upgrade/
[4]: /katana/
