---
title: sabre/vobject 3.3.4 release
product: vobject
sidebar: none
date: "2014-11-19T22:56:30+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.4.

This release adds:

1. Converting `ANNIVERSARY` to `X-ABDATE` and `X-ANNIVERSARY` when converting
   between vCard 3.0 and 4.0.
2. Reference-timezone support to the recurrence iterator, free-busy generator,
   and `DATE-TIME` and `DATE` properties for dealing with all-day events and
   floating times.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.3.4, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.3.4"

Full changelog can be found on [Github][1].

[1]: https://github.com/sabre-io/vobject/blob/3.3.4/ChangeLog.md
