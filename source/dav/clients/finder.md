---
title: Finder
type: client
---

Finder is OS X's built-in WebDAV client. It's been around for ages, and
it's pretty stable.

Your server _must_ have [Locking](/dav/locks) support in order to allow a user
to make modifications.

If the server does not supports locks, Finder will operate in read-only mode.

Connecting
----------

1. Open finder
2. Open the “Go” menu and press “Connect to Server” (or press Apple-K)
3. Fill in the full url to the webdav server, and hit connect

Technical information
---------------------

### Chunked encoding

Finder uses `Transfer-Encoding: Chunked` in PUT request bodies. This is a
little used HTTP feature, and therefore not implemented in a bunch of
webservers. The only server I've seen so far that handles this reasonably well
is Apache + mod_php. Nginx and Lighttpd respond with 411 Length Required,
which is completely ignored by Finder. This was seen on nginx 0.7.63.
It was recently reported that a development release (1.3.8) no longer had this
issue.

When using this with Apache + FastCGI PHP completely drops the request body,
so it will seem as if the PUT request was succesful, but the file will end up
empty.

### Softlinks

Finder will throw an error if an attempt is made to create or copy softlinks.

### Excessive requests

Two big problems with Finder are that it leaves a lot of files behind (such as
`.DS_Store` and all the `._.*` files. The second problem is that it makes such
a massive amount of HTTP requests, that as a result it's quite a slow client.

This is especially noticable in low-latency situations (e.g.: over the
internet). A good non-fee alternative that does this much better for OS X is
[Transmit](/dav/clients/transmit).

Here's a sample of the HTTP requests Finder makes when it connects to a new
webdav share:


* `OPTIONS [baseurl]` - First it checks, as it should if this is a valid WebDAV server
* `PROPFIND [baseurl]` - Properties of root path
* `PROPFIND [baseurl]` - Exact same query, except now it's asking for quota information (could have been merged with step #2)
* `PROPFIND [baseurl]` - Exact same as request #2
* `PROPFIND [baseurl]` - Another one, exact same
* `PROPFIND [baseurl]` - Same thing
* `PROPFIND [baseurl]` - You guessed it
* `PROPFIND [baseurl]` - sigh..
* `PROPFIND [baseurl]/mach_kernel` - It's looking for the kernel image, not sure why..
* `PROPFIND [baseurl]/.Spotlight-V100` - Looking for spotlight configuration
* `PROPFIND [baseurl]/._.` - OS/X stores resource data in a file of the format `._filename` This file is used to store additional meta-data for filesystem that don't support this. It's really annoyhing and OS/X does it on windows shares too
* `PROPFIND [baseurl]/Backups.backupdb` - Backup configuration
* `PROPFIND [baseurl]/._.` - Exact same thing as before
* `PROPFIND [baseurl]/.metadata_never_index` - haven't looked up what this means
* `PROPFIND [baseurl]/Backups.backupdb` - Same as before
* `PROPFIND [baseurl]/Backups.backupdb` - OS/X tries it twice, just to be sure
* `PROPFIND [baseurl]/._.` - Redundant again
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/.metadata_never_index` - Redundant
* `PROPFIND [baseurl]` - Redundant
* `PROPFIND [baseurl]/Contents` - Not sure what this file means
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/mach_kernel` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Backups.backupdb` - redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/.DS_Store` - Finder stores things like the background and other directory-specific settings
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/mach_kernel` - redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/._.` - Redundant
* `PROPFIND [baseurl]/Backups.backupdb` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl]/Contents` - redundant
* `PROPFIND [baseurl] - Redundant`
* `PROPFIND [baseurl] - Redundant`
* And lastly it downloads every single file in the folder, regardless of the size..

So, as a result of all this. Finder is among the slowest of WebDAV clients. A
lot of these should be easily fixable, as they're just redundant requests.
It was reported that this has improved much since OS X 10.8.

Resource-fork request seem to most common, and sometimes Finder can even go
into a loop trying to request the fork every x seconds. This can be migitated
by always sending back a valid resource fork.

A small optimization you can make on the client side is to disable creation of
`.DS_Store` files. Run the following from a terminal to achieve this:

    defaults write com.apple.desktopservices DSDontWriteNetworkStores true

Note however that this will disable .DS_Store for all network drives, not just
your WebDAV drives.

Finder luckily has good support for the Content-Range header. This will
reduce the actual size of the requires bodies quite well.

### User Agents

    WebDAVFS/1.5 (01508000) Darwin/9.2.2 (i386)
    WebDAVFS/1.7 (01708000) Darwin/9.4.0 (i386)
    WebDAVFS/1.7 (01708000) Darwin/9.6.0 (i386)

### Content-length required

Finder requires all files to have the Content-Length header, without it,
you'll get really strange results.

### Properties

For files and directories, Finder will request the following properties:

* getlastmodified
* getcontentlength
* resourcetype

Rarely it will also ask for `appledoubleheader`, defined in the
`http://www.apple.com/webdav_fs/props/` namespace. This seems to be an
alternative way to request the resource forks, but Finder doesn't follow its
own standard and still requests for `._filename`-type requests. You can freely
ignore this.

Initially, Finder will make a seperate request to retrieve the quota
information, using the following properties:

* quota-available-bytes
* quota-used-bytes
* quota
* quotaused

So far I haven't been able to figure out where 'quota' and 'quotaused' are
defined, and what they should contain.

Just using the standard quota-available-bytes and quota-used-bytes from
[rfc4331][rfc4331] works, however.

Finder does not deal well with timezones, and treat every time from
getlastmodified as UTC. Therefore it's best to send back all getlastmodified
properties in the UTC timezone.

### Authentication

Both Basic and Digest authentication are supported by Finder.

### Character sets

OS/X Finder uses UTF-8 to encode non-latin characters. The encoding it uses
for characters such as the u-umlaut is `u%CC%88` (a lowercase u + unicode
codepoint U+0308).

A more common encoding is `%C3%BC` (`U+00FC`), which is a single codepoint for
the u-umlaut, instead of the combination. All these characters can be
normalized with PHP 5.3's Normalizer class. More information about
normalization can be found in the [PHP Manual][1].

Currently SabreDAV does not normalize, but it might in the future if there's
sufficient interest.

[rfc4331]: https://tools.ietf.org/html/rfc4331
[1]: http://kr2.php.net/manual/en/class.normalizer.php
