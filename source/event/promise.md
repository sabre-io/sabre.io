---
title: Promise
product: event
layout: default
---

Since version 2.0, the sabre/event library has support for Promises.

A Promise is a 'placeholder' for the result of an asynchronous operation.
An example of this, is a HTTP request that has not yet completed, or a database
query that's taking a long time to complete.

Promises have been popularized in Javascript, and are now actually becoming
part of the Javascript language in ECMAScript 6. A Promise in Javascript is
useful in avoiding what's often referred to as 'callback hell'.

PHP, just like Javascript, is single-threaded. Unlike Javascript, PHP does
not have an eventloop, or is as event-heavy as Javascript is. So 'callback hell'
is a lot less prevalent problem. However, there are certain situations where
Promises can be useful in PHP as well.

This implementation of a Promise in PHP aims to be as close to the standard
EcmaScript implementation as possible. Everything that's available there is
available here.


An example through a use-case
-----------------------------

We are integrated with a RESTful webservice. We have to make 1 `PUT` and
1 `DELETE` request, but we don't have to perform these in order.

Curl allows us to make multiple parallel, non-blocking requests using
[`curl_multi`][1]. Its syntax is rather verbose, so we are using the
following fictional HTTP client:

    class MultiHttp {

        function addRequest($method, $url, $body): Promise;

    }

Conceptually this client works as follows:

1. We perform new HTTP requests with the `addRequest` method.
2. This method returns a Promise object.
3. The Promise object is initially pending, but later on it will have the
   result of the operation.


This is an example of how our example would work:

    $multiHttp = new MultiHttp();

    $multiHttp->addRequest('PUT', '/blogpost2.txt', '...')
        ->then(
            function($value) {
                // The PUT request was successful!
            }
        )->otherwise(
            function($reason) {
                // The request failed with reason: $reason
            }
        );

    $multiHttp->addRequest('DELETE', '/blogpost3.txt', '...')
        ->then(
            function($value) {
                // The DELETE request was successful!
            }
        )->otherwise(
            function($reason) {
                // The request failed with reason: $reason
            }
        );

    Sabre\Event\Loop\run();

This is on a high level how a Promise works. A function returns a Promise
instead of a regular value, and you can use `then` to execute a callback
when the operation is completed.

To catch errors, use the `otherwise` function.


The innovation: chaining
------------------------

The innovation lies in the fact that it's possible to chain promises.

Our next example does two things:

1. Deletes a resource with `DELETE`,
2. Re-creates the resource with `PUT`.

This operation has to be done in this exact order, because the `PUT` relies
on the `DELETE` to complete.

This is how we would do this:


    $multiHttp = new MultiHttp();

    $multiHttp->addRequest('DELETE', '/blogpost2.txt', '...')
        ->then(
            function($value) use ($multiHttp) {
                // The DELETE request was successful!
                return $multiHttp->addRequest('PUT', '/blogpost2.txt', '...');
            }
        )
        ->then(
            function($value) {
                // The PUT request was successful!
            }
        )
        ->otherwise(
            function($reason) {
                // The PUT or DELETE request has failed.
            }
        );

    Sabre\Event\Loop\run();

**Note**: If you did not specify an error handler, any errors and exceptions may
be suppressed. Always make sure you end the chain with at least 1 error handler.


Promise state
-------------

A Promise can only have one of three states:

1. Pending,
2. Fulfilled,
3. Rejected.

After a Promise is in state 2 or 3, its state and the value/reason are
immutable.


Creating a Promise
------------------

If you are the implementor of `MultiHttp`, you will want to know how to create
a Promise. It's pretty easy, just call the constructor:

    $promise = new Sabre\Event\Promise();


Then, later on when you have the result of the operation, call:

    $promise->fulfill( $result );

Or if it was an error:

    $promise->reject( new Exception('Something went wrong'); );


API
---

### `Promise::__construct(callable $executor = null);`

Creates the Promise with an optional executor callback. The callback will
receive a reference to the fulfill and reject functions.

### `Promise::then(callable $onFulfilled = null, callable $onRejected = null)`

Sets up a callback for when the Promise is fulfilled or rejected.

Example:

    $promise->then(
        function($result) {

        },
        function($reason) {

        }
    );

The result handler and the error handler may return a value.

If the value is a Promise, it will be automatically chained to the Promise
that `then` returns:

    $promise->then( function($result) {

        $newPromise = anotherAsyncOperation();
        return $newPromise;

    })->then( function($result ) {

        echo $result;

    });

It's not required to return a Promise. If another value is returned from either
your result or error handler, `then` will return a Promise that
immediately resolves to that value.

This makes the previous example 100% functionally identical to this:


    $promise->then( function($result) {

        return 'Foo!';

    })->then( function($result ) {

        // Will echo "Foo!\n";
        echo $result;

    });

If there is no error handler, but an error occurred, the returned Promise will
also be rejected with the same `$reason`.

If an exception occurs during either of the handlers, the exception will be
caught, and the returned Promise will fail with the exception as the reason:

    $promise->then( function($result) {

        throw new Exception('Uh oh!');

    })->then( function($result ) {

        // Will echo "Foo!\n";
        echo $result;

    })
    ->otherwise(function($reason) {

        // Will echo "Uh oh!"
        echo $reason->getMessage();

    });

For this reason it's very important to always end with `otherwise()`, as
any exceptions may be silently suppressed without it. Alternatively, you
could also end your chain of promises with `wait()`.


### `Promise::otherwise($onRejected)`

This method can be used to just specify an error handler. This allows the
following syntax:


    $promise->then( function($result) {

        throw new Exception('Uh oh!');

    })->otherwise( function($reason ) {

        // Will echo "Uh oh!"
        echo $reason->getMessage();

    });

### `Promise::fulfill(mixed $value = null)`

Fulfills a Promise that didn't have a result yet.

    $promise->fulfill('Some result object could go here');

The value may be any type at all.


### `Promise::reject(mixed $reason = null)`

Reject (fails) a Promise that didn't have a result yet.

    $promise->reject(new Exception('Oh no!'));

The reason may also be any PHP type, but it's recommended to use exceptions.

### `Promise::wait()`

Turns your asynchronous code into blocking code again. Calling this function
will cause PHP to block until the promise is resolved. While it's 'blocking'
other events might be handled by the [Event Loop][2].

This is useful if you're mixing asynchronous code in an otherwise normal
synchronous PHP application.

The wait function returns the value of the last promise if it was fulfilled.
If the last promise rejected, the wait function will convert the `$reason`
into an exception, making your promise truly behave as a synchronous block
of code.

    $promise = someAsyncOp();
    $promise->wait();

You might combine this will all to block PHP until a group of async operations
have all completed:

    $promise1 = someAsyncOp();
    $promsie2 = anotherAsyncOp();

    Promise\all([$promise1, $promise2])->wait();

### `Promise\all(Promise[] $promises)`

The `Promise\all()` function returns a Promise, that will fulfill when all
of the passed promises have been fulfilled themselves.

The resolved value for this is an array with all the result values for every
Promise. If any of the Promises fails, the 'All Promise' will also fail with
just that message.

    $promise1 = new Promise();
    $promise2 = new Promise();

    $all = Promise\all([$promise1, $promise2])->then(
        function($value) {
            // All the promises have been fulfilled, and $value contains all
            // the values of all the promises.
        }
    )->otherwise(
        function($reason) {
            // One of the promises failed with reason: $reason
        }
    );

### `Promise\race(Promise[] $promises)`

The `Promise\race()` function returns a Promise, that will immediately fulfill
as soon as one of the passed promises have fulfilled..

The returned promise will resolve or reject with the value or reason of that
first promise.


    $promise1 = new Promise();
    $promise2 = new Promise();

    $all = Promise\race([$promise1, $promise2])->then(
        function($value) {
            // One of the promises has fulfilled, and $value contains the
            // value of the first fulfilled promise.
        }
    )->otherwise(
        function($reason) {
            // One of the promises has rejected, and $reason contains the
            // reason of that rejection.
        }
    );


### `Promise\resolve(mixed $value)`

The `Promise\resolve()` function returns a Promise that immediately fulfills
with the value you specified in its argument. It's a quick way to create a
promise that just immediately fulfills.

It's also possible to pass a different Promise as its argument, in which case
the returned promise will fulfill or reject when the passed promise does.

    $promise = Promise\resolve("hello");
    $promise->then(function($value) {

        // Output is "hello"
        echo $value;

    });

### `Promise\reject(mixed $reason)`

The `Promise\reject()` function returns a Promise that automatically rejects
with the reason specified in `$reason`.

It's a quick way for people writing Promise based code that just want to
return a rejected promise.


See also
--------

* [Coroutines][3].
* [Event Loop][2]


[1]: http://php.net/curl-multi-init
[2]: /event/loop/
[3]: /event/coroutines/
