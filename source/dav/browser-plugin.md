---
title: Directory Indexes
layout: default
type: plugin
plugin_name: browser 
plugin_since: 0.7.0 
---

If you try to open your sabredav webserver in a browser, you will by default
be greeted by an error.

SabreDAV ships with a plugin that adds directory indexes, just like many
webservers do. This makes your server a lot friendlier on the eyes when opening
it with a web browser, and is also extremely handy for debugging.

Setting up
----------

    // We assume $server is a Sabre\DAV\Server

    $plugin = new \Sabre\DAV\Browser\Plugin();
    $server->addPlugin($plugin);

That's all. If you don't like the default style (which is a bit plain), you
can extend the class and override the html generating methods.

