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

A full discussion of the implementation details is available from
[Robust Calendar Service Deployment with Baïkal / SabreDAV Calendar in 10 Minutes][2]
and the [update/upgrade in less than 10 minutes][3] follow up.

[1]: https://github.com/pr3d4t0r/calendar
[2]: https://eugeneciurana.com/entry/robust-calendar-service-deployment-howto
[3]: https://eugeneciurana.com/entry/improved-baikal-sabredav-calendar-in-less-than-10-minutes

