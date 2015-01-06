---
title: Recurring Events
product: vobject
layout: default
---

Recurrence rules allow events to recur, for example for a weekly meeting, or
an anniversary. This is done with the `RRULE` and `RDATE` property. The `RRULE`
property allows for a LOT of different rules. VObject has support for a lot of
them, but not all.

To read more about `RRULE` and all the options, check out [RFC5545](https://tools.ietf.org/html/rfc5545#section-3.8.5).
VObject supports the following options:

1. `UNTIL` for an end date,
2. `INTERVAL` for for example "every 2 days",
3. `COUNT` to stop recurring after x items,
4. `FREQ=DAILY` to recur every day, and `BYDAY` to limit it to certain days,
5. `FREQ=WEEKLY` to recur every week, `BYDAY` to expand this to multiple weekdays in every week and `WKST` to specify on which day the week starts,
6. `FREQ=MONTHLY` to recur every month, `BYMONTHDAY` to expand this to certain days in a month, `BYDAY` to expand it to certain weekdays occuring in a month, and `BYSETPOS` to limit the last two expansions,
7. `FREQ=YEARLY` to recur every year, `BYMONTH` to expand that to certain months in a year, and `BYDAY` and `BYWEEKDAY` to expand the `BYMONTH` rule even further.

VObject supports the `EXDATE` property for exclusions, and `RDATE` as well.

This is an example of a meeting that happens every 2nd monday of every month:

    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//Sabre//Sabre VObject 2.0//EN
    BEGIN:VEVENT
    UID:1102c450-e0d7-11e1-9b23-0800200c9a66
    DTSTART:20120109T140000Z
    RRULE:FREQ=MONTHLY;BYDAY=MO;BYSETPOS=2
    END:VEVENT
    END:VCALENDAR

To figure out all the meetings for this year, we can use the following syntax:

    $vcalendar = VObject\Reader::read($data);
    $vcalendar->expand(new DateTime('2012-01-01'), new DateTime('2012-12-31'));

What the expand method does, is look at its inner events, and expand the recurring
rule. Our calendar now contains 12 events. The first will have its RRULE stripped,
and every subsequent VEVENT has the correct meeting date and a `RECURRENCE-ID` set.

This results in something like this:

    BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//Sabre//Sabre VObject 2.0//EN
      BEGIN:VEVENT
        UID:1102c450-e0d7-11e1-9b23-0800200c9a66
        DTSTART:20120109T140000Z
      END:VEVENT
      BEGIN:VEVENT
        UID:1102c450-e0d7-11e1-9b23-0800200c9a66
        RECURRENCE-ID:20120213T140000Z
        DTSTART:20120213T140000Z
      END:VEVENT
      BEGIN:VEVENT
        UID:1102c450-e0d7-11e1-9b23-0800200c9a66
        RECURRENCE-ID:20120312T140000Z
        DTSTART:20120312T140000Z
      END:VEVENT
      ..etc..
    END:VCALENDAR

In a recurring event, single instances can also be overriden. VObject also takes these
into consideration. The reason we needed to specify a start and end-date, is because
some recurrence rules can be 'never ending'.

You should make sure you pick a sane date-range. Because if you pick a 50 year
time-range, for a daily recurring event; this would result in over 18K objects.
