---
title: Development goals
product: katana
layout: default
---

While [sabre/dav](/dav) has obtained a decent marketshare for CardDAV, CalDAV, and WebDAV
servers, traditionally it's always been intended to be a development library.

Because of this goal, it always had a very high barrier to entry. We want to
solve this problem and bring it to a bigger market with sabre/katana.

sabre/katana will provide two core features:

1. An installer.
2. An admin interface.

It's our goal to make the admin interface an independent component, so it can
also be used for any other sabre/dav server.


Installer design goals
----------------------

The installer needs to help with getting people started getting their server
up and running. Traditionally it was only ever possible to set up sabre/dav
by copying files, and you were even forced to manually run SQL queries.

The installer will now walk you through the steps, in a way so that it's
doable on people just having access to a shared host with (god forbid)
something like an FTP account.


Admin interface
---------------

We will also add an admin interface. This admin interface should be seperable
from the rest of the package.

* The admin interface should be 100% client side. PHP must not be used.
* It should be possible to deploy an admin interface on a static host, such
  as S3.
* The admin interface should be able to communicate with *any* sabre/dav
  server.
* The admin interface allows the admin to:
  * Manage users.
  * Manage address books.
  * Manage calendars.
  * Manage files.
* All of these management operations will be done via publicly documented
  standard sabre/dav APIs. If you use sabre/dav, you can implement the
  relevant API and take advantage.
* The admin interface should automatically hide features that are not
  available on the server or disabled via access control.
* The admin interface should show an overview of features that are and are not
  available on the server, so users know what they are missing.

Post 1.0 features:

* It should also be able to check basic sabre/dav version information and
  report vulnerabilities.
* Work in a "non-admin" mode, so users can manage their own calendars even if
  they don't have admin-related features.
* It should be tested with some non-sabre/dav-based servers.
