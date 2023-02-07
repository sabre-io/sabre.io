---
title: Deprecating sabre/dav 1.8
product: dav 
sidebar: none
date: "2015-06-01T13:48:25-04:00"
tags:
    - dav
    - vobject
    - support
    - deprecation
---

Our versioning scheme from sabre/dav dictates that we stop support for a
version of a package, 12 months after the next major version was released.

In ideal circumstances this means you have the full 12 months to do the
upgrade.

Today marks that date for sabre/dav 1.8, as well as sabre/vobject 2.


What this means
---------------

* We will no longer do new releases for these versions.
* We will no longer accept bug reports for these versions. We might make an
  exception for serious security issues.
* We will no longer provide support information for people running on these
  versions.
* It also marks the end of the last sabre/dav to support PHP 5.3.
* However, we will still offer [paid support][1] for these versions, if you
  are truly stuck in the past.


Links
-----

* [Full list of supported sabre/dav versions and their obsoletion schedule][2].
* [Upgrading from sabre/dav 1.8 to 2.0][3].
* [Upgrading from sabre/dav 2.0 to 2.1][4].
* [Upgrading from sabre/vobject 2.x to 3.x][5].


Some stats
----------

* sabre/dav 1.8 was first released November 8th, 2012.
* The biggest change was the switch to PHP namespaces from the old prefix-format.
* There were a total of 12 releases, averaging 0.63 releases per month.

[1]: https://sabre.io/support/
[2]: https://sabre.io/dav/upgrading/
[3]: https://sabre.io/dav/upgrade/1.8-to-2.0/
[4]: https://sabre.io/dav/upgrade/2.0-to-2.1/
[5]: https://sabre.io/vobject/upgrade/
