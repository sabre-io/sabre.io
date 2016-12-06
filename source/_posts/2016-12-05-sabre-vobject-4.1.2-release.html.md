---
title: sabre/vobject 4.1.2 released
product: vobject 
sidebar: none
date: "2016-12-05T23:19:17-05:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 4.1.2.

This release adds a few new features, and fixes several issues:

1. Support for `BYWEEKDAY` and `BYWEEKNO` recurrences when `FREQ=YEARLY`.
2. Support for more Windows and Outlook 365 timezone ID's.
3. Fixing a problem with all-day events in the recurrence iterator.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

Full changelog can be found on [Github][1]

[1]: https://github.com/fruux/sabre-vobject/blob/4.1.2/CHANGELOG.md
