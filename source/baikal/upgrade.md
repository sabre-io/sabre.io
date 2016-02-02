---
product: baikal 
title: Upgrading
layout: default
---

Upgrading from Baïkal 0.2.7 to 0.3.0
------------------------------------

To upgrade from Baïkal 0.2.7 to 0.3.0, follow the following steps:

1. Make a backup of your MySQL or SQLite database. This step is really important!
2. Make a backup of the `baikal` directory on your server, by creating a copy.
3. Grab the Baikal 0.3.0 zip file from [github][1].
4. Upload the contents of the zip file to the server, but make sure you do not
   overwrite the `Specific` directory. Everything else may be overwritten.
5. Open the administration panel on the server. Usually this is something like `http://dav.example.org/baikal/admin/`.
6. Follow the steps in the administration panel.

If you're having any problems with these steps at all, just [contact us][2].
We are happy to help you get throug this, and even do the upgrade for you in
case something went wrong along the way.

[1]: https://github.com/fruux/Baikal/releases/tag/0.3.0
[2]: https://github.com/fruux/Baikal/issues/new
