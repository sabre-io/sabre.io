---
title: sabre/vobject 4.0.2 release
product: vobject
sidebar: none
date: "2016-01-11T12:43:58-05:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 4.0.2.

This version fixes a regression introduced in 4.0.0. When parsing objects with
a `CHARSET` parameter, in documents that do not support `CHARSET`, which is
everything except vCard 2.1, the parser would throw an error for unrecognized
values.

If you are parsing iCalendar or vCards, upgrading is highly recommended.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 4.0.2, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~4.0.2"

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/fruux/sabre-vobject/blob/4.0.2/CHANGELOG.md
