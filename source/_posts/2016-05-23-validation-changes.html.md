---
title: Upcoming changes to iCalendar and vCard validation in sabre/dav 3.2.
product: dav
sidebar: none
date: "2016-05-23T18:34:07-04:00"
tags:
    - dav
    - icalendar
    - vobject
    - vcard  
---

We are currently working on sabre/dav 3.2. [A first beta has been released][1].
This release will include some changes to validating iCalendar and vCard.
These changes might impact you if you use the Card- and CalDAV systems, or if
you are a developer for a Cal/CardDAV client.

In the past we've been pretty lenient in terms of what kind of data you can
send the server. Originally the idea for this was to follow Postel's law, e.g.:

> Be conservative in what you send, be liberal in what you accept

I actually believe that Postel's law and following it is _not_ a good idea and
will actually over time cause networks to become less and less compliant.

So starting 3.2 we are dialing up the strictness of the server. The component
inside of sabre/dav responsible for parsing iCalendar and vCard has had a
validation system for a while. sabre/dav now uses that system when you `PUT`
a new iCalendar object or vCard.

The system is not yet 100% complete, so it will not yet throw errors on every
invalid object, but over time we will make this more strict by adding new
validation rules.

How it works
------------

One of the biggest areas in validation is that we're now checking for
properties that are required, and how many instances of properties may
appear.

For example, in iCalendar the `PRODID` is _required_ to appear in the
top-level iCalendar object.

In that particular case, the system is actually able to repair the incoming
object. It will simply add a default `PRODID`.

A request for this might look as follows:

    PUT /calendars/user/calendar/new-object.ics
    Content-Type: text/calendar

    BEGIN:VCALENDAR
    BEGIN:VEVENT
    UID:foo-bar
    DTSTAMP:20160523T181200Z
    DTSTART:20160524T090000Z
    SUMMARY:Meeting
    END:VEVENT
    END:VCALENDAR

Since `PRODID` is missing, sabre/dav will do the following:

1. It will automatically add a `PRODID`
2. It will **no longer** send back an `ETag` header after the request.
3. It adds an `X-Sabre-Ew-Gross` header. This header is an indicator something
   was not right in the request, along with a description for a developer what
   was wrong with it.

The reason we're _not_ returning an `ETag` is because we have to make
modifications to the object. Not returning an `ETag` pretty much tells the
client: you must do a `GET` request after your `PUT` to find out the current
state of the object and the correct `ETag`. Fortunately, most clients do this
correctly.

It also works well as a small punishment to a client. They are forced to do an
extra HTTP request, so there is an incentive to fix the bug.


When we can't do a repair
-------------------------

There are many cases where we can't guess what the developer's intent was. For
example: every `VEVENT` must have a `DTSTART`. If it didn't appear, we can't
really just make one up.

For situations like that, we now always emit HTTP error
`415 Unsupported Media Type`, along with our `X-Sabre-Ew-Gross` header.


Requesting strict handling
--------------------------

There are also cases where a client developer does not want the server to
automatically repair the object, and instead always do a hard failure when
the server deems an object invalid. This might be especially handy during
development.

To tell the server to always do hard failures, you can simply include the
standard `Prefer: handling=strict` HTTP header in your PUT requests.

 
There are likely going to be compatibility problems
---------------------------------------------------

Because we are becoming more strict, it is likely that there are CalDAV and
CardDAV clients that stop working, because they were sending us invalid data.

To deal with this, we are doing the following:

1. We're testing popular clients to see if they have problems.
2. If we run into those problems, we try to contact the developer of the
   client to see if they are able to fix it.
3. If they are not fixing the problem, or if we determine that there will be
   many users stuck on an old version of their client, we will try to see if
   we can add an 'automatic repair' rule to the validation system.

The automatic repair will account for most, if not all client bugs, but if we
do run into an issue with a client that will not behave correctly if we don't
return an ETag, and the developer is unwilling to fix the problem (or enough
users can't upgrade) we will consider a client-specific workaround, preferably
based on the `User-Agent`.

However, we can't test every client on the face of the planet. So we're hoping
developers and users of clients will test sabre/dav 3.2 with their software and
report issues they run into.

Because we completely assume that we _will_ run into new compatibility issues,
and we also completely assume that not every client will be tested when the
3.2 release hits the floor, we recommend users of sabre/dav to test
CalDAV/CardDAV clients they support before upgrading, or waiting a few point
releases so the dust can settle.


Contact us
----------

Are you running into a compatibility issue? [Contact us via our Github
issue tracker][2].

[1]: https://github.com/sabre-io/dav/releases
[2]: https://github.com/sabre-io/dav/issues/new
