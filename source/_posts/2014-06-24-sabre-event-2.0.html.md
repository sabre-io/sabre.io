---
title: sabre/event 2.0 release
product: event
sidebar: none
date: "2014-06-24T06:22:08+00:00"
tags:
    - event
    - release
    - promise
    - major
---

We just released sabre/event 2.0.0. This releases adds a few features, and
also slightly alters the API.

### New stuff

1. Support for [promises][2].
2. The event handler is now faster. This is especially noticable when making a
   lot of subscriptions to a single event, and is likely unnoticable for most.
3. Added support for something called the 'continue callback' to to the
   EventEmitter. This makes it possible to implement something similar to
   javascript's `preventDefault`.
4. When calling removeAllListeners without an argument, all listeners for all
   events are removed.

### Api breaks

1. We switched to PSR-4 for autoloading.
2. EventEmitter::listeners() no longer returns a manipulatable array of event
   listeners by reference. It's not a simple list of callbacks, sorted by
   their priority. The original concept was good on paper.
3. The argument on `removeAllListeners` is now optional.

Upgrade sabre/event by making sure your composer.json references `~2.0.0`, and
then run:

    composer update sabre/event

Full changelog can be found on [Github][1]

[1]: https://github.com/sabre-io/event/blob/master/ChangeLog.md
[2]: /event/promise/
