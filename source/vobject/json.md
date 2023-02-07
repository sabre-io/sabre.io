---
title: jCard and jCal
layout: default
product: vobject
---

Since version 3.1, there's now native support for parsing and generating the
[jCal][2] and [jCard][1] formats.

These new formats use [JSON][3] to serialize vCard and iCalendar. It is
possible to exactly map iCalendar and vCard to jCal and jCard, and therefore
you can convert back and forward, without any data-loss.

Benefits
--------

The exact grammar of both vCard and iCalendar is very vague, not really shared
with other common formats, changes over time, complex and a lot of incorrect
implementations exist.

jCard and jCal do not have this problem. It's our opinion that these two
formats represent the future of this data, and we'd highly recommend people
using this, and only using vCard / iCalendar for backwards compatibility
purposes.

It's also often faster to parse and generate, and in PHP this is especially
true.


Generating a jCal or jCard object
---------------------------------

Any time you have a reference to a `VCARD` or `VCALENDAR` object in vobject,
you can simply call `->jsonSerialize()` to get a representation suitable for
json.

Here's an example of parsing an iCalendar object, and then outputting it as
a jCal object:

    $vcal = \Sabre\VObject\Reader::read(fopen('my_calendar.ics', 'r'));
    echo json_encode($vcal->jsonSerialize());

This feature was added in sabre/vobject 3.0.

Parsing jCal and jCard
----------------------

To parse a jCard or jCal object, use the following snippet:

    $input = 'jcard.json';
    $jCard = VObject\Reader::readJson(fopen('jcard.json', 'r'));

You can pass either a JSON string, a readable stream, or an array if you
already called `json_decode` on the input.

This feature was added in sabre/vobject 3.1.


[1]: https://tools.ietf.org/html/rfc7095
[2]: https://tools.ietf.org/html/rfc7265
[3]: https://www.json.org/
