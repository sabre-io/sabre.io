---
title: sabre/vobject 4.0.3 released
product: vobject 
sidebar: none
date: "2016-03-12T19:03:17-05:00"
tags:
    - vobject 
    - release
---

We just released sabre/vobject 4.0.3. This release contains the following
changes:

1. Added `VCard::getByType()`, to quickly get a vcard property with a specific
   value for `TYPE`.
2. `UNTIL` and `COUNT` were not correctly encoded in the jCal format.
3. `RRULE` now has more validation and repair rules.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

Full changelog can be found on [Github][1]

[1]: https://github.com/fruux/sabre-vobject/blob/4.0.3/CHANGELOG.md
[2]: https://github.com/fruux/sabre-vobject/releases
