---
title: sabre/vobject 4 released
product: dav
sidebar: none
date: "2015-12-12T00:10:01-05:00"
tags:
    - event
    - vobject
    - release
    - xcal
    - xcard
    - vavailability
---

We just released sabre/vobject 4. This is a new major version, and comes with a
number of new features and also BC breaking changes. The API is largely the
same, but there are a few subtle differences.

### New feature highlights

* Support for PHP 7.
* Requires PHP 5.5.
* Support for [xCal and xCard][2], which are XML representations of iCalendar
  and vCard.  
* Added a 'BirthdayCalendarGenerator'. Give it a list of vCards, and it will
  create an iCalendar object with birthdays.
* Lots of speed and memory improvements.  
* Support for the new `VAVAILABILITY` iCalendar component.
* Added a command-line utility to merge duplicate vcards.
* Using `DateTimeImmutable` everywhere we used `DateTime`.
* Denial of service-protection in the RecurrenceIterator.
* Better `RDATE` support.

The full changelog can be found on [Github][1]

### Installing

Simply run:

    composer require sabre/vobject ^4.0

### Updating

For more details about these changes and a detailed list of all backwards-
compatibility breaking changes, read the [upgrade][3] document.


[1]: https://github.com/sabre-io/vobject/blob/4.0.0/CHANGELOG.md
[2]: /vobject/xcal_xcard/
[3]: /vobject/upgrade_to_4/
