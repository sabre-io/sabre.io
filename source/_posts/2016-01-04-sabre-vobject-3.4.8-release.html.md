---
title: sabre/vobject 3.4.8 release
product: vobject
sidebar: none
date: "2016-01-04T14:47:59-05:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.4.8.

This version contains a small change related to iTIP messages. When we generate
a `CANCEL`, message the object now contains a `DTEND`.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.4.8, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.4"

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/sabre-io/vobject/blob/3.4.8/ChangeLog.md
