---
title: Coroutines
product: event
layout: default
---

Coroutines in sabre/event is a feature that can improve your [Promise][1]-based
code.

It comes in the form of a single function, that takes a [generator][2] as an
argument. The generator can then _yield_ promises. The coroutine function will
automatically resume the function when the promise has resolved.

If the promise rejected, an exception will be thrown in the generator.

To illustrate this, an example will work better.

Before
------

    $promise = someAsyncOperation();
    $promise->then(function($result)) {

        return anotherAsyncOperation();

    })
    ->then( function($result) {

        return lastAsyncOperation();

    })
    ->then (function($result)) {

        echo $result, "\n";

    })
    ->otherwise(function($reason) {

        echo $reason, "\n";

    });


After
-----

The following code is equivalent:


    use Sabre\Event;

    Event\coroutine(function() {
   
        try {
 
            $result = yield someAsyncOperation();
            $result = yield anotherAsyncOperation();
            $result = yield lastAsyncOperation();
            echo $result;

        } catch (\Exception $reason) {

            echo $reason;

        }

    });


Tips and tricks
---------------

The coroutines itself also returns a promise. This promise will resolve with
the last yielded value or promise. It will reject if there was an uncaught
exception.

This allows you to for example call `wait()` to turn a large asynchronous
process into a blocking one:

    use Sabre\Event;

    Event\coroutine(function() {
   
        /* ... */

    })->wait();
    

It's possible to call different coroutines from within your own coroutine
easily as well:


    use Sabre\Event;

    Event\coroutine(function() {
   
        /* ... */

    })->wait();



[1]: /event/promise/
[2]: http://php.net/manual/en/language.generators.overview.php
