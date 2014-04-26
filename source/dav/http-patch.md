---
title: HTTP PATCH support
layout: default
type: plugin
plugin_name: partialupdate
plugin_since: 1.7.0
---

The `Sabre\DAV\PartialUpdate\Plugin` provides support for the HTTP PATCH method
([RFC5789][1]). This allows you to update just a portion of a file, or append
to a file.

SabreDAV defines its own content-type to do this.

*Note:* This feature was added in SabreDAV 1.7.0 and 1.8.0, but has been
broken until 1.7.12 and 1.8.10.

A sample request
----------------

    PATCH /file.txt
    Content-Length: 4
    Content-Type: application/x-sabredav-partialupdate
    X-Update-Range: bytes=3-6

    0000


This request updates 'file.txt', specifically the bytes 3-6 (inclusive) to
`0000`.

The rules
---------


* The Content-Length header is required
* The X-Update-Range is also required. The value is the exact same as the HTTP
  Range header. The two numbers are inclusive (so `3-6` means that bytes 3,4,5
  and 6 will be updated).
* Just like the HTTP Range header, the specified bytes is a 0-based index.
* The `application/x-sabredav-partialupdate` must also be specified.
* The end-byte is optional.
* The start-byte cannot be omitted.
* If the start byte is negative, it's calculated from the end of the file. So
  `-1` will update the last byte in the file.
* `-0` may be used to just append to the end of the file.
* Neither the start, nor the end-byte have to be within the file's current
  size.
* If the start-byte is beyond the file's current length, the space in between
  will be filled with NULL bytes (`0x00`).

More examples
-------------

The following table illustrates most types of requests and what the end-result
of them will be.

It is assumed that the input file contains `1234567890`, and the request body
always contains 4 dashes (`----`).

| X-Update-Range header | Result             |
| --------------------- | ------------------ |
| `bytes=0-3`           | `----567890`       |
| `bytes=1-4`           | `1----67890`       |
| `bytes=0`             | `----567890`       |
| `bytes=-4`            | `123456----`       |
| `bytes=-2`            | `12345678----`     |
| `bytes=2-`            | `12----7890`       |
| `bytes=-0`            | `1234567890----`   |
| `bytes=12-`           | `1234567890..----` |

Please note that in the very last example, we used dots (`.`) to represent what
are actually `NULL` bytes (so `0x00`). The null byte is not printable.

OPTIONS
-------

If you want to be compliant with SabreDAV's implementation of PATCH, you must
also return 'sabredav-partialupdate' in the 'DAV:' header:

    HTTP/1.1 204 No Content
    DAV: 1, 2, 3, sabredav-partialupdate, extended-mkcol

Using this feature on the server-side
-------------------------------------

To use partial updates, your file-nodes must implement the
`Sabre\DAV\PartialUpdate\IFile` interface. This adds a new `putRange()` method
to the interface.

A sample implementation can be found in `Sabre\DAV\FSExt\File`.

[1]: http://tools.ietf.org/html/rfc5789
