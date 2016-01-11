---
title: sabre/vobject 3.4.9 and 3.5.0 release
product: vobject
sidebar: none
date: "2016-01-11T13:39:49-05:00"
tags:
    - vobject
    - release
---

In a reversal of an earlier statement, we're releasing a sabre/vobject 3.x
version with PHP 7 support.

We just release two new versions of the sabre/vobject package; `3.4.9` and
`3.5.0`.  `3.4.9` is identical to `3.4.8` but now explictly forbids being
installed on PHP 7, via composer.json.

`3.5.0` introduces two differences:

1. PHP 7 _is_ supported.
2. Two classes have been renamed. `Sabre\VObject\Property\Float` is now
   `Sabre\VObject\Property\FloatValue` and `Sabre\VObject\Property\Integer`
   is now called `Sabre\VObject\Property\IntegerValue`.

For most people the new class names will have 0 effect on your code. Almost
everyone should just be able to upgrade from 3.4.x to 3.5.0 without any
modifications.

The reason we've done this is due to some external pressure of sabre/* users,
who argued that it's not good that there's not a single sabre/vobject or sabre/dav
package that supports _both_ PHP 5.4 and PHP 7. Thankfully this change is small
enough that it's relatively low impact.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.5.0, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "^3.5.0"

Because the difference is so minor, in the future we'll only maintain the 3.5
(and 4.0) branch of vobject, and effectively drop support for 3.4. If this
concerns you, drop me a line as maybe we can help.

The `3.4.9` tag therefore mainly exist as an indicator to people who have a
composer dependency targetting `3.4.*` with composer and are attempting to
use PHP7, or people who have a rather complex dependency tree.

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/fruux/sabre-vobject/blob/3.5.0/CHANGELOG.md
