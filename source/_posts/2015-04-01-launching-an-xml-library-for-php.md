---
title: A new XML library for PHP
product: xml 
sidebar: none
date: "2015-04-01T22:10:15+00:00"
tags:
    - xml 
    - release
---

Dealing with XML is annoying to many, and certainly us. We've tried many
different approaches to make working with XML less frustrating, and we've
finally landed on an approach that we're happy with.

We're launching sabre/xml to the public today. You can find a bit of an
overview on [this blog][1], or you can jump straight in the [documentation][2].

This library is already integrated into the master branch of sabre/dav, which
will be released as 2.2 soon. We rewrote almost all our XML handling code,
and there was quite a bit! The next release has over 10.000 changed lines.

The next major version of sabre/vobject will also depend on it to support
reading and writing xCal and xCard.

[1]: http://evertpot.com/an-xml-library-you-may-not-hate/
[2]: /xml/
