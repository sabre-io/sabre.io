---
title: EventEmitter
product: event
layout: default
---

The EventEmitter is a simple pattern that allows you to create an object
that emits events, and allow you to listen to those events.

Example:

    use Sabre\Event\EventEmitter;

    $eventEmitter = new EventEmitter();

    // Subscribing
    $eventEmitter->on('create', function() {

        echo "Something got created, apparently\n"

    });

    // Publishing
    $eventEmitter->emit('create');

The name of the event (`create`) can be any free-form string.

Priorities
----------

By supplying a priority, you are ensured that subscribers are handled in a
specific order. The default priority is 100. Anything below that will be
triggered earlier, anything higher later.

If there's two subscribers with the same priority, they will execute in an
undefined, but deterministic order.

    $eventEmitter->on('create', function() {

        // This event will be handled first.

    }, 50);

Callbacks
---------

All default PHP callbacks are supported, so closures are not required.

    $eventEmitter->on('create', 'myFunction');
    $eventEmitter->on('create', ['myClass', 'myMethod']);
    $eventEmitter->on('create', [$myInstance, 'myMethod']);

### Canceling the event handler

If any callback returns `false` the event chain is stopped immediately.

A use case is to use a listener to check if a user has permission to perform
a certain action, and stop execution if they don't.

    $eventEmitter->on('create', function() {

        if (!checkPermission()) {
            return false;
        }

    }, 10);

`EventEmitter::emit()` will return `false` if the event was cancelled, and
`true` if it wasn't.

Throwing an exception will also stop the chain.

This is similar to Javascript's [preventDefault()][1].

Passing arguments
-----------------

Arguments can be passed as an array.

    $eventEmitter->on('create', function($entityId) {

        echo "An entity with id ", $entityId, " just got created.\n";

    });

    $entityId = 5;
    $eventEmitter->emit('create', [$entityId]);

Because you cannot really do anything with the return value of a listener,
you can pass arguments by reference to communicate between listeners and
back to the emitter.

    $eventEmitter->on('create', function($entityId, &$warnings) {

        echo "An entity with id ", $entityId, " just got created.\n";

        $warnings[] = "Something bad may or may not have happened.\n";

    });


    $warnings = [];
    $eventEmitter->emit('create', [$entityId, &$warnings]);

    print_r($warnings);


Integration into other objects
------------------------------

To add `EventEmitter` capabilities to any class, you can simply extend it.

If you cannot extend, because the class is already part of an existing class
hierarchy you can use the supplied trait.

    use Sabre\Event;


    class MyNotUneventfulApplication
        extends AppController
        implements Event\EventEmitterInterface
    {

        use Event\EventEmitterTrait;

    }

In the preceeding example, `MyNotUneventfulApplication` has all the
capabilities of `EventEmitter`.


[1]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault
