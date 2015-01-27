---
title: Windows
type: client
---

Two client implementations: Web Client and Web Folders
------------------------------------------------------

Windows comes with two WebDAV clients. The preferred client is the "Web
Client" client, otherwise known as "mini-redirector". The older client is
known as "Web Folders".

Mapping to a drive letter via Web Client is quite beneficial, as it integrates
directly into your operation system. Web Folders will not allow you to edit
files directly, it will only allow you to drag and drop from and into a WebDAV
folder.

Using Web Client
----------------

1. Open 'Computer' from your start menu or desktop
2. Open the 'Map network drive' wizard
3. Enter the full http:// address to your webdav installation

Note that you need to have the Web Client service enabled and running for Web
Client to work. Some OS versions have it disabled, e.g. Windows Server 2003.
Additional some optimisation instructions lead to it being disabled.

Note that basic Auth will not work by default. Using either no authentication
at all or using Digest authentication will work.

You can also map a drive on the command line by typing:

    net use * http://example.org/dav/

Using Web Folders
-----------------

  # Open up Internet Explorer
  # Press File, Open and fill in the full url
  # Check the "Open as Web Folder" setting
  # Press Ok

Windows 7
---------

Windows 7 has a serious performance issue with WebDAV volumes. By default,
accessing WebDAV volumes on Windows 7 is very slow.

The issue can be solved by unchecking "Automatic Detect Settings" in IE8 /
Tools / Internet Options / Connections / LAN Settings.

See [this article with further information][1].

Windows Vista
-------------

On Windows Vista, if you use the Web Folders client, you may need to install
[Software Update for Web Folders (KB907306)][2] to avoid the following error:
"The folder you entered does not appear to be valid".

Windows Vista and earlier
-------------------------

These older implementations require the WebDAV service to sit at the root of a
domainname. There's no way you can connect to a url deeper in the WebDAV
structure, because it will traverse every part of the path and make PROPFIND
requests. So you have to make absolutely sure you have SabreDAV installed on a
root url. If you are using apache, you can use mod_rewrite to map every single
request to your WebDAV server, for example:

    RewriteEngine On
    RewriteRule ^/(.*)$ /server.php [L]

Windows XP
----------

Windows XP has even more quirks, and will treat the root of your WebDAV server
as if it was connecting to an SMB server. You'll notice that when you're
connecting, you will only see directories the root folder and they have icons
similar to windows shared folders. You can only really perform operations
within subdirectories on your root.

So:

make sure it is installed on the root of your domain, and make sure all
operations happen within sub-directories of your share.
The easiest way to do this is by simply creating a single top-level `/dav/`
directory.

Technical details
-----------------

User agents:

    Vista:
    Microsoft-WebDAV-MiniRedir/6.0.6000

    XP:
    Microsoft-WebDAV-MiniRedir/5.1.2600
    Microsoft Data Access Internet Publishing Provider DAV 1.1
    Microsoft Data Access Internet Publishing Provider Cache Manager

### MS-Author

Windows XP _requires_ the following HTTP header when making OPTIONS requests:

    MS-Author-Via: DAV

### Whitespace

Windows XP does not like whitespace in xml body responses for `PROPPATCH`
and `PROPFIND`. Make sure you send back the xml response with no whitespace
at all. It took the author a very long time to figure this out.

### Translate

Windows sends along a 'Translate: f' header along with every request. The idea
is that if you for example access a php file, and translate is set to 'f', you
would retrieve the php source file. If translate is set to 't', the php file
should be run and the output should be returned.

This is currently irrelevant to SabreDAV. We don't know how to trigger
`Translate: t` either, and we'd recommend against doing anything with it.

### Creating new files

Windows seems to perform the following actions when doing a PUT request:

1. Create an empty file using PUT
2. Lock the newly created file
3. PUT on the same file again with the actual file body
4. PROPPATCH request

### Properties

Windows XP requires a special format for the getlastmodified dav property in
the propfind response. An example is:

    <d:getlastmodified xmlns:b="urn:uuid:c2f41010-65b3-11d1-a29f-00aa00c14882/" b:dt="dateTime.rfc1123">Sat, 26 Apr 2008 18:00:18 -0400</d:getlastmodified>

This did no longer seem to be an issue with Windows XP SP3. Because this
actually causes an incompatibility with MS Office, this is removed as per
SabreDAV 1.7.4 and 1.8.2.

Windows XP requests the following webdav properties when making requests:

* name
* parentname
* href
* ishidden
* iscollection
* isreadonly
* getcontenttype
* contentclass
* getcontentlanguage
* creationdate
* lastaccessed
* getlastmodified
* getcontentlength
* resourcetype
* isstructureddocument
* defaultdocument
* displayname
* isroot

Windows (XP and Vista) introduces the following properties under the
`urn:schemas-microsoft-com:` xml namespace:

* Win32CreationTime (example: Sat, 26 Apr 2008 20:38:50 GMT)
* Win32LastAccessTime (same format)
* Win32FileAttributes (example: 00002020) indicates the classic MS-DOS properties, such as 'read only, hidden, archive, system' and a couple of newer ones. Haven't located detailed docs yet

### Character sets

Windows XP sends encoded characters in HTTP requests as ISO-8859-1. Possibly
even CP-1252, but this has yet to be verified.

A converter for this purpose has been included since SabreDAV-1.2.0alpha1.

However, this currently only works for converting the HTTP requests coming
from windows, and not yet responses to windows. Oddly enough, windows did seem
to accept UTF-8 strings. Files could be opened, but not written to. This is
probably only the case for UTF-8 filenames that don't cleanly map to
ISO-8859-1. A workaround for this will probably not happen in the short-term.

These issues are verified on Windows XP SP3, but no testing has been done on
Windows Vista or Windows 7.

### Another locking bug

Normally windows unlocks files with the following header in the UNLOCK request:

    Lock-Token: <opaquelocktoken:98b0726b-b34f-4778-9c35-da3927b6fe36>

For some reason however, it will specify it incorrectly.

    Lock-Token: opaquelocktoken:98b0726b-b34f-4778-9c35-da3927b6fe36

Starting SabreDAV 1.4.3 there's a workaround for this behaviour.

### File size limitations

Windows has introduced a file size limitation of 50000000 bytes in a security
update.

You may receive one of the following error messages while downloading a file
from a WebDAV volume:

* "Cannot Copy FileName: Cannot read from the source file or disk" (Windows
  Vista or XP SP1 with security update 896426 installed)
* "Error 0x800700DF: The file size exceeds the limit allowed and cannot be
  saved." (Windows 7)

The limitation can only be disabled on client side, by changing registry keys.
See [this article][3] for detailed instructions.

### {DAV:}displayname support

It was reported in earlier clients (XP at least, and perhaps Vista too) that
sending back a displayname can cause the client to use the displayname instead
of a url to access resources.

This will cause all kinds of bugs, so it's best to avoid `{DAV:}displayname`
entirely. It was was reported that this bug was 'fixed' in Windows 7 by taking
out support for `{DAV:}displayname` entirely.

### Authentication

HTTP Digest is support across the board. HTTP Basic auth can be used directly
from within IE, but will not work by default if you're using Web Client, unless
WebDAV is used over SSL.

Basic auth can be enabled if the following registry change is made:

* Create a new registry key called
  `HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters\UseBasicAuth` and
* Set the value to '1' (without quotes).

It was also reported that in certain cases
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters\BasicAuthLevel`
needs to be set to 2

  * [KB928692][4]
  * [KB841215][5]

Save the following to a `.reg` file and open it to simplify patching the
registry:

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters]
    "UseBasicAuth"=dword:00000001
    "BasicAuthLevel"=dword:00000002

In some cases Windows will incorrectly prepend the NT domain to the username
with two backslashes. Example:

    MYDOMAIN\\username

The workaround for this is making the user go through all the login prompts
(removing the NT domain), it will succeed after a while. It would also be
possible to automatically detect and strip out these usernames but that could
be problematic in relation to HTTP digest authentication.

### Further notes / quirks

It appears that Windows does not support ports other than the default (80).
Make sure your server is not running on a non-default http port.

### HTTPS / SNI problems

It was reported that the Windows 7 and 8 (and likely older clients as well) do
not support 'SNI' (server name identification), which is a technology that
allows virtual hosting of multiple HTTPS domains on one server.

If you're running into issues with this, make sure you don't host more than
one HTTPS-based domain off one ip address, or make sure that it's the default.

In the case of apache, the default https server would be the top-most
virtualhost definition.

### Caching

It was reported that Windows 7 has a 60 second cache, which may be frustrating
if you expect an immediate update.

This can be disabled using a registry key. See [http://technet.microsoft.com/en-us/library/ee683963%28v=ws.10%29.aspx](http://technet.microsoft.com/en-us/library/ee683963%28v=ws.10%29.aspx) for more info.


### More information

greenbytes.de has a [good list][6] with detailed information about some of
these bugs.

[1]: http://oddballupdate.com/2009/12/18/fix-slow-webdav-performance-in-windows-7/
[2]: http://www.microsoft.com/downloads/details.aspx?FamilyId=17C36612-632E-4C04-9382-987622ED1D64&displaylang=en
[3]: http://support.microsoft.com/kb/900900/en-us
[4]: http://support.microsoft.com/?scid=kb%3Ben-us%3B928692&x=21&y=17
[5]: http://support.microsoft.com/kb/841215
[6]: http://greenbytes.de/tech/webdav/webdav-redirector-list.html
