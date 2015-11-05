---
title: The Event Loop
product: event
layout: default
---

Since version 3.0, the sabre/event library ships with an event loop. In
cooperative multi-tasking, there always an event loop that waits for things
to happen and trigger events when they do.

In pseudo-code, the event loop roughly does the following:

    do {

        runTimedEventsIfNeeded();
        $nextTimedEvent = getNextTimedEvent();

        if (openStreams()) {
            waitForStreamsToHaveDataUntil($nextTimedEvent);
        } else {
            sleep($nextTimedEvent);
        }
    } until (noMorePendingEvents())

This mechanism is pretty much identical to how Javascript (and NodeJs) works.

This system also ensures that no CPU is used when there's nothing happening
for a while, while triggering events as soon as possible.

User API
--------

The way the User API is designed, is that there's generally only one instance
of an event loop.

The event loop is accessed with a set of functions.

### Running the loop

To start running the loop, simply call:

    Sabre\Event\Loop\run();

This function will block as long as there are pending events. When there are
no more pending events, this function will return.

If `run()` is the first thing you call, the function will exit immediately, as
there is nothing to do.

### Stopping the loop

To prevent the loop from continuing, just run:

    Sabre\Event\Loop\stop();

Note that generally it's a better idea to clean up any pending events. Calling
`stop()` on the event loop is a bit similar to calling `die()` in a whole PHP
script.

### Timed events

This event loop has a mechanism similar to javascript's
[window.setTimeout()][1]. The following example executes a function after
1 second.

    use Sabre\Event\Loop;

    Loop\setTimeout(function() {
        echo "Hello\n";
    }, 1);

    Loop\run();

Note that a big difference is that the timeout is specified in seconds. To get
sub-second precision, use a `float`.

The only guarantee that the loop gives is that the callback function is executed
after 1 second. It's possible that the event gets triggered later, if there was
different code currently running.


### Repeated timed events

Like `setTimeout`, sabre/event also has a [`setInterval`][2] function.
`setInterval` triggers an event repeatedly every x seconds.

To stop the event from triggering, call clearInterval.

    use Sabre\Event\Loop;

    $intervalId = Loop\setInterval(function() {

        echo "Hello\n";

    }, 1);


    Loop\run();

    // Later on you can stop the event from triggering:
    Loop\clearInterval($intervalId);

Note that the previous example would never stop running, as `clearInterval` is
never reached there.

### Execute a function as soon as possible

sabre/event also implements an equivalent to Node's [process.nextTick][3].
nextTick makes the event loop execute a function as soon as possible.

    use Sabre\Event\Loop;

    Loop\nextTick(function() {
        echo "Hello\n";
    });

    Loop\run();

### Process any pending events

Sometimes you might want to tell the loop to just execute any events that have
not been handled yet.

The tick function does just that:

    use Sabre\Event\Loop;
    Loop\tick();

Any events that should trigger at that time, will. If there are no events that
need to be triggered immediately, the function does not nothing.

After executing those events, the function returns.

It's also possible to make this call blocking, by setting its first argument
to true:

    use Sabre\Event\Loop;
    Loop\tick(true);

In the last call, the tick function will block right up until there's an event
that needs to be triggered.

### Add IO streams to the loop

If you are dealing with streams, you can get the event loop to give you a
callback as soon as the stream has data in it's buffer (for reading) or when
you can write to the buffer.

Two examples of this are:

* You are making a HTTP call and you're waiting for the server to respond.
* You have an open process stream (with [popen][4]) and you want to get notified when the process added new output.


    use Sabre\Event\Loop;

    $tail = popen('tail -fn0 /var/log/apache/access_log', 'r');
    Loop\addReadStream($tail, function() use $tail) {

        echo fread($tail, 4096);

    });

In the background the eventloop uses [`stream_select()`].

To stop the event loop from waiting for things to happen on the stream, you
can call `removeReadStream`.

   Loop\removeReadStream($tail);

There's also an equivalent for writes: `addWriteStream` and
`removeWriteStream`. The use-case for this is less common.


[1]: https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout
[2]: https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setInterval
[3]: https://nodejs.org/api/process.html#process_process_nexttick_callback_arg
[4]: http://php.net/manual/en/function.popen.php
[5]: http://php.net/manual/en/function.stream-select.php
