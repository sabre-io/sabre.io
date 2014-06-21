---
title: Promise
product: event
layout: default
---

Since version 2.0, the sabre/event library has support for Promises.

The best way to describe promises, is that a promise is a 'placeholder' for
a value that has not yet been determined. An example of this, is a HTTP request
that has not yet completed, or a database query that's taking a long time.

Promises have been popularized in Javascript, and are now actually becoming
part of the language. A promise in javascript is useful in avoiding what's
often referred to as 'callback hell'.

PHP, just like javascript, is also single-threaded. PHP does not use an
eventloop, and events everywhere though, so the 'callback hell' problem does
not appear as often. However, there are certain situations where Promises can
be useful as well.

An example through a use-case
-----------------------------

We are integrated with a RESTful webservice. We have to make 1 `PUT` and 1
`DELETE`, but we don't have to perform these in order.

Curl allows us to make multiple paralel, non-blocking requests using
[`curl_multi`][1]. It's syntax is rather verbose, so we are using the
following fictional http client:

    class MultiHttp {

        function addRequest($method, $url, $body);
        function wait();

    }

Conceptually this client works as follows:

1. We perform new http requests with the `addRequest` method.
2. When we are completely done, we can call the `wait` method, which causes
   the client to simply wait until all the still outstanding requests have
   completed.

The developer of the MultiHttp client can use Promises to handle asynchronous
results.

This is an example of how our example would work:

    $multiHttp = new MultiHttp();

    $multiHttp->addRequest('PUT', '/blogpost2.txt', '...')
        ->then(
            function($value) {
                // The PUT request was successful!
            }
            function($reason) {
                // The request failed with reason: $reason
            }
        );

    $multiHttp->addRequest('DELETE', '/blogpost3.txt', '...')
        ->then(
            function($value) {
                // The DELETE request was successful!
            }
            function($reason) {
                // The request failed with reason: $reason
            }
        );

    $multiHttp->wait();

This is on a high level how a promise works. A function returns a promise
instead of a regular value, and you can use `->then()` to execute a callback
when the operation is completed.

`->then()` takes 2 arguments:

1. A callback for a successful result. The callback gets a `$value`.
2. A callback for a failure. The callback gets a `$reason`.

It is up to the implementor to decide what types `$value` and `$reason` are,
but it's recommended to send `Exception` objects to the error handler.


The innovation: chaining
------------------------

The innovation does not lie in the fact that there's a simple object with a
result and error handler, it's the fact that it's possible to create rather
complex chaining rules.

Our next example does two things:

1. Deletes a resource with `DELETE`.
2. Re-creates the resource with `PUT`.

This operation has to be done in this exact order, because the `PUT` relies
on the `DELETE` to complete.

This is how we would do this:


    $multiHttp = new MultiHttp();

    $multiHttp->addRequest('DELETE', '/blogpost2.txt', '...')
        ->then(
            function($value) {
                // The DELETE request was successful!
                return $multiHttp->addRequest('PUT', '/blogpost2.txt', '...');
            }
        )
        ->then(
            function($value) {
                // The PUT request was successful!
            }
            function($reason) {
                // The PUT or DELETE request has failed.
            }
        );

    $multiHttp->wait();

The success handler for the initial `DELETE` request now _returns_ another
promise.

The result is that the promises are chained.

Also note that the first `then` no longer has an error handler. The error
handler is optional. If it is not specified, it will automatically cause any
chained promises to also fail.

Therefore it's only needed to specify the last error handler.

**Note:** If the last error handler is missing, and errors or exceptions will
be suppressed. Always make sure you end the chain with 1 error handler.


Promise state
-------------

A promise can only have one of three states:

1. Pending
2. Fulfilled
3. Rejected

After a promise is in state 2 or 3, its state and value/reason is immutable.

If you call `then` after the promise has a result, the callbacks are
immediately triggered.


Creating a Promise
------------------

If you are the implementor of `MultiHttp`, you will want to know how to create
a promise. It's pretty easy, just call the constructor:


    $promise = new Sabre\Event\Promise();


Then, if later in the process, you have a result, you just call:

    $promise->fulfill( $result );

Or if it was an error:

    $promise->reject( new Exception('Something went wrong'); );


Alernatively, it's possible to handle this entire process during construction,
by passing a callback to the constuctor:

    $promise = neV Sabre\Event\Promise(function($fullFill, $reject) {

        if ($operationSuccessful) {
            $fullFill( $result );
        } else {
            $reject( $reason );
        }

    });


API
---

### `__construct(callable $executor = null);`

Creates the Promise with an optional executor callback. The callback will
receive a reference to the reject and fullfill functions.

See 'Creating a Promise'


### `then(callable $onFulfilled = null, callable $onRejected = null)`

Sets up a callback for when the promise is fulfilled or rejected.

Example:

    $promise->then(
        function($result) {

        },
        function($reason) {

        }
    );

The result handler and the error handler may return a value.

If the value is a promise, it will be automatically chained to the promise
then returns:

    $promise->then( function($result) {
        return new Promise(
            function($fullFill, $reject) {
                $fulFill('Foo!');
            }
        );
    })->then( function($result ) {

        // Will echo "Foo!\n";
        echo $result; 

    });

It's not required to return a Promise. If another value is returned from either
your result or error handler, then `then` will return a Promise that
immediately resolves to that value.

This makes the previous example 100% functionally identical to this:


    $promise->then( function($result) {

        return 'Foo!';

    })->then( function($result ) {

        // Will echo "Foo!\n";
        echo $result; 

    });

If there is no error handler, but an error occurred, the returned promise will
also be rejected with the same `$reason`.

If an exception occurs during either of the handlers, the exception will be
caught, and the returned promise will fail with the exception as the reason:

    $promise->then( function($result) {

        throw new Exception('Uh oh!');

    })->then( function($result ) {

        // Will echo "Foo!\n";
        echo $result; 

    }, function($reason) {

        // Will echo "Uh oh!"
        echo $reason->getMessage();

    });

For this reason its very important to always end with a rejected handler, as
otherwise any exceptions may be silently supressed.

### `error($onRejected)`

This method can be used to just specify an error handler. This allows the
following syntax:


    $promise->then( function($result) {

        throw new Exception('Uh oh!');

    })->error( function($reason ) {

        // Will echo "Uh oh!"
        echo $reason->getMessage();

    });

### `fulfill(mixed $value = null)`

Fullfills a promise that didn't have a result yet.

    $promise->fulfill('Some result object could go here');

The value may be any type at all.


### `reject(mixed $reason = null)`

Reject (fails) a promise that didn't have a result yet.

    $promise->fulfill(new Exception('Oh no!'));

The reason may also be any PHP type, but it's recommended to use exceptions.


### `all(Promise[] $promises)`


The `all` method is a static method. You can specify 1 or more promises to it,
and it returns a new promise.

The new promise will fulfill when all the passed promises are fulfilled.

The value for this is an array with all the result values for every promise.
If any of the promises fails, the 'all promise' will also fail with just that
message.

    $promise1 = new Promise();
    $promise2 = new Promise();

    $all = Promise::all([$promise1, $promise2])->then(
        function($value) {
            // All the promises have been fulfilled, and $value contains all
            // the values of all the promises.
        },
        function($reason) {
            // One of the promises failed with reason: $reason
        }
    );

[1]: http://ca2.php.net/manual/en/function.curl-multi-init.php
