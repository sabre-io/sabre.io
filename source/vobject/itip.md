---
title: iTip
product: vobject
layout: default
---

Since version 3.3, vObject has support for parsing and generating [iTip][1]
messages. Currently only `VEVENT` is supported.


What is an iTip message?
------------------------

iTip is defined in [rfc5546][1]. iTip messages are a type of iCalendar
messages, that are typically used for scheduling (invites and replies and
such).

You can recognize an iTip message from a standard iCalendar message by the
fact that it will have a `METHOD` property. Here's a minimal example of an
invite:

    BEGIN:VCALENDAR
    VERSION:2.0
    METHOD:REQUEST
    BEGIN:VEVENT
    UID:foobar
    ORGANIZER:organizer@example.org
    ATTENDEE:attendee@example.org
    SEQUENCE:1
    END:VEVENT
    END:VCALENDAR

Here's an example of a response to that invite:

    BEGIN:VCALENDAR
    VERSION:2.0
    METHOD:REPLY
    BEGIN:VEVENT
    UID:foobar
    ORGANIZER:organizer@example.org
    ATTENDEE;PARTSTAT=ACCEPTED:attendee@example.org
    SEQUENCE:1
    END:VEVENT
    END:VCALENDAR

These types of messages are often sent over email. This is called [iMip][2].
CalDAV servers also deal with iTip, this is defined in [rfc6638][3].

There are very strictly defined semantics on how Calendar agents are supposed
to generate and process these. VObject provides some help with this.


Generating iTip messages
------------------------

Generating iTip messages works based on the following three scenarios:

1. A user creates an event,
2. A user updates an event,
3. A user deletes an event.

For each of those scenarios, we need to figure out:

1. Is the user an attendee or organizer for that event?
2. If the user is an attendee, did the attendee update their participation
   status?
3. If the user is an organizer, do the attendees need to know about any
   updates?
4. And so on.

There's quite a few possible scenarios, including organizers adding or
removing attendees, resulting into various requests, cancellations and replies.

Here's an example to generate these messages:

    $broker = new Sabre\VObject\ITip\Broker();
    $messages = $broker->parseEvent(
        $newCalendar,
        'organizer@example.org',
        $oldCalendar
    );

Both `$newCalendar` and `$oldCalendar` should either be a `VCALENDAR` object,
or a `null`.

If `$oldCalendar` is `null`, it will be treated as a new object, if
`$newCalendar` is `null`, it will be treated as if the user deleted the object.

The returned value (`$messages`) is an array of `Sabre\VObject\ITip\Message`
objects. Each object carries _all_ the relevant information to deliver the
object using email or otherwise.


Parsing iTip messages
---------------------

The broker can also parse incoming iTip messages. This happens for example
when:

1. You receive an invite,
2. You get an update for an invite,
3. You send a reply to an invite,
4. You receive a cancellation for an invite.

The broker can parse these incoming messages, and update an existing calendar
object (or create a new one).

To do this, you will need a fully populated `Sabre\VObject\ITip\Message`
object, and some existing calendar object (or not at all if it's an invite
to a new event).

Example:

    $broker = new Sabre\VObject\ITip\Broker();
    $broker->processMessage(
        $message,
        $oldCalendar
    );

This will update `$oldCalendar` in-place.

[1]: http://tools.ietf.org/html/rfc5546
[2]: http://tools.ietf.org/html/rfc6047
[3]: http://tools.ietf.org/html/rfc6638
