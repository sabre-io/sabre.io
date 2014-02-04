---
name: Cadaver 
type: client
---

Cadaver is a simple command-line client, similar to for example the 'ftp'
program. It has some advanced features such as lock-management, property
management, DASL and version control support.

Connecting with Cadaver
-----------------------

    $ cadaver [url]

Technical details
-----------------

By default it will look for the following properties when using `ls`.

    <propfind xmlns="DAV:">
        <prop> 
            <getcontentlength xmlns="DAV:" /> 
            <getlastmodified xmlns="DAV:" /> 
            <executable xmlns="http://apache.org/dav/props/" /> 
            <resourcetype xmlns="DAV:" /> 
            <checked-in xmlns="DAV:" /> 
            <checked-out xmlns="DAV:" /> 
        </prop>
    </propfind>

It will also store custom properties, by default under the `http://webdav.org/cadaver/custom-properties/` namespace. 

It makes use of the propname request as well:

    <propfind xmlns="DAV:">
        <propname />
    </propfind>

This is at the time of writing not supported by SabreDAV, but is planned for a
future release.

Authentication
--------------

Cadaver understands both Digest and Basic HTTP authentication.
