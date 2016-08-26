---
product: baikal 
title: Secure Installation
layout: default
---

Neither the native installation nor the dockerized deployment are designed for
direct exposure to the Internet.  These deployments are intended for the service
to live in a private network or cloud, behind a firewall, and with calendar
client access only through a public HTTPS termination point.

## Exposing the Baikal server to the Internet

<img src='/img/calendar-server-blog.png' style="width: 100%; max-width: 800px;" />

Port selection is up to the system administrators and can be changed when the
images are instantiated.  The Baïkal server was assigned to port 8800 because
there may be other HTTP servers running in the same Docker instance.  Native
servers may run on port 80 or whichever port the organization's best practices
dictate.

Firewall and routing rules are used for enforcing data flows.  Scheduling
messages must only be allowed to flow out of the SMTP calendar server to the
corporate relay, never back.  The Baïkal server must support two-way
communication to handle the clients requests and updates.

## Certificate Management

HTTPS and STARTTLS involve managing certificates.  That activity is beyond the
scope of both sabre/dav and Baikal.  While it's possible to install and 
manage certificates on the Baikal service (and it's companion the Postfix
email relay), in reality that complicates both deployments for little additional
value because:

* Using separate SSL termination endpoints is considered a best practice because
  they can be delegated to a perimeter firewall, router, gateway, etc.
* Cloud hosting providers like Amazon Web Services, Microsoft Azure, IBM
  Slicehost, and others provide cloud SSL termination points
* Whether on premises or on the cloud, managing certificates at the endpoints
  is the result of implementing governance or regulatory requirements
    * All endpoints are treated in compliance to policy requirements
    * There's clear separation between service management and security/access
      management

These are the reasons why the Baikal installations don't cover SSL use and
certificate management.

The sabre/dav team is evaluating the possibility of implementing out of the box
security in a [ready-to-run Docker image][1] in the future.

[1]: /baikal/docker-ready

