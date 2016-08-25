---
product: baikal 
title: Docker Image Ready to Run
layout: default
---

There is no ready-to-run Baïkal Docker image in Docker Hub yet because a few
issues must be addressed before making it available for public use:

1. The host and domain names should be passed to the calendar container when it
   starts; they are indispensable for the correct Postfix and web server
   configuration and right now they're coded in to the Dockerfile.

1. A public Baïkal image would work best with a Docker volume container for data
   storage, including disaster recovery, backup procedures, and data management;
   for now it uses a directory in the host mapped to a virtual volume.

1. Optional support for [Let's Encrypt][1] in the image so that the Baïkal
   server does its own SSL termination; the current image assumes a data center
   approach of separating the application (Baïkal) from SSL termination
   (firewall, reverse proxy, gateway, etc.).  Best SysOp practices suggest
   keeping them separate, but practicality of deploying the Baïkal server in a
   single image would offer tremendous value for small shops and start ups.

1. Remove Postfix from the pr3d4t0r/calendar image; this requires code changes
   in Baïkal to use [Swift Mailer][2] instead of the PHP [`mail()` function][3],
   plus a mechanism for passing the MX server or relay configuration to the 
   container over environment variables (similar to 1).

The sabre/dav team is working toward sorting out the best solutions to these
issues.

A 100% stand alone, ready-to-run Baïkal image will be available at the end of
Q3 via Docker Hub.

## Why is the image based on Ubuntu Server instead of Alpine?

Using the smallest container possible is considered a Docker best practice. 
Alpine is the smallest distribution basic Docker image; it weighs 2 MB against
180 MB of the basic Ubuntu image.  So, why use the Ubuntu image?

The main reasons:  familiarity and availability.


* The Advanced Package Tool (apt) and dpkg are more pervasive than Alpine's apk
  package tools.  More sysadmins and developers are familiar with apt and dpkg.
* Not all Baïkal users will have access to a dockerized system, but most will
  have access to a stand alone machine.  The Dockerfile acts as a step-by-step
  Baïkal deployment HOWTO, or the Dockerfile can be converted into a one-pass 
  shell script that performs all the installation steps.

The ready-to-run Baïkal image may be based on Alpine at that point.

[1]: https://letsencrypt.org/
[2]: http://swiftmailer.org/
[3]: https://secure.php.net/manual/en/function.mail.php

