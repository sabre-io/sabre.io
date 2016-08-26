---
product: baikal 
title: Dockerized Installation
layout: default
---

## Requirements

* Docker 1.9 or later
* A Docker Hub account where to push the images

## Deployment

* Clone the __[pr3d4t0r/calendar][1]__ repository from GitHub
* Change the instances of "example.org" to your domain name
    * `bin/runapache2`
    * `resources/baikal.apache2`
    * `resources/Server.php`
        * Find out your relay's host name &mdash; this guide uses _smtp.example.org_
    * `Dockerfile`
        * Check your relay host name &mdash; this guide assumes
          _smtp.example.org_
* Build the image and push it to Docker Hub

```
imageName="yourdockerhubname/calendar"; \
docker build -t "$imageName" --rm=true . && \
docker push "$imageName"
```

On the target server:

* Create a service account to run the calendar (e.g. `/home/calendar` or 
  `/var/calendar` or whatever); these examples assume `/home/calendar`
* Create a data directory and an empty database:
```
# This is the simplest mechanism to get around the permissions mismatch between
# Docker instances and the local file system
# This could've been resolved with a data volume; that's beyond the scope of 
# this setup

mkdir -p /home/calendar/db && \
chmod 777 /home/calendar/db && \
touch /home/calendar/db/db.sqlite && \
chmod 666 /home/calendar/db/db.sqlite
```
* Start a new instance of the service in the `/home/calendar` directory:
```
docker run --name "calendar.service" \
    --privileged=true \
    -h "calendar" \
    -e "CONTAINER_DOMAIN_NAME=yourdomain.name" \
    -v "$(pwd)/db":"/var/www/calendar_server/" \
    -p "8800:80" \
    -d "yourdockerhubname/calendar"
```
* List the current instances and check if the service is running on the server
```
docker ps -a
```
```
CONTAINER ID        IMAGE                        COMMAND             CREATED             STATUS              PORTS                  NAMES
83d209fefa91        yourdockerhubname/calendar   "/runapache2"       2 minutes ago       Up 2 minutes        0.0.0.0:8800->80/tcp   calendar.service
```
* Configure the Baïkal server by connecting to the instance on port 8800

<img src='/img/baikal-admin-wizard.png' style="width: 100%; max-width: 640px;" />
<img src='/img/baikal-db-wizard.png' style="width: 100%; max-width: 640px;" />
<img src='/img/baikal-installed.png' style="width: 100%; max-width: 640px;" />

The installation is complete.  Users, calendars, address books, etc. can all be
managed now, like in this production instance.

<img src='/img/baikal-in-use.png' style="width: 100%; max-width: 640px;" />

## Implementation notes

This section explains the implementation changes specific to running Baïkal as
a production-ready server with all the features that end users and sysadmins
expect.

The Dockerfile and related support files are available from GitHub at
[pr3d4t0r/calendar][1]

### Postfix installation on Debian-like systems

Current versions of Baïkal and sabre/dav use the PHP `mail()` function for
sending event invitations.  That requires:

* Having an SMTP server running in the same image; and
* It should be configured as a relay to the organizations outbound SMTP server;
  and
* The `/usr/sbin/sendmail` program must be installed

`debconf-set-selections (1)` must be automated because the installer requires user
interaction.  The configuration in the Dockerfile is specific to an email relay.
Don't forget to change example.org to the actual domain name.  Watch also the
bounce email and SMTP relay name.

```bash
### "configure-postfix"
#
# These parameters are specific to your own Postfix relay!  Use your host and domain
# names.
RUN echo "postfix postfix/mailname string calendar.example.org" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Satellite system'" | debconf-set-selections && \
    echo "postfix postfix/relayhost string smtpcal.example.org" | debconf-set-selections && \
    echo "postfix postfix/root_address string cal-bounce@example.org" | debconf-set-selections
```

### Patching the Baïkal Server.php

Baïkal is a reference implementation of the sabre/dav project.  The [sabre/dav
documentation][2] indicates that the scheduling, and email delivery plug-ins must be
installed by hand "on the server".  The Baïkal documentation is very scarce, and
has no references to the server or how to do this in Baïkal.  Some tinkering
revealed that Baïkal defines its own server, separate from sabre/dav's.

```bash
# Scheduling and email delivery.  See:
# http://sabre.io/dav/scheduling/
# https://groups.google.com/forum/#!searchin/sabredav-discuss/scheduling|sort:relevance/sabredav-discuss/CrGZXqw4sRw/vsHYq6FDcnkJ
# This needs to be patched on the Baïkal start up Server.php, NOT in the sabre/dav server.
COPY resources/Server.php /var/www/calendar_server/Core/Frameworks/Baikal/Core/Server.php
```

The updated lines:

```php
if ($this->enableCalDAV) {
    $this->server->addPlugin(new \Sabre\CalDAV\Plugin());
    $this->server->addPlugin(new \Sabre\CalDAV\ICSExportPlugin());
    $this->server->addPlugin(new \Sabre\CalDAV\Schedule\Plugin());
    // Scheduling and email delivery.  See:
    // http://sabre.io/dav/scheduling/
    // https://groups.google.com/forum/#!searchin/sabredav-discuss/scheduling|sort:relevance/sabredav-discuss/CrGZXqw4sRw/vsHYq6FDcnkJ
    // This needs to be patched on the Baïkal start up Server.php, NOT in the sabre/dav server.
    $this->server->addPlugin(new \Sabre\CalDAV\Schedule\IMipPlugin('calendar-bounce@smtp.example.org'));
}
```

### Starting the services

Docker containers have a single entry point.  The version of sabre/dav/Baikal at
the time of this writing requires that the email relay or actual email server
run in the same box because it uses PHP's [`mail()` function][3].

The Dockerfile instruction `ENTRYPOINT` refers to a single command or service.
This set up requires that three different services start:

* Apache 2
* rsyslog to enable logging to `/var/log/syslog`
* The Postfix server and all its related services

Apache Server has some conflicts when launched from the service (8) command in
Docker containers.  The recommended mechanism is to launch using the
/usr/sbin/apache2 executable.

The `ENTRYPOINT` is at the custom script runapache2:

```bash
#!/bin/bash

hostname calendar.example.org
domainname example.org

source /etc/apache2/envvars

mkdir -p "$APACHE_LOCK_DIR"
mkdir -p "$APACHE_RUN_DIR"

service rsyslog start
service postfix start

/usr/sbin/apache2 -DFOREGROUND
```

[1]: https://github.com/pr3d4t0r/calendar
[2]: /dav/scheduling
[3]: https://secure.php.net/manual/en/function.mail.php

