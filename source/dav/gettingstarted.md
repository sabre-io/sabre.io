---
title: Getting Started
layout: default
---

This is a basic tutorial that will help you create a simple fileserver.

Before starting this tutorial, make sure you have completed the
[Installation](/dav/install) steps.

Make sure you know what the exact path is to `vendor/autoload.php`. If you
did the composer install, it should be in your current directory. If you used
the zip, it will be where ever you unpacked the zip.

All examples assume that this file can be included as such:

    require 'vendor/autoload.php';

So if that's not the exact path to that file, make sure you change it.

A simple server
---------------

First, create a `data` and a `public` directory:

    mkdir data
    mkdir public

We will use the `public` directory to store all the files on the webdav
server.

The `data` directory contains other information SabreDAV needs.

Now we're making both world-writable:

    chmod a+rwx data public

Next, create a file called `server.php`, and enter the following:

    <?php

    use
        Sabre\DAV;

    // The autoloader
    require 'vendor/autoload.php';

    // Now we're creating a whole bunch of objects
    $rootDirectory = new DAV\FS\Directory('public');

    // The server object is responsible for making sense out of the WebDAV protocol
    $server = new DAV\Server($rootDirectory);

    // If your server is not on your webroot, make sure the following line has the
    // correct information
    $server->setBaseUri('/url/to/server.php');

    // The lock manager is reponsible for making sure users don't overwrite
    // each others changes.
    $lockBackend = new DAV\Locks\Backend\File('data/locks');
    $lockPlugin = new DAV\Locks\Plugin($lockBackend);
    $server->addPlugin($lockPlugin);

    // This ensures that we get a pretty index in the browser, but it is
    // optional.
    $server->addPlugin(new DAV\Browser\Plugin());

    // All we need to do now, is to fire up the server
    $server->exec();

The base url
------------

One line in the last code block has been a cause for a lot of confusion,
so it's important to get it right.

We're talking about this line:

    $server->setBaseUri('/url/to/server.php');

This path needs to point exactly to the server script. To find out what this
should be, try to open server.php in your browser, and simply strip off the
protocol and domain name.

So if this is how you access sabredav:

    http://mydomain/sabredav/server.php

Then your base url would be:

    /sabredav/server.php

If you want a prettier url, you _must_ use mod_rewrite or some other rewriting
system.

Testing
-------

After you got the base url correctly, you will want to see if it's working.
An easy first step is to just open the server in the browser.

If everything was done correctly, you should see a screen similar to the
following:

![Successful setup](/img/gettingstarted_1.png)

Client setup
------------

Next, you will want to start testing with a WebDAV client, to see if things
are working as expected.

Troubleshooting
---------------

Unlike with regular PHP web applications, it can sometimes be hard to figure
out what's wrong. Error messages are often not displayed by webdav clients,
so the only debugging feedback you're getting is a cryptic error.

Aside from inspecting your server in a web browser, and keeping an eye on
the php error log, we can highly recommend using a debugging proxy.

If your application emits an error, the debugging proxy is _the_ tool to
reveal it.

Some tools:

* [Charles][1] is an easy to use GUI proxy tool for every operating system.
  It's not free, but the free trial is available and runs long enough to
  get your started.
* [mitmproxy][2] is open source, runs in the cli and written in python. It's
  not as user-friendly, so we recommend only getting started with this after
  you're already a bit more comfortable with the rest of the toolset.

Next steps
----------

* Add [authentication](/dav/authentication) to your server.
* Read about [virtual filesystems](/dav/virtual-filesystems) and how you can
  create your own.
* The [temporary file filter plugin](/dav/temporary-files) can
  intercept those pesky `.DS_Store` and `desktop.ini` files.
* [CalDAV](/dav/caldav).
* [CardDAV](/dav/carddav).

[1]: http://www.charlesproxy.com/
[2]: http://mitmproxy.org/
