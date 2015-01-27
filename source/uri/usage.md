---
title: Usage instructions
product: uri
layout: default
---

sabre/uri is a super lightweight package that helps working with URIs. It
provides the following functions, all in the `Sabre\Uri` namespace:


Resolve
-------

The `resolve` function allows you to expand a relative URL in a full one,
in a similar way a browser would.

### Example

    namespace Sabre\Uri;

    $base = 'http://example.org/foo/bar/';
    $new = '../hello'

    echo Uri\resolve($base, $new);
    // Output: http://example.org/foo/hello

### A few more inputs and outputs:

| `$base`                   | `$new`           | Output                        |
| ------------------------- | ---------------- | ----------------------------- |
| `https://example.org/foo` | `//google.com/`  | `https://google.com/`         |
| `https://example.org/foo` | `?a=b`           | `https://example.org/foo?a=b` |
| `https://example.org/foo` | `bar`            | `https://example.org/bar`     |
| `/foo/bar/`               | `./hi/../../baz` | `/foo/baz`                    |
| `/foo/bar/?query`         | `#fragment`      | `/foo/bar/?query#fragment`    |


Normalize
---------

There are many ways to specify uris that all point to the same thing. The
normalize function helps you make these uris consistent with each other, which
in turn allows you to make better comparisons.

For example, these urls all point to the same resource:

* `http://example.org/~foo/`
* `HTTP://example.ORG/~foo/` Some parts are case-insensitive.
* `http://example.org:80/~foo/` Default ports.
* `http://example.org/%7Efoo/` URL-encoding. Wrong in this case, but common.
* `http://example.org/%7efoo/` URL-encoding using lowercase for hex numbers.
* `http://example.org/bar/./../foo/` Badly expanded relative urls.

### Example

    namespace Sabre\Uri;

    $input = 'HTTP://example.org:80/%7efoo/./bar/';

    echo Uri\normalize($output);
    // Output: http://example.org/~foo/bar/


Parse
-----

The `parse` function is a slightly modified version of PHP's [parse_url][1].

The difference is that this function returns the entire array of url parts,
even if those parts are not set.

### Example

    namespace Sabre\Uri;

    $input = '/foo/bar';
    print_r(
        Uri\parse($input)
    );

The above example will output:

    Array
    (
        [scheme] =>
        [host] =>
        [path] => '/foo/bar'
        [port] =>
        [user] =>
        [query] =>
        [fragment] =>
    )

Undefined parts are returned as `null`. This has the benefit that it makes it
a lot easier to deal with these arrays in `if` and ternary statements.


Build
-----

The `build` function takes the output of `parse` or [`parse_url()`][1] and
creates a new url.

It's basically the reverse operation of `parse`.


Split
-----

The `split` function takes a path and returns the [`basename()`][2] and
[`dirname()`][3] components.

### Example

    namespace Sabre\Uri;

    $input = "/path/to/file/";

    list(
        $parent,
        $basename
    ) = Uri\split($input);

    echo $parent; // output : /path/to/
    echo $basename; // output : file

### Why not basename() and dirname()?

1. The PHP functions are locale-aware and will start behaving differently
   depending on PHP's locale setting.
2. The PHP functions will use the backslash as the seperator on Windows.
3. The PHP functions behave a bit oddly if there is only one path component,
   which require special casing.

[1]: http://php.net/manual/en/function.parse-url.php
[2]: http://php.net/manual/en/function.dirname.php
[3]: http://php.net/manual/en/function.basename.php
