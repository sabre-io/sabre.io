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

*Note:* This feature was added in SabreDAV 1.7.0.

A sample request
----------------

    PATCH /file.txt
    Content-Length: 4
    Content-Type: application/x-sabredav-partialupdate
    X-Update-Range: bytes=3-6

    0000

This request updates 'file.txt', specifically the bytes 3-6 (inclusive) to
`0000`.

* The Content-Length header is required
* The X-Update-Range is also required. The value is the exact same as the HTTP
  Range header. The two numbers are inclusive (so 3-6 means that bytes 3,4,5
  and 6 will be updated).
* Just like the HTTP Range header, the specified bytes is a 1-based index.
  This means that 'bytes=0-3' is invalid, as there is no '0th byte'.
* The 'application/x-sabredav-partialupdate' must also be specified.
* The two numbers in the Update-Range header may be omitted. If the start byte
  is omitted, 0 is assumed. If the end-byte is omitted the Content-Length is
  used.
* Note that this makes the end-range unneeded, but we wanted to stay close to
  the HTTP specification.
* You can start writing past the end of the file. The in-between space will be
  filled with `0x00`.

If you want to be compliant with SabreDAV's implementation of PATCH, you must
also return 'sabredav-partialupdate' in the 'DAV:' header:

    HTTP/1.1 204 No Content
    DAV: 1, 2, 3, sabredav-partialupdate, extended-mkcol

Using this feature on the server-side
-------------------------------------

To use partial updates, your file-nodes must implement the
`Sabre\DAV\PartialUpdate\IFile` interface. This adds a new `putRange()` method
to the interface. Note that the offset argument is a normal 0-based index,
contrary to the 1-based offset as specified in the request.

A sample implementation can be found in `Sabre\DAV\FSExt\File`.

[1]: http://tools.iets.org/html/rfc5789
