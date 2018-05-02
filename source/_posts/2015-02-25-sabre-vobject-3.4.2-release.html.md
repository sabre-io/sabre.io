---
title: sabre/vobject 3.4.2 release
product: vobject
sidebar: none
date: "2015-02-25T18:01:52+00:00"
tags:
    - vobject
    - release
---

We just released sabre/vobject 3.4.2.

This version contains a bugfix in the iTip/scheduling system that prevented
attendees from responding to certain invites.

Upgrade sabre/vobject by running:

    composer update sabre/vobject

If this didn't upgrade you to 3.4, make sure that your composer.json file
has a line that looks like this:

    "sabre/vobject" : "~3.4"

Full changelog of this release can be found on [Github][1].

[1]: https://github.com/sabre-io/vobject/blob/3.4.2/ChangeLog.md
