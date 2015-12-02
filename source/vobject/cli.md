---
title: CLI tool
product: vobject
layout: default
---

Since vObject 3.1, a new CLI tool is shipped in the `bin/` directory.

This tool has the following features:

* A `validate` command,
* A `repair` command to repair objects that are slightly broken,
* A `color` command, to show an iCalendar object or vCard on the console with
  ansi-colors, which may help debugging,
* A `convert` command, allowing you to convert between iCalendar 2.0, vCard 2.1,
  vCard 3.0, vCard 4.0, jCard and jCal.

Just run it using `bin/vobject`. Composer will automatically also put a
symlink in `vendor/bin` as well, or a directory of your choosing if you set
the `bin-dir` setting in your composer.json.
