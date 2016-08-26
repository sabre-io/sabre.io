---
product: baikal 
title: Dockerized Upgrade
layout: default
---

## Requirements

* Docker 1.9 or later
* An existing Docker Hub account to push the images
* An existing [dockerized installation][1], already in production, that needs to be upgraded

## Deployment

On the production calendar server:

* Copy the existing configuration files from running container to the service
  account on the production server
```bash
whoami && pwd
calendar
/home/calendar
docker exec calendar.service /bin/cat /var/www/calendar_server/Specific/config.php > ./config.php
docker exec calendar.service /bin/cat /var/www/calendar_server/Specific/config.system.php > ./config.system.php
```

On the build server:

* Copy the configuration files from the service account `$HOME` to the build
  server's `./resources` directory
```bash
scp calendar@your.calendar.server.example.org:config.php ./resources
scp calendar@your.calendar.server.example.org:config.system.php ./resources
```
* Open the Dockerfile
* Specify the new Baïkal version (__0.4.6__ in this example)
```bash
RUN curl -LO https://github.com/fruux/Baikal/releases/download/0.4.6/baikal-0.4.6.zip && unzip baikal-0.4.6.zip && \
    rm -f baikal-0.4.6.zip
```
* Uncomment the `COPY` instructions to use the existing, previous version
  `config.php` and `config.system.php` files from the `./resources/` directory
```bash
# The Baïkal administration wizard creates these two config files when first run.  Preserve them
# and save them to the resources/ directory.  These files must be preserved for upgrades.
# Both files are already in the .gitignore file.
#
# To use them:  uncomment these two lines and copy them to the Specific/ directory, per the
# Baïkal upgrade instructions at:  http://sabre.io/baikal/upgrade/
COPY resources/config.php /var/www/calendar_server/Specific/
COPY resources/config.system.php /var/www/calendar_server/Specific/
```
* Build the new image and push it to Docker Hub

```bash
imageName="yourdockerhubname/calendar"; \
docker build -t "$imageName" --rm=true . && \
docker push "$imageName"
```

On the production calendar server:

* Kill the running Baïkal instance
```bash
docker stop calendar.service
docker rm calendar.service
```
* Pull the latest Baïkal image
```bash
docker pull "yourdockerhubname/calendar"
```
* Start an instance of the upgraded service in the `/home/calendar` directory:
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
```bash
docker ps -a
```
```
CONTAINER ID        IMAGE                        COMMAND             CREATED             STATUS              PORTS                  NAMES
83d209fefa91        yourdockerhubname/calendar   "/runapache2"       2 minutes ago       Up 2 minutes        0.0.0.0:8800->80/tcp   calendar.service
```
* Log on to the Baïkal admin page and confirm the new version; logging on to the
  admin page forces Baïkal to run its upgrade code, update the endpoints,
  update the database, and so on &mdash; __do not skip this step__.

## Implementation notes

### The config.sys and config.system.php files

These files are updated on every new installation.  They contain important,
site-specific data.  The most important datum is the `BAIKAL_ADMIN_PASSWORDHASH`
used for authentication.  Keep the configuration files in a safe place or
delete them after building the image.

### Help!  I deployed the upgrade without preserving the configuration files!

First:  _don't panic_.

Log on to the admin console as soon as the Baïkal instance is running and follow
the configuration wizard.  This will define the Only the `BAIKAL_ADMIN_PASSWORDHASH`
configuration files are changed.  The users, calendars, and address books 
database is intact, and will become available as soon as the configuration is
complete.

[1]: /baikal/docker-install/

