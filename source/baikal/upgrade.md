---
product: baikal 
title: Upgrading
layout: default
---

Upgrading Baïkal
-------------------------

To upgrade Baïkal, follow the following steps:

1. Make a backup of your MySQL or SQLite database. This step is really important!
2. Make a backup of the `baikal` directory on your server, by creating a copy.
3. Grab the latest Baïkal zip file from [GitHub][1].
   Make sure to use the release file with bundled dependencies, not the plain source code.
4. Upload the contents of the zip file to the server, but make sure you *do not*
   overwrite the `Specific` or `config` directories. Everything else may be overwritten.
   Keep the whole `Specific` and `config` directories intact. Baïkal needs all files, not just the database.
   Make sure that invisible files and folders (beginning with a dot ".") are also transferred.
5. Open the administration panel on the server. Usually this is something like `http://dav.example.org/baikal/html/admin/`.
6. Follow the steps in the administration panel.

If you're having any problems with these steps at all, just [contact us][2].
We are happy to help you get through this.

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

[1]: https://github.com/sabre-io/Baikal/releases
[2]: https://github.com/sabre-io/Baikal/issues/new?template=upgrading.md
