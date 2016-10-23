---
title: sabre/event 5 released
product: event 
sidebar: none
date: "2016-10-23T22:42:15-04:00"
tags:
    - event 
    - release
---

We just released sabre/event 5.0.0. This is only a month after the last major
release, but it's for a good reason.

We've made a change in how coroutines work. Co-routines, which are based on
generators were originally introduced in sabre/event for PHP 5.5.

At the time it was not possible for a PHP generator function to return
anything like this:

    function foo() {
        yield 1;
        return 2;
    }

To work with this limitation in coroutines, we treated the last value that
was passed with `yield` as the "returned value".

Since PHP 7 it is possible to use return and the PHP Generator object has a
`getReturn()` method to access it.

We missed this in sabre/event 4, but it was quickly pointed out by Felix
Becker.

Using return makes so much sense now we can, it was worth making a BC break
for and releasing sabre/event 5 with the more sane behavior for PHP 7.

So today there's a sabre/event 5, and the only change is that if the previous
example of the generator function is used in the coroutine system, it will now
have `2` as its result instead of `1`.

* [Changelog][1].
* [Release info][2].

[1]: https://github.com/fruux/sabre-event/blob/5.0.0/CHANGELOG.md
[2]: https://github.com/fruux/sabre-event/releases
