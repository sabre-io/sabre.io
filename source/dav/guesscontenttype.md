---
title: GuessContentType
type: plugin
plugin_name: guesscontenttype
plugin_since: 1.1.0
---

By default SabreDAV is not aware of any contenttypes of any files. This is
because there is no reliable, portable and fast way to determine the
contenttype/mimetype of files.

The GuessContentType plugin guesses the contenttype of files by doing what
everybody else does; look at the extension.

If this plugin is added, it will only add a contenttype header/property for
files that are recognized and don't already supply a contenttype themselves. 

Note that GuessContentType is only available in version 1.1.0 and later.

Setup
-----

Add the plugin to your server.

    $server->addPlugin(new \Sabre\DAV\Browser\GuessContentType());

If you'd like to add more contenttypes, you can add values to the
`Sabre\DAV\Browser\GuessContentType::$extensionMap` property.
