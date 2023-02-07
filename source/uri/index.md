---
title: sabre/uri
product: uri
layout: default
---

sabre/uri is a lightweight library that provides several functions for working
with URIs, staying true to the rules of [RFC3986][5].

Partially inspired by [Node.js URL library][1], and created to solve real
problems in PHP applications. 100% unit-tested and many tests are based on
examples from RFC3986.

The library provides the following functions:

1. `resolve` to resolve relative urls.
2. `normalize` to aid in comparing urls.
3. `parse`, which works like PHP's [parse_url][2].
4. `build` to do the exact opposite of `parse`.
5. `split` to easily get the 'dirname' and 'basename' of a URL without all the
   problems those two functions have.


Further reading
---------------

* [Installation][3]
* [Usage][4]

[1]: https://nodejs.org/api/url.html
[2]: https://php.net/manual/en/function.parse-url.php
[3]: /uri/install/
[4]: /uri/usage/
[5]: https://tools.ietf.org/html/rfc3986/
