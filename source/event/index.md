---
title: sabre/event
product: event
layout: default
---

An ultra-lightweight library for event-based development in PHP.

This library brings several popular event-based patterns from Javascript to
the PHP world. They are simple, 0-dependency and written to be very legible.

The goal is to be as close as their Javascript equivelant as possible, in a way
that's also sane for PHP. A second goal is to keep the patterns as simple as
possible, so it's easy to reason about. The library is also used as a learning
tool to understand complicated concepts (in particular the Promise and Event
loop).

1. [EventEmitter][1], which is a very lightweight "Publish and Subscribe"
   pattern,
2. [Promises][2], which is a design pattern to improve chained asynchronous
   callbacks.
3. [An event loop][3], aiding you in writing asynchronous PHP code.
4. [Coroutines][4], to make Promise-heavy code even better.

[1]: /event/eventemitter/
[2]: /event/promise/
[3]: /event/loop/
[4]: /event/coroutines/

