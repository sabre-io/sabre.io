---
title: Authentication
layout: default
type: plugin
plugin_name: auth
plugin_since: 0.9.0
---

After setting up your DAV server, you will probably want to add some security.
The standard way to do this, is to add HTTP Basic or HTTP Digest authentication
support.

sabre/dav comes with a plugin that handles authentication for you. It is
recommended to use this plugin, and it is required to use for both
[cal-](/dav/caldav) and [carddav](/dav/carddav).

The plugin can work with different backends. SabreDAV ships with a number of
backends, but it's also easy to create your own.

Backends
--------

SabreDAV comes with the following backends:

| Class                                  | Type   | Description |
|--------------------------------- ----- | ------ | ----------- |
| `Sabre\DAV\Auth\Backend\Apache`        | N/A    | Lets the webserver handle auhtentication |
| `Sabre\DAV\Auth\Backend\BasicCallback` | Basic  | Extremely easy way to create authentication from a custom source |
| `Sabre\DAV\Auth\Backend\File`          | Digest | Use a `htdigest` file for it's backend |
| `Sabre\DAV\Auth\Backend\PDO`           | Digest | Use a database, such as sqlite or mysql |

Using the PDO backend
---------------------

The PDO backend can either use MySQL or SQLite databases. An example for the
table creation can be found in the [source][1] in the examples/sql directory.

Assuming you already have a server up and running, add the plugin using the
following code:

    use Sabre\DAV\Auth;

    $pdo = new \PDO('sqlite:data/db.sqlite');
    // or alternatively:
    // $pdo = new \PDO('mysql:dbname=sabredav','username','password');

    // Throwing exceptions when PDO comes across an error:
    $pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

    // Creating the backend
    $authBackend = new Auth\Backend\PDO($pdo);

    // Creating the plugin. We're assuming that the realm
    // name is called 'SabreDAV'.
    $authPlugin = new Auth\Plugin($authBackend,'SabreDAV');

    // Adding the plugin to the server
    $server->addPlugin($authPlugin);

### The SQL table

The example scripts for the SQL tables automatically creates a user with the
username `admin` and password `admin`. Change this!

You might be confused by the `digesta1` field. This field actually contains
the hashed password. The password is stored in the following format:

    md5('username:realm:password');

The username and password speak for themselves, but it's important to keep
the `realm` in mind. This must be the very same realm you specified earlier
when creating the `Sabre\DAV\Auth\Plugin`.

If you choose to change the realm in the plugin, existing passwords will be
invalidated, because the hash changed for all of them.

Using the File backend
----------------------

The `Sabre\DAV\Auth\Backend\File` backend uses a simple file to store
usernames and passwords. The format of the file is identical to apache's
htdigest file.

If you have apache installed, there's a good chance you have a utility
to create and modify these files. You can verify this by typing `htdigest`
on the command line.

If you don't have htdigest installed, the format is rather simple.
Every user is on a single line (split by \n). Every line looks like:

    username:realm:digesta1

The username speaks for itself, the realm must be the exact same as the second
argument of the `Sabre\DAV\Auth\Plugin` constructor, and the digest a1 is,
just like with the PDO plugin the following hash:

    md5('username:realm:password');

So, given a username of 'foo', a password of 'bar', and a realm of 'SabreDAV',
the resulting hash should be:

    php -r "echo md5('foo:SabreDAV:bar');"
    5790c3784a79a018d1186528df520e11

Then our htdigest file looks like:

    foo:SabreDAV:5790c3784a79a018d1186528df520e11

To use this file:

    use Sabre\DAV\Auth;

    $authBackend = new Auth\Backend\File('/path/to/htdigest');
    $authPlugin = new Auth\Plugin($authBackend, 'SabreDAV');

    // Adding the plugin to the server
    $server->addPlugin($authPlugin);

Creating your own authentication backend
----------------------------------------

If you're going to add Digest authenticaton, use
`Sabre\DAV\Auth\Backend\AbstractDigest` as your parent class, and the
`Sabre\DAV\Auth\Backend\File` and `Sabre\DAV\Auth\Backend\PDO`
classes as examples.

If you're going to implement HTTP Basic, you must use
`Sabre\DAV\Auth\Backend\AbstractBasic` as your parent class and implement the
validateUserPass method.

Webserver configuration
-----------------------

Some webservers may require special configuration for authentication to work.
Take a look at [Webservers](/dav/webservers) for more information.

### Problems with safe mode

If 'safe mode' is enabled, PHP will automatically append a process id to authentication realms. This is problematic for Digest authentication, as it used the realm to determine the hash.

The solution to this is to either turn off Safe Mode, or using Basic authentication instead of Digest.

See [the PHP manual][2] for more information.

### Encoding issues

Avoid non-ascii characters for passwords. We've noticed that different clients
may use different encodings for passwords (windows may use CP-1252 and others
UTF-8), so each results in a different password string.

In the case of Basic authentication we _could_ normalize this (but we don't),
but in the case of Digest, different encodings result in completely different
hashes, and this is only fixable by pre-generating hashes for every potential
encoding.

SabreDAV does not do any of this, so stick to ASCII passwords.

Letting the webserver handle authentication
-------------------------------------------

Authentication can be directly handled by webservers as well. This approach
can be useful if you want to use advanced authentication methods provided by
Apache modules (for instance LDAP, Kerberos or SASL).

The backend to support this is called `Sabre\DAV\Auth\Backend\Apache`, to use
it add the plugin as follows:

    use Sabre\DAV\Auth;

    // Creating the backend
    $authBackend = new Auth\Backend\Apache();

    // Creating the plugin. The realm parameter is ignored by the backend
    $authPlugin = new Auth\Plugin($authBackend,'SabreDAV');

    // Adding the plugin to the server
    $server->addPlugin($authPlugin);

[1]: https://github.com/fruux/sabre-dav/tree/master/examples/sql
[2]: http://php.net/manual/en/features.http-auth.php
