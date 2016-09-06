---
title: Frequently Asked Questions
layout: default
---

What is WebDAV?
---------------

WebDAV is a network filesystem protocol. You can compare it to for windows
networking, FTP, SFTP. The WebDAV protocol is supported natively by Microsoft
Windows, OS/X and pretty much any Linux distribution.

WebDAV is a protocol that sits on top of the HTTP protocol, because of this it
also works often through corporate firewalls.

See [Wikipedia][1] or [webdav.org][2] for more information.


What is SabreDAV?
-----------------

SabreDAV is a WebDAV server completely built in PHP. This means all you need
to enable WebDAV access to your Web server is PHP.

SabreDAV supports CalDAV, CardDAV and WebDAV as well as many other related
specifications. See [Standards Support](/dav/standards-support) for the full
list.


Is SabreDAV stable?
-------------------

SabreDAV has been deployed by live applications since 2007, and more than 98%
of the code is covered by unittests. It is currently in use by multiple
corporations. The largest installations manage addressbooks and calendars for
millions of users.

No software is bugfree though, but SabreDAV is actively maintained, so if
anything pops up we're usually quick to respond.


Why would I use SabreDAV instead of Apache's mod_dav?
-----------------------------------------------------

If [mod_dav][5] does what you need, you probably don't need SabreDAV. SabreDAV
is intended as an easily programmable webdav server. SabreDAV supports more
clients and also does Cal- and CardDAV, whereas mod_dav does not

If you don't have a need for those features, mod_dav is likely a better choice
as it's not written in PHP, and likely faster.


I'm getting a 'File not Found error' after getting started
----------------------------------------------------------

You may have a [base uri](/dav/baseuri/) problem.


It doesn't work!
----------------

DAV is tricky to debug, because unlike with building web applications, there
is no browser that simply shows you useful error messages.

The first step you should make, is to use the
[browser plugin](/dav/browser-plugin). This plugin creates directory indexes,
and will allow you to browse around using your standard webbrowser. If you're
already seeing errors there, it may give away quickly where your
problem is.

It's also recommended to keep an eye on the error log.

Failing that, we highly recommend setting up [Charles HTTP Proxy][6]. This
tool is pretty much running for us 24/7. Whenever we run into _any_ issue this
is where we start debugging.

If you're still running into issues, contact us on the [mailing list][7], or
[open an issue on github][8].


Authentication doesn't work
---------------------------

There are several server configurations that can affect whether authentication
will work. The [Authentication](/dav/authentication) and
[Webservers](/dav/webservers) wiki pages have more info.


Which clients are supported?
----------------------------

Almost every client we've gotten our hands on fully work, but for some there
may be some caveats, of you may be required to upgrade to a later version.

Check out the [Client list](/dav/clients) to get more infromation about a
specific client. If you're running into issues with a specific client, we
would [love to hear it][7] so we can see if we can devise a workaround, or
at least document the behavior.


Does SabreDAV pass the litmus test?
-----------------------------------

[Litmus](/dav/litmus) is a handy tool that helps you test your WebDAV server
for all standard features. The current status of the litmus test can be found
on the [Litmus](/dav/litmus) page.


Can SabreDAV work with large files?
-----------------------------------

Yes, read [Working with large files](/dav/large-files).


Does SabreDAV work with Microsoft Outlook?
------------------------------------------

Outlook does not support CalDAV, and therefore it is also not possible to sync
with SabreDAV (or any other CalDAV implementation).

However, there's an open source plugin called "Outlook Caldav Synchronizer"
that adds support.

More information here: <https://github.com/aluxnimm/outlookcaldavsynchronizer/>


I'm getting 0-byte files on the server
--------------------------------------

Read [0 bytes](/dav/0bytes).


I'm getting 405 errors
----------------------

See the [webservers](/dav/webservers) documentation.


How can I help?
---------------

We're definitely short on people. If you'd like to contribute, here are some
areas we could use some help with:

* Writing documentation. The documentation is coming along, but still a little
  sparse.
* Blog about the project! Tell us how you're using it.
* Core development.
* Sponsor a feature.
* Hire maintainers of this project to integrate WebDAV in your application.

SabreDAV is now developed at [fruux][12], for the last two items in this list
it would be best to [contact us](/support) to help you further.


I have a different question
---------------------------

Hit us up on the [mailing list][7].


I'd like to get commercial support
----------------------------------

SabreDAV is developed by [fruux][12]. If you're looking for enterprise-level
support, we'd love to [hear from you](/support)!


[1]: http://en.wikipedia.org/wiki/Webdav
[2]: http://webdav.org/
[3]: http://en.wikipedia.org/wiki/CalDAV
[4]: http://en.wikipedia.org/wiki/CardDAV
[5]: http://httpd.apache.org/docs/2.2/mod/mod_dav.html
[6]: http://www.charlesproxy.com/download/
[7]: http://groups.google.com/group/sabredav-discuss
[8]: https://github.com/fruux/sabre-dav/issues/new
[12]: https://fruux.com/
[13]: /dav/baseurl/
