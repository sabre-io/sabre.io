---
product: baikal 
title: Upgrading
layout: default
---

Upgrading from Baïkal 0.2.7 to 0.3.X
------------------------------------

To upgrade from Baïkal 0.2.7 to 0.3.X, follow the following steps:

1. Make a backup of your MySQL or SQLite database. This step is really important!
2. Make a backup of the `baikal` directory on your server, by creating a copy.
3. Grab the latest Baikal 0.3.X zip file from [github][1].
4. Upload the contents of the zip file to the server, but make sure you *do not*
   overwrite the `Specific` directory. Everything else may be overwritten.
5. Create an empty file named `ENABLE_INSTALL` in the `Specific` directory. On
   a command-line you might be able to do this with
   `touch Specific/ENABLE_INSTALL`.
6. Open the administration panel on the server. Usually this is something like `http://dav.example.org/baikal/admin/`.
7. Follow the steps in the administration panel.

If you're having any problems with these steps at all, just [contact us][2].
We are happy to help you get throug this, and even do the upgrade for you in
case something went wrong along the way.

**Please note:** If you used the `flat` package in the past, this no longer
exists. You can upgrade to this version no problem, however, the end-points for
syncing changed so you might need to update these.

If it was before something like:

    http://example.org/baikal/cal.php

Then it's now:

    http://example.org/baikal/html/dav.php

So two things changed:

1. `cal.php`, `card.php` moved into the `html/` directory.
2. We added `dav.php`. `cal.php` and `card.php` still exist in the `html/`
   directory but will be removed in a future version. `dav.php` is an
   endpoint for _both_ caldav and carddav combined.

So if you have access to your webserver/vhost configuration, you actually only
need to expose `html/` to the world. Everything else is best kept hidden.

[1]: https://github.com/fruux/Baikal/releases
[2]: https://github.com/fruux/Baikal/issues/new
