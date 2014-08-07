---
title: sabre/vobject 3.3.0 release
product: vobject
sidebar: none
date: "2014-08-07T18:50:05+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.0!

This release has a few new features, but also changes a few things. For most
people the upgrade should be seamless though.

Changes
-------

### Better RRULE parser

We now have much better support for `RRULE`, and especially exceptions to
recurrences. This solved several bugs that have been outstanding for quite
some time.

We now also support `RDATE`.

One change is that the old `Sabre\VObject\RecurrenceIterator` is now renamed
to `Sabre\VObject\Recur\EventIterator`. The old class still exists, but will
be removed in a future version.

Some more info about this feature [here][2].


### iTip support

VObject now supports generating and parsing [iTip][3] messages. iTip messages
are a type of iCalendar object that are used for things like invites, replies
and cancellations.

More info about this feature on the [iTip page][3].


### Switched to PSR-4

The directory structure of the VObject library changed. Everything that was
previously in `lib/Sabre/VObject` is now moved to `lib/`.

If you are using composer you don't have to change a thing, but if you
manually wrote an autoloader, you may have to make a change to accomodate for
this.

We also removed `lib/Sabre/VObject/includes.php`.

### Changelog

Full changelog can be found on [Github][1]


Upgrading
---------

To update your sabre/vobject, edit composer.json to make sure that it includes
a line like this:

    "sabre/vobject" : "~3.3.0"

[1]: https://github.com/fruux/sabre-vobject/blob/3.3.0/ChangeLog.md
[2]: /vobject/recurrence
[3]: /vobject/itip
