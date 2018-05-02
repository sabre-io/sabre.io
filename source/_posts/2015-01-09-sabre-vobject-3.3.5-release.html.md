---
title: sabre/vobject 3.3.5 release
product: vobject
sidebar: none
date: "2015-01-09T01:11:06+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.5.

This release fixed a number of bugs, including:

1. Bugs related to iTip and the `SCHEDULE-STATUS` property.
2. The parser can now read files that contain a UTF-8 BOM.
3. jCal serialization of floating `DATE-TIME` properties.
4. A bug related to converting `X-ABDATE` to `ANNIVERSARY` in the
   vCardConverter.
5. Two new modes for the validator, allowing you to validate vCards and
   iCalendar objects specifically in the context of CalDAV and CardDAV servers.


Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.3.5, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.3.5"

Full changelog can be found on [Github][1].

[1]: https://github.com/sabre-io/vobject/blob/3.3.5/ChangeLog.md
