---
product: http 
layout: default
title: Upgrading from sabre/http 3.x to 4.x
---

sabre/http 4.0 got several cleanups and changes. This guide explains exactly
what has changed and what you need to do to update.

sabre/uri
---------

The http package now has a dependency on the new [sabre/uri][1] package. It
delegates many uri-handling functionality to that package.

This also deprecates the following functions:

| Old function                              | New function                     |
| ----------------------------------------- | -------------------------------- |
| `Sabre\HTTP\URLUtil::splitPath()`         | `Sabre\Uri\split()`              |
| `Sabre\HTTP\URLUtil::resolve()`           | `Sabre\Uri\resolve()`            |
| `Sabre\HTTP\URLUtil::encodePath()`        | `Sabre\HTTP\encodePath()`        |
| `Sabre\HTTP\URLUtil::encodePathSegment()` | `Sabre\HTTP\encodePathSegment()` |
| `Sabre\HTTP\URLUtil::decodePath()`        | `Sabre\HTTP\decodePath()`        |
| `Sabre\HTTP\URLUtil::decodePathSegment()` | `Sabre\HTTP\decodePathSegment()` |

The old functions will continue to work, but will be removed in version 5.0.


Header utilities
----------------

Two more functions got moved to `functions.php` and have been cleaned up a
bit:

| Old function                       | New function               |
| ---------------------------------- | -------------------------- |
| `Sabre\HTTP\Util::parseHTTPDate()` | `Sabre\HTTP\parseDate()`   |
| `Sabre\HTTP\Util::toHTTPDate()`    | `Sabre\HTTP\toDate()`      |

The old functions will continue to work, but will be removed in version 5.0.

[1]: /uri/
