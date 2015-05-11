---
title: sabre/katana
product: katana
layout: default
---

This document explains how to install sabre/katana. We currently officially
support two main installation methods:

* [from a ZIP archive](#install-from-zip)
* [from source](#install-from-source)

Unless you are a developer, you will most likely want to follow the
installation instructions for the ZIP archive.

Requirements
------------

* PHP 5.5 and up.
* MySQL or SQLite database. MySQL is _highly_ recommended.
* Webserver running on Linux or Mac.


Install from ZIP
----------------

1. Download the latest ZIP archive from [GitHub][1].
2. Unzip the archive, and place all the contents into a location that's
   accessible through a webserver.
3. Navigate to the installer. If you downloaded the ZIP archive and placed it
   in a directory called `/katana`, this means that you should access it via
   `http://yourserver/katana/public/install.php`, but bear in mind that this
   might be different for you.
4. Follow the instructions in the browser.


From source
-----------

If you are a developer, and you want to install sabre/katana via Git, make
sure you've cloned the repository located at <http://github.com/fruux/sabre-katana/>

After that, you'll need:

* [Composer][2].
* [NPM][3].
* [Bower][4].

to retrieve the various packages that are used in sabre/katana.

If you have all these package managers, run:

    make install

After that, the installation should be ready to go. You can then run the
installer via the web interface (in `public/install.php`) or via the
command-line:

    ./bin/katana install

[1]: https://github.com/fruux/sabre-katana/releases/
[2]: http://getcomposer.org/
[3]: http://www.npmjs.com
[4]: http://bower.io
