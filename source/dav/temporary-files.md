---
title: Temporary files
type: plugin
plugin_name: temporaryfilefilter
plugin_since: 0.9.0
---

If you run a WebDAV server that exposes something like database-records as
files, you may have run into the fact that operating systems tend to leave
around garbage files.

This sucks, because if your webdav server is for instance a list of blog-posts,
you may quickly accumulate a few blogposts with titles such as `desktop.ini`
or `.DS_Store`.

The temporary file filter plugin works by intercepting all HTTP requests that
attempt to create these types of files, and basically set these files aside.

If, after that, a client attempts to read, delete or modify those files it
created earlier, the temporary file filter will respond by returning the
actual uploaded file, without polluting your 'real' data.

Supported temporary files
-------------------------

* OS/X Resource forks (`._files`)
* OS/X `.DS_Store` files
* Windows' `desktop.ini` files
* Windows' `Thumbs.db` files
* ViM and Smultron temporary files

Requests for more types of files is appreciated. We want to make this thing as
effective as possible.

Usage
-----

To use this plugin, just add it to the server.

    use
        Sabre\DAV;

    $server = new DAV\Server($myTree);

    $tffp = new DAV\TemporaryFileFilterPlugin('/path/to/temporary/directory');
    $server->addPlugin($tffp);

A warning
---------

It is _not_ recommended to use this for standard file shares, where data
integrity is the most important. Other files may match these patterns, or
applications may store important data in these files.

The single intended use-case is situations such as the earlier example.
Places where the data you're receiving is strictly controlled.


Cleaning up
-----------

Currently the TemporaryFileFilter doesn't clean up temporary files. It is
recommended currently to create a cron-job to clean up files older than say, 24
hours.

SabreDAV ships with a tiny python script called 'naturalselection' in the bin/
directory that can automatically:

* Clean up files older than a certain age
* Automatically keep an eye on the total size of the temporary directory, and
  clean up files as soon as the size goes over a certain threshold, starting
  with the oldest.
