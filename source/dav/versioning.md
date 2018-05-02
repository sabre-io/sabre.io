---
title: Versioning in DAV
layout: default
---

Versioning is _not_ natively supported by SabreDAV.

The WebDAV specification has an extension called [Delta-V][1], which is
defined in [rfc3253][1].

[Subversion][2] makes use of this standard, but extends it quite a bit. As
far as we are aware, the subversion server implements the protocol, allowing
generic Delta-V clients to take advantage of it, but the subversion client is
not a Delta-V compatible client.

Because there are no wide-spread Delta-V clients out there (in fact, we are
not aware of _any_ clients at all), there has been no interest so far to
implement this.

If you do have a need for this, please [submit a feature request][3], or tell
us on the [mailing list][4]. The only way we are aware of people wanting this,
is if they tell us.

[1]: http://tools.ietf.org/html/rfc3253
[2]: http://subversion.apache.org/
[3]: https://github.com/sabre-io/dav/issues/new
[4]: http://groups.google.com/group/sabredav-discuss
