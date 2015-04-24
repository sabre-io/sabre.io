---
title: sabre/katana
product: katana
layout: default
---

To update sabre/katana, you have two options.

In your browser
---------------

**under development** (sorry, we are working hard on it).

In your terminal
----------------

First solution is **manual** but more common. It requires a ZIP archive.
Download the latest versions with the following command:

    bin/katana update --fetch-zip

You will find the archives in the `data/share/update/` directory. To
finally update sabre/katana, simply run:

    unzip -u data/share/update/katana_vx.y.z.zip -d .

Second solution is **automatic** but less common. It requires a [PHAR]
archive. Download the latest versions with the following command:

    bin/katana update --fetch


You will also find the archives in the `data/share/update/` directory. To
finally update sabre/katana, simply run:

    bin/katana update --apply data/share/update/katana_vx.y.z.phar

The PHAR is executable. For instance:

    php data/share/update/katana_vx.y.z.phar --signature

or

    php data/share/update/katana_vx.y.z.phar --metadata

will respectively print the signature and the metadata of this version. Use
`-h`, `-?` or `--help` to get help.

[PHAR]: http://php.net/phar
