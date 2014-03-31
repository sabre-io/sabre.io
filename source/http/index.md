---
title: sabre/http
layout: default
product: http
---

This library provides a toolkit to make working with the HTTP protocol easier.

Most PHP scripts run within a HTTP request but accessing information about the
HTTP request is cumbersome at least, mainly do to superglobals and the CGI
standard.

There's bad practices, inconsistencies and confusion. This library is
effectively a wrapper around the following PHP constructs:

For Input:

* `$_GET`
* `$_POST`
* `$_SERVER`
* `php://input` or `$HTTP_RAW_POST_DATA`.

For output:

* `php://output` or `echo`.
* `header()`

What this library provides, is a `Request` object, and a `Response` object,
both which are easily extendable and mockable. On top of that, it comes with
a number of other features that makes it easy to work with HTTP related stuff.

* [Installation](/http/install)
* [Usage instructions](/http/usage)

A quick history
---------------

This library came to existence in 2009, as a part of the [SabreDAV][2]
project, which uses it heavily.

It got split off into a separate library to make it easier to manage
releases and hopefully giving it use outside of the scope of just SabreDAV.

Although completely independently developed, this library has a LOT of
overlap with [symfony's HttpFoundation][3].

Said library does a lot more stuff and is significantly more popular,
so if you are looking for something to fulfill this particular requirement,
I'd recommend also considering [HttpFoundation][3].

[2]: http://code.google.com/p/sabredav
[3]: https://github.com/symfony/HttpFoundation
[4]: http://uk3.php.net/curl
