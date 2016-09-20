---
title: sabre/event 4 released
product: event 
sidebar: none
date: "2016-09-19T22:42:15-04:00"
tags:
    - event 
    - release
---

We just released sabre/event 4.0.0.

This release requires PHP 7, and has the following new features:

* PHP 7 typehints where they make sense, `strict_types` used everywhere.
* Support for a new `WildcardEmitter` this Emitter has the same interface as
  the regular `Emitter`, but it allows you to listen for events such as
  `updated:*`, which would get triggered for any event that starts with
  `updated:`.
* `EventEmitter`, `EventEmitterTrait` and `EventEmitterInterface` are renamed
  to `Emitter`, `EmitterTrait` and `EmitterInterface`.
* Promises now correctly handle PHP 7 `Trowable`.
* Promises _must_ now be rejected by an object implementing `Trowable`. In the
  past it was possible to reject a Promise with any value (like Javascript),
  but unlike Javascript, you can't throw a string in PHP. I felt that this
  made the Promise a bit more predictable.

### PHP 5.5

sabre/event 3 will continue to be supported. I don't suspect new bugs will
appear there though, as it's a fairly simple package.

To upgrade sabre/event, make sure your `composer.json` requires "^4.0" for
sabre/event.

[1]: https://github.com/fruux/sabre-event/blob/4.0.0/CHANGELOG.md
[2]: https://github.com/fruux/sabre-event/releases
