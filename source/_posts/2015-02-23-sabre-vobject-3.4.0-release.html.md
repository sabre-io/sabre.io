---
title: sabre/vobject 3.4.0 release
product: vobject
sidebar: none
date: "2015-02-23T21:36:22+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.4.0. This release has a number of
improvements and bugfixes.

* Recurrence expansion and parsing is now a *lot* faster on big calendars.
  Our test iCalendar file was about 5MB large with an unusual high amount
  of recurrence rules. We got about a 1900% increase in speed. Most
  real-world calendars will not be as large, but should still benefit from
  this quite a bit.
* We're not supporting parsing and validating `VAVAILABILITY` components,
  which is a new iCalendar component that may become an internet standard,
  but is currently still a [draft][2]. In the future we'll also add support
  for this in the freebusy generator, which will make it useful for sabre/dav
  users.
* Updated to the latest timezone information.
* Several other bugfixes.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.4, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.4"

Version 3.4.0 is 100% compatbile with vobject 3.3.*

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/fruux/sabre-vobject/blob/3.4.0/ChangeLog.md
[2]: https://tools.ietf.org/html/draft-daboo-calendar-availability
