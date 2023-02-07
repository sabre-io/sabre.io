---
title: xCal and xCard 
layout: default
product: vobject
---

Since version 4.0, there's now native support for parsing and generating the
[xCal][2] and [xCard][1] formats.

These formats use XML to serialize vCard and iCalendar. It is
possible to exactly map iCalendar and vCard to jCal and jCard, and therefore
you can convert back and forward, without any data-loss.


Generating a xCal or xCard object
---------------------------------

Any time you have a reference to a `VCARD` or `VCALENDAR` object in vobject,
simply use the `Writer` object to turn it into XML.

Here's an example of parsing an iCalendar object, and then outputting it as
a xCal object:

    $vcal = \Sabre\VObject\Reader::read(fopen('my_calendar.ics', 'r'));
    echo \Sabre\VObject\Writer::writeXml($vcal);


Parsing xCal and xCard
----------------------

To parse a xCard or xCal object, use the following snippet:

    $input = 'xcard.xml';
    $xCard = VObject\Reader::readXml(fopen($input, 'r'));

You can pass either an XML string or a readable stream.

[1]: https://tools.ietf.org/html/rfc6351 "xCard: vCard XML Representation"
[2]: https://tools.ietf.org/html/rfc6321 "xCal: The XML Format for iCalendar"
