---
title: sabre/uri
product: uri 
layout: default
---

A lightweight library that makes working with URIs easier.

This library provides a number of functions that augment what PHP already
provides. Partially inspired by [Node.js URL library][1], and others.

The library provides the following functions:

1. `resolve` to resolve relative urls.
2. `normalize` to aid in comparing urls.
3. `parse`, which is just an alias of PHP's [parse_url][2]. 
4. `build` to do the exact opposite of `parse`.
5. `split` to easily get the 'dirname' and 'basename' of a URL without all the
   problems those two functions have.

Further reading
---------------

* [Installation][3]
* [Usage][4]

[1]: http://nodejs.org/api/url.html
[2]: http://php.net/manual/en/function.parse-url.php
[3]: /uri/install/
[4]: /uri/usage/
