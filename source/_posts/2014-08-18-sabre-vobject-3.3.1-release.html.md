---
title: sabre/vobject 3.3.1 release
product: vobject
sidebar: none
date: "2014-08-18T19:39:02+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.3.1.

Several bugs have been found in 3.3.0, all mostly related to the newly
introduced [iTip][2] functionality.

This release also adds a new feature that allows people to specify new
DATE-TIME values by passing PHP [DateTime][3] objects as such:

    $vevent->DTSTART = new DateTime('...');

This was already possible in a lot of other places, but somehow this was
missed for the 'magic property setter'.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.3.1, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.3.1"

[1]: https://github.com/sabre-io/vobject/blob/3.3.1/ChangeLog.md
[2]: /vobject/itip/
[3]: https://php.net/manual/en/class.datetime.php
