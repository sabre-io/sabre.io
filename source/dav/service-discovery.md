---
title: Service Discovery
layout: default
---

Many clients are becoming better in discovering the location of CalDAV and
CardDAV service. This document describes a few pointers on how to improve this.

Basics
------

It's wise to make sure that a Cal/CardDAV server runs on the root of a server.
This allows a user with for example [iCal](/dav/clients/ical) to just fill in
the domain name, such as :

    dav.example.org

For a server url, instead of a full principal url. Many clients will first
attempt HTTPS on port 443, and then HTTP on port 80. You are strongly
encouraged to use HTTPS.

Apple products will also check port 8443 (https) and 8080 (http). First both
https ports will be checked, and then both http ports.

Well-known
----------

[RFC5785][1] describes a way to create 'discovery urls' for services.

If you add one of the following redirects to your webserver configuration, it
may be easier for clients to find the server:

    http://dav.example.org/.well-known/caldav -> root of your dav server
    http://dav.example.org/.well-known/carddav -> root of your dav server

This is not included in SabreDAV, as it makes more sense to handle this in
webserver configuration. This has an additional benefit for some domains. 

If your company email addresses look something like:

    john@example.org

In some clients it's possible to use just that email address and a password to
do all the setup. If this is entered in iCal for instance, it will grab the
domain part of the email address, and open this url:

    http://example.org/.well-known/caldav

If this url redirects to your dav server (which can be on a completely
different domain) then it will be easily able to setup the account.

Note that these all must be real redirects, triggering a 301, 303 or 307 HTTP
response.

DNS SRV records
---------------

It is also possible to use DNS to achieve the same thing. This requires the
use of a [SRV record][2].

The wikipedia article has some details. The labels, which are defined in
[rfc6764][3] will look something like:

    _carddav._tcp 
    _caldav._tcp 

For non-https servers, and :

    _carddavs._tcp 
    _caldavs._tcp 

For properly secured servers. Example:

    _carddavs._tcp 86400 IN SRV 10 20 443 dav.example.org.
    _caldavs._tcp 86400 IN SRV 10 20 443 dav.example.org.

Index:

| key               | explanation |
| ----------------- | ----------- |
| `_carddavs`       | type of service |
| `_tcp`            | protocol type, always tcp |
| `86400`           | record timeout |
| `IN`              | always has to be IN |
| `SRV`             | always has to be SRV |
| `10`              | priority, for DNS-based failover |
| `20`              | weight, for DNS-based loadbalancing |
| `443`             | tcp port, in this case 443 for HTTPS |
| `dav.example.org` | The actual domain name |

The spec dictates that the domain always has to point to an A record, and it
may not point to a CNAME record. Normally I would not recommend going against
specs, but I feel this is of great annoyance for the way scalable systems are
built today, so I can't comment on if clients actually require this, or what
the purpose of this is.

Note that these records can only point to a domain name, and not a full path.

To enable that, add the following:

TXT records
-----------

The TXT records can be used to give the client information about the path of
the hosted dav server, in the case it's not running on the server root.

These records are simple:

    _caldavs._tcp    TXT path=/dav
    _carddavs._tcp    TXT path=/dav

And for non-SSL:

    _caldav._tcp    TXT path=/dav
    _carddav._tcp    TXT path=/dav

The combination of these TXT and SRV records are effectively an alternative to
the `/.well-known` urls.

[1]: https://tools.ietf.org/html/rfc5785
[2]: https://en.wikipedia.org/wiki/SRV_record 
[3]: https://tools.ietf.org/html/rfc6764
