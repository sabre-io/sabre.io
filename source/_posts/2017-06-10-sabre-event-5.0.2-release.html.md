---
title: sabre/event 5.0.2 released
product: xml
sidebar: none
date: "2017-06-10T09:00:00+02:00"
tags:
    - event
    - release
---

We just released sabre/event 5.0.2.

This release includes the following fixes and performance optimizations:

1. Fixed Promise\all to resolve immediately for empty arrays.
2. Performance optimizations for `EmitterTrait` and `WildcardEmitterTrait`.

Upgrade sabre/event by running:

    composer update sabre/event

Full changelog can be found on [GitHub][1]

[1]: https://github.com/sabre-io/event/blob/5.0.2/CHANGELOG.md
