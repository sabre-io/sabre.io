---
title: sabre/event 2.0.1 release
product: event
sidebar: none
date: "2014-10-09T22:11:36+00:00"
tags:
    - event
    - release
---

We just released sabre/event 2.0.1.

This release fixes two issues related to the `EventEmitter::once()` method,
and brings its functionality up to par with `EventEmitter::on()`.

Upgrade sabre/event by running:

    composer update sabre/event

If this didn't upgrade you to 2.0.1, make sure that your composer.json file
has a line that looks like this:

    "sabre/event" : "~2.0.1"

[1]: https://github.com/sabre-io/event/blob/2.0.1/ChangeLog.md
