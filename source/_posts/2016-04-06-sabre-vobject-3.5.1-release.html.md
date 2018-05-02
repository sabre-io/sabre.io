---
title: sabre/vobject 3.5.1 released
product: vobject 
sidebar: none
date: "2016-04-06T20:16:13-04:00"
tags:
    - vobject 
    - release
---

We just released sabre/vobject 3.5.1. This release contains a few small
improvements:

1. When expanding recurring events, `RECURRENCE-ID` is now correctly added,
   even for the first event.
2. Several fixes in the iTip broker related to recurring events.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

Full changelog can be found on [Github][1]

[1]: https://github.com/sabre-io/vobject/blob/3.5.1/ChangeLog.md
[2]: https://github.com/sabre-io/vobject/releases
