---
title: sabre/vobject 4.0.1 release
product: vobject
sidebar: none
date: "2016-01-04T16:40:55-05:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 4.0.1.

This version contains a small change related to ITIP messages. When we generate
a `CANCEL`, message the object now contains a `DTEND`.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 4.0.1, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~4.0.1"

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/fruux/sabre-vobject/blob/4.0.1/CHANGELOG.md
