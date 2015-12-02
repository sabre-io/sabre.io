---
product: vobject
layout: default
title: Upgrading from vobject 3.x to 4.x
---

VObject 4 got a number of new features, as well as a few backwards compability
changes.

While VObject 4 has a lot of improvements, the changes are mostly incremental.
The upgrade from VObject 2 to 3 was much bigger overhaul, but in this release
the changes we made are smaller and more localized.

This document is split up in two major segments: "New features" and "Backwards
compatibility breaks". We're starting with the fun stuff.

New features
-------------

### PHP 7 support

This version of vobject support PHP 7. We also dropped support for PHP versions
before 5.5. If you are running an older PHP version, we will continue to
maintain vObject 3.x. But really, you should upgrade!


### Support for different input encodings

By default VObject always assumed everything is UTF-8. This is a fair
assumption for object sent via CalDAV and CardDAV and is also the only valid
encoding for vCard 4, jCard and jCal.

However, iCalendar 2.0, vCard 3.0 and vCard 2.1 might also be encoded using
other charsets. In the case of vCard 2.1, individual lines in the vCard can
even have specific encodings.

If your data uses a different encoding than UTF-8, you can now specify this.
sabre/vobject will then automatically convert everything to UTF-8 during
decoding.

Example:

    $vcard = Sabre\VObject\Reader::read($data, 0, 'ISO-8859-1');

Currently only the following encodings are supported:

* `UTF-8` (default)
* `ISO-8859-1` (also known as latin-1)
* `Windows-1252` (also known as cp1252)

Those encodings are (so far) the only one the author has seen in the wild,
but if you have a different encoding you need support for, just
[open a ticket][1] with a sample file.


### Support for xCal / xCard

After adding support for jCal and jCard, we now also have support for
[xCal][rfc6321] and [xCard][rfc6351]. These two formats are the XML
representation of iCalendar and vCard.

Reading these formats is pretty simple:

    $vcalendar = Sabre\VObject\Reader::readXml('<?xml version=".....'?>);

Writing works as follows:

    $xml = Sabre\VObject\Writer::writeXml($vCalendar);

This feature was contributed by [Ivan Enderlin][2].


### Added a `BirthdayCalendarGenerator`

This new component can take a list of VCARD objects, and automatically
generate a VCALENDAR with all the birthdays.

For usage information, check out the source:

<https://github.com/fruux/sabre-vobject/blob/master/lib/BirthdayCalendarGenerator.php>

This feature was contributed by [Dominik Tobschall][3].

### Speed improvements

We optimized a number of common access patterns in sabre/vobject, and in
particular are doing less looping and better indexing of objects.

Especially manipulating objects can be up to 40% faster than before.


### Added a `destroy()` method

sabre/vobject components are a fairly complicated data-structure, and they also
contain circular references. This unfortunately means that they are often not
garbage collected by PHP.

If you are completely done with a vCalendar object, you can now call the
`destroy()` method on it. This method will remove a lot of circular
references, and enough so that PHP can can easily clean up the object.

Especially if you are doing processing on large or many objects, these memory
leaks can quickly grow out of control. Calling `destroy(0` should result in
massive drops in memory usage.


### Full support for VAVAILABILITY

[VAVAILABILITY][4] is an upcoming standard that allows people to specify when they
are available. It provides more features that VFREEBUSY, as it allows people
to specify rules such as "I'm available for meetings every weekday between 9
and 5".

VObject 4 provides a parsers for these, and the FreeBusyGenerator can now
generate a VFREEBUSY object based on existing calendar events + a
VAVAILABILITY specification. VAVAILABILITY is already supported by a number
of calendar applications.


### Added a utility for merging duplicate vcards on the command line.

If you have a large file with lots of VCARD objects, you can use this tool to
find duplicates and merge them together.

The tool finds duplicates solely using the `FN` property. This means if you
have multiple contacts with the exact same name, they will be merged.

Run the command for usage instructions:

`./bin/mergeduplicates.php`


### Smaller stuff / bugfixes.

* All components and properties now implement PHP 5.5's `JsonSerializable`
  interface, so you can just drop them in `json_encode()`!
* When expanding events, we now also expand events that use `RDATE`.
* Timezone is now considered for `RDATE`.
* We now always add `VALUE=URI` to `PHOTO` and `URL` properties by default.
  This was done to work around bugs in OS X Addressbook (discovered in OS X
  10.8) and OS X calendar (discovered in OS X 10.11).
* Recurrence iterators now stop recurring after 3500 iterations by default.
* `isInTimeRange()` now behaves better for floating dates/times. 
* Parser is a bit more robust.
* Everywhere a `DateTime` was previously accepted, we now also accept
  `DateTimeImmutable`.
* Support for parsing `CALADURI`, `SOURCE`, `MEMBER` and `RELATED` properties
  in vCards.
* Added a `Settings` object where some global VObject behavior may be changed.
  

Backwards compatibility breaks
------------------------------

### PHP 5.5 is the minimum version

As mentioned before, the minimum PHP version has been changed from 5.3 to 5.4.
If you are running unsupported PHP versions, you can still use sabre/vobject 3,
which we still support.


### Using `DateTimeImmutable` instead of `DateTime`.

PHP added a new object for dealing with dates and times: `DateTimeImmutable`.
Starting from sabre/vobject 4, we now return `DateTimeImmutable` _everywhere_
instead of `DateTime`.

This can unfortunately lead to subtle bugs, as before you might have been able
to make modifications to a `DateTime` object you received from a function.

Non-exhaustive list of functions that now return `DateTimeImmutable`:

    Sabre\VObject\Component\VAlarm::getEffectiveTriggerTime()
    Sabre\VObject\DateTimeParser::parseDateTime()
    Sabre\VObject\DateTimeParser::parseDate()
    Sabre\VObject\DateTimeParser::parse()
    Sabre\VObject\Property\ICalendar\DateTime::getDateTime()
    Sabre\VObject\Property\ICalendar\DateTime::getDateTimes()
    Sabre\VObject\Property\VCard\DateAndOrTime::getDateTime()
    Sabre\VObject\Recur\EventIterator::current()
    Sabre\VObject\Recur\EventIterator::getDtStart()
    Sabre\VObject\Recur\EventIterator::getDtEnd()

### `Component::$children` is gone

In sabre/vobject 3 every (vcard/vcalendar/vevent/etc..) component had a public
`$children` property that contained a simple array with all the
properties/components inside of the component.

The simple array made everything quite slow, and in order to optimize common
operations we had to remove it.

If you're still looking for a flat list of all the children properties/components,
call the `children()` method instead.

Effectively this changes your code from:

    $children = $vevent->children;

to:

    $children = $vevent->children();


### More specific exceptions

A lot of the VObject functions work in two stages. There's an initial parse
stage, in which we only validate the correctness of the overall syntax of the
source, and a manipulation phase.

Some invalid data (such as an invalid date in `DTSTART`) will not throw an error
during parsing, but only when you actually do something related to dates.

Before, we would often throw either `InvalidArgumentException` or
`LogicException` when we hit invalid data. In vObject 4 we consistently always
throw `Sabre\VObject\InvalidDataException`.

Note that any errors during the parsing phase will still throw
`Sabre\VObject\ParseException`.


### RecurrenceIterator now stops automatically at 3500 iterations

In case a user created a recurring event, and traversing that event resulted
in more than 3500 instances, we'll now automatically throw
`Sabre\VObject\Recur\MaxInstancesExceededException`. This acts as a protection
against some denial of service attacks.

To change this number, change the following static property:

    Sabre\VObject\Recur\EventIterator::$maxInstances = 1000; 

Set it to -1 to completely disable this check.


### Changes to expanding events

If you ever expanded a recurring events in a calendar, this API has now
changed. The `expand` method no longer updates the calendar in-place, but
rather returns a new copy of the calendar with the events expanded.

The `expand` method no longer makes changes to the calenar on which it's
called on.

This means that if your code previously looked like this:

    $vcalendar->expand(new DateTime('...'), new DateTime('...'));

This must be changed to:

    $vcalendar = $vcalendar->expand(new DateTime('...'), new DateTime('...'));

### Renamed two classes for PHP 7 support.

vObject 3 had the following two classes:

    Sabre\VObject\Property\Float
    Sabre\VObject\Property\Integer

In PHP 7 those are no longer valid class names. We've renamed them to:

    Sabre\VObject\Property\FloatValue
    Sabre\VObject\Property\IntegerValue


### `Sabre\VObject\RecurrenceIterator` is removed

This object was already deprecated, but in version 4 it's removed. Simply use
`Sabre\VObject\Recur\EventIterator` instead. It has an identical interface.


### `Sabre\VObject\Component::remove` no longer returns the removed item.

The `remove()` function, which exists on every component used to return the
removed item. In version 4 this is no longer the case.




[1]: https://github.com/fruux/sabre-vobject/issues "sabre/vobject issues"
[2]: http://mnt.io/ "Ivan Enderlin"
[3]: http://tobschall.de/ "Dominik Tobschall"
[4]: https://tools.ietf.org/html/draft-daboo-calendar-availability "Calendar Availability"

[rfc6351]: https://tools.ietf.org/html/rfc6351 "xCard: vCard XML Representation"
[rfc6321]: https://tools.ietf.org/html/rfc6321 "xCal: The XML Format for iCalendar"
