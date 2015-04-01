---
title: Upgrading SabreDAV
layout: default
---

Upgrading a major version? Read the upgrade instructions here:

* [0.8.x to 0.9.x](/dav/upgrade/0.8-to-0.9)
* [1.0.x to 1.2.x](/dav/upgrade/1.0-to-1.2)
* [1.2.x to 1.3.x](/dav/upgrade/1.2-to-1.3)
* [1.3.x to 1.4.x](/dav/upgrade/1.3-to-1.4)
* [1.4.x to 1.5.x](/dav/upgrade/1.4-to-1.5)
* [1.5.x to 1.6.x](/dav/upgrade/1.5-to-1.6)
* [1.6.x to 1.7.x](/dav/upgrade/1.6-to-1.7)
* [1.7.x to 1.8.x](/dav/upgrade/1.7-to-1.8)
* [1.8.x to 2.0.x](/dav/upgrade/1.8-to-2.0)
* [2.0.x to 2.1.x](/dav/upgrade/2.0-to-2.1)
* [2.1.x to 2.2.x](/dav/upgrade/2.1-to-2.2)

Support length
--------------

After the release of a new major SabreDAV (for example, `1.8.0`), we will
promise to support the previous version `1.7.*` for at least 12 months.

Currently and previously supported versions:

| SabreDAV version | PHP Version | First stable release | End of support      |
| ---------------- | ----------- | -------------------- | ------------------- |
| 1.2              | 5.2         | May 2010             | October 2011 (EOL)  |
| 1.3              | 5.2         | October 2010         | June 2012 (EOL)     |
| 1.4              | 5.2         | February 2011        | November 2012 (EOL) |
| 1.5              | 5.2         | August 2011          | February 2013 (EOL) |
| 1.6              | 5.3         | February 2012        | November 2013 (EOL) |
| 1.7              | 5.3         | October 2012         | July 2014 (EOL)     |
| 1.8              | 5.3         | November 2012        | May 2015            |
| 2.0              | 5.4         | May 2014             | November 2015       |
| 2.1              | 5.4         | November 2014        |                     |
| 2.2              | 5.5         | ????                 |                     |

Versioning scheme
-----------------

SabreDAV uses three digits for versions. `x.y.z`.

The first part, `x`, is reserved for major overhauls of SabreDAV.

The `y` part is also for fairly large releases. We try to have one or two of
these per year, but this fluctuates.

The `z` is reserved for minor upgrades.

If you are upgrading from a version, to a version that only changes the last
digit, it should always be safe to do so.

To do this with composer, just run:

    composer update sabre/dav

This should automatically do all the work. This should be 100% risk free,
except in cases where we are fixing a major security issue, and we are not
able to do so, without breaking backwards compatibility.

This means an upgrade from `2.1.2` to `2.1.3` is always safe. Upgrading from
`2.0.6` to `2.1.0` is not.

For versions where we are changing `x` or `y`, we almost always want to break
backwards compatibility in some areas. Depending on what features you are
using in SabreDAV you may or may not be affected by this.

Alpha and beta versions
-----------------------

Alpha and beta versions always have the word 'alpha' or 'beta' in them. In
alpha versions it is highly likely that we are not done yet, and will still
want to make changes.

Beta versions _should_ not get any BC-breaking changes, but they still may.

