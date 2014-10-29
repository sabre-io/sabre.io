---
title: sabre/vobject 3.3.3 release
product: vobject
sidebar: none
date: "2014-10-09T16:15:37+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.3.

This release has additional fixes and improvements for the [iTip][2]
subsystem.

This release also works around a PHP bug that would otherwise spam your php
error log file with 'invalid timezone' exceptions and has support for the
"Line Islands Standard Time" timezone coming from Microsoft products.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.3.3, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.3.3"

[1]: https://github.com/fruux/sabre-vobject/blob/3.3.3/ChangeLog.md
[2]: /vobject/itip/
