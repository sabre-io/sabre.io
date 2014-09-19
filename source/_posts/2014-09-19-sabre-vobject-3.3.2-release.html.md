---
title: sabre/vobject 3.3.2 release
product: vobject
sidebar: none
date: "2014-09-19T18:58:12+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.2.

Further in-depth testing of the [iTip][2] subsystem has revealed a _lot_ of
small edge-cases that weren't properly covered.

In addition, we now correctly decode `ATTACH` properties in iCalendar objects
that are specified as a URI, and fixed a few validator rules.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.3.2, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.3.2"

[1]: https://github.com/fruux/sabre-vobject/blob/3.3.2/ChangeLog.md
[2]: /vobject/itip/
