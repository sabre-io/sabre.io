---
title: sabre/vobject 4.1.0 released
product: vobject 
sidebar: none
date: "2016-04-06T20:56:03-04:00"
tags:
    - vobject 
    - release
---

We just released sabre/vobject 4.1.0. This release is fully compatible with
the 4.0.x series.

This release adds a `Sabre\VObject\PHPUnitAssertions` trait that, for now,
contains a `assertVObjectEqualsVObject()` function. This functions works
similar to PHPUnit's built-in `assertXmlStringEqualsXmlString()`, and can be
used by implementors to check if two iCalendar objects or vCards are identical
semantically.

It also contains a number of other fixes:

* When doing recurrence expansion, the first event now also have a
  `RECURRENCE-ID` property.
* Fixes a bug in processing iTip REPLYs to recurring events.
* Better error messages and improved validation in a number of areas.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

Full changelog can be found on [Github][1]

[1]: https://github.com/fruux/sabre-vobject/blob/4.1.0/CHANGELOG.md
[2]: https://github.com/fruux/sabre-vobject/releases
