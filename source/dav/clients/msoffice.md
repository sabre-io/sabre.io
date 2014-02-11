---
type: client
name: Microsoft Office
---

Before MS Office 2000 there was no WebDAV support in the Office suite, but it
wasn't until Office 2003 when the company integrated a better client. For
information about how to work with WebDAV on versions prior to Office 2003,
you may find useful this page:

<http://www.atarex.com/services/support/webdav-msft.shtml>

The following observations of the Microsoft WebDAV client in Office was taken
using Word. Other applications of the suite may behave the same way.

Technical details
-----------------

Microsoft Office (at least Office 2k) uses the user agent:

    Microsoft Data Access Internet Publishing Provider DAV

### HEAD on collections

MS Office uses HEAD to find out if collections exist if it wants to create a
new collection. Before SabreDAV 1.1.0 alpha, we returned
`501 Not Implemented`, but this has since then been fixed. See [Issue 100][1]
for details.

### Authentication

Office understands both HTTP Basic and Digest authentication.

### Reading files

No problems found downloading and showing a document. Office will always
attempt to lock a file when opening, using `LOCK`.

### Writing files

Locks are required for saving, otherless MS Word will open the file as read
only.

If a file is locked, Office 2007 and 2010 will ask you if you want to open the
file as read only, download and modify it only in your computer or allow
editing while in background the lock is checked at an interval (usually less
than 20 seconds) until the file is released.

Once Office 2003 and 2007 gets the lock, it is updated at the "x" minutes
interval you specify in your SabreDav locks plugin (30 minutes by default),
but this time cannot be less than 180 seconds.

Office 2010 (Beta) has some kind of bug which makes the program don't update
the lock anymore, so if another client checks the lock after the timeout, the
lock will be released. This behaviour was observed in the Beta, so it may be
corrected by the final product version.

### Lockroot

It was discovered that certain versions of Office break if the
`{DAV:}lockdiscovery` property contains a `{DAV:}lockroot` element.

To fix this, you can hide this element using the following code snippet:

    \Sabre\DAV\Property\LockDiscovery::$hideLockRoot = true;

Hiding it hasn't caused any issues for other clients, so it should be safe to call this.
This issue has so far been reported for both Office 2000, and office 2003 clients.

### Properties

Microsoft office may perform the following request to update a file's properties:

    <D:propertyupdate xmlns:D="DAV:" xmlns:Z="urn:schemas-microsoft-com:">
        <D:set>
            <D:prop>
                <Z:Win32CreationTime>Mon, 12 Dec 2011 17:37:08 GMT</Z:Win32CreationTime>
                <Z:Win32LastAccessTime>Mon, 12 Dec 2011 17:37:08 GMT</Z:Win32LastAccessTime>
                <Z:Win32LastModifiedTime>Mon, 12 Dec 2011 17:37:08 GMT</Z:Win32LastModifiedTime>
                <Z:Win32FileAttributes>00002002</Z:Win32FileAttributes>
            </D:prop>
        </D:set>
    </D:propertyupdate>

However, it appears to disregard any existing locks on the resource, and
attempt to perform this request without any supplied lock tokens.

### Office 2011 for mac notes

When using the "Open URL" feature from Office 2011, it makes the following PROPFIND request:

    PROPFIND /filename.docx HTTP/1.1
    From: 127.0.0.1
    User-Agent: Microsoft Office
    Accept: */*
    Accept-Language: en
    Translate: f
    Brief: t
    Depth: 0
    Content-Type: text/xml; charset=utf-8
    Content-Length: 236
    Connection: Keep-Alive
    Host: localhost:80

    <?xml version="1.0" encoding="utf-8"?><D:propfind xmlns:D="DAV:"><D:prop><D:resourcetype/><D:getetag/><D:getcontentlength/><D:getmodifiedby/><D:creationdate/><D:getlastmodified/><D:lockdiscovery/><D:supportedlock/></D:prop></D:propfind>

#### {DAV:}supportedlock

This client had issues with how we encoded the `{DAV:}supportedlock`
property. This was fixed in SabreDAV version 1.7.4 and 1.8.2.

#### {DAV:}getlastmodified

This client also has issues with our encoding for 'getlastmodified', which
used to look something like this:

    <d:getlastmodified xmlns:b="urn:uuid:c2f41010-65b3-11d1-a29f-00aa00c14882/" b:dt="dateTime.rfc1123">Mon, 17 Dec 2012 18:42:59 GMT</d:getlastmodified>

Ironically, those extra attributes with the 'b' prefix were added to be
compatible with a different, older microsoft product. This is also fixed in
version 1.7.4 / 1.8.2.

#### Base url

It was reported that read-write access could not be achieved when running
SabreDAV on a url like `/server.php/file.docx`. After switching to the root
using mod_rewrite, this was no longer an issue.

Perhaps the client doesn't like the `.` in the url.

[1]: https://github.com/fruux/sabre-dav/issues/100
