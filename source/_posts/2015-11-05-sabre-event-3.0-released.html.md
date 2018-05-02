---
title: sabre/event 3 released
product: dav
sidebar: none
date: "2015-11-05T15:43:29-05:00"
tags:
    - event
    - release
    - loop
    - promise
    - async
    - coroutine
---

We just released sabre/event 3. This is a new major version, and comes with a
number of new features and also BC breaking changes.


Changes
-------

### PHP version

This package now requires PHP 5.5. The 2.0 version of this package will
continue to be maintained though if you need PHP 5.4 support.

### Changes to Promises

We've overhauled the promise significantly to closely match the standard
Ecmascript promise as close as possible.

To do this, we added the following functions:

    Sabre\Event\Promise\all
    Sabre\Event\Promise\race
    Sabre\Event\Promise\resolve
    Sabre\Event\Promise\reject

These are now straight up functions, and not static methods on the Promise
object.

The following methods were added:

    Sabre\Event\Promise::otherwise
    Sabre\Event\Promise::wait

Wait makes a lot of sense for PHP so it was added as a core feature. 

The following methods were deprecated:

    Sabre\Event\Promise::all
    Sabre\Event\Promise::error

Both will still work but will be removed in version 4.0.

`error` was renamed to `otherwise`. In javascript this function is actually
called `catch`, but we can't use that name in PHP because it's a reserved
keyword. Other projects such as ReactPHP and Guzzle have settled on the name
`otherwise`, so we're following their example.

Another change is that promise now uses the Event Loop to trigger events. This
means that events are now predictably asynchronously triggered, whereas before
events might have triggered synchronously.

What generally means is that you might need to explictly call the `wait()`
function on your promise to wait for it to resolve. Or you can call:

    Sabre\Event\Loop\run();

See the [Promise documentation][5] for more information.

### Coroutines

We've added support for coroutines using PHP 5.5 generators. For a great
example check out the [documentation][6].


### Event loop

We added an implementation of an Event Loop, also sometimes known as the
reactor pattern. This new system behaves similar to Javascript or
[ReactPHP][3]'s loop. The event loop can handle 'timed events' a.k.a.
`setTimeout()` and `setInterval()` and support for events on IO streams
strictly using `stream_select()` as the underlying engine. See the
[Loop documentation][4] for more information.


Changelog
--------- 

A full changelog can be found on [Github][1]

[1]: https://github.com/sabre-io/event/blob/3.0.0/CHANGELOG.md
[3]: http://reactphp.org/
[4]: /event/loop/
[5]: /event/promise/
[6]: /event/coroutines/
