---
title: Principals
layout: default
---

What are they?
--------------

Principals are, in the most general sense:

1. Something which you can assign privileges to.
2. Principals can be group-members of other principals.
3. Principals are represented by a resource in your 'WebDAV filesystem'.

The full definition for principals can be found in [rfc3744][1].

CalDAV, CardDAV and other specifications add more specific terminology
to what a principal is, such as:

1. It can represent a user.
2. It can represent a group of people.
3. It can represent a schedulable resource.
4. A principal resource often holds user-specific information, such as
   settings in the form of WebDAV properties.
5. It can represent a container for indirectly assiging privileges to other
   principals.

When a user is logged in, sabre/dav knows they are a certain principal, and
assigns this information to the `{DAV:}current-user-principal` property.

The principal can also belong to one or more group, and sabre/dav tracks
and caches this information as well, as the groups the current user belongs
to influences what a user is allowed to see and do on the server.


Do I need principals?
---------------------

Both [CalDAV][2] and [CardDAV][3] _require_ principals to work and exists.
If you are not building a CalDAV or CardDAV server, you may not need it.

You also _must_ use principals to take advantage of the [ACL][4] system. But for
some usecases implementing a fully-fledged ACL system _may_ be overkill.


What's the quickest way to deal with principals?
------------------------------------------------

sabre/dav ships with a 'backend class' that adds principals to your tree.
Principal information is stored in sqlite or mysql.

To instantiate this, add it to your 'root node'.

    $pdo = new PDO('sqlite:...');
    $principalBackend = new Sabre\DAVACL\PrincipalBackend\PDO($pdo);
    $nodes = [
        new Sabre\DAVACL\PrincipalCollection($principalBackend)
    ];

Note that in the sabre/dav `examples/` directory, the following three example
servers already have this:

1. `calendarserver.php`.
2. `addressbookserver.php`.
3. `groupwareserver.php`. (combines #1 and #2)

The database structure you need for principals can be found in one of:

1. `examples/sql/sqlite.principals.sql`.
2. `examples/sql/mysql.principals.sql`.
3. `examples/sql/psql.principals.sql` (untested).

The standard database structure has the following fields for the principals
table:

1. id
2. uri
3. displayname
4. email
5. vcardurl

`id` is just the primary key and sabredav doesn't really use this. `uri`
_must_ be a full path to the principal. If you didn't change any defaults
this means that this _must_ be in the format:

    principals/username

So if your username is "evert", the uri _must_ be:

    principals/evert

`displayname` is primarily used by the CalDAV plugin to search for users
with certain names. It's recommended to just fill in a full name here.

`email` _must_ be set if you do anything with CalDAV and invitations.

`vcardurl` is used and managed by the CardDAV plugin to implement the
so-called "me card" functionality.


Custom principal backends
-------------------------

Many users have a custom authentication system, and also want to integrate
their principals system with this.

If you'd like to do this, you can simply subclass

    Sabre\DAVACL\PrincipalBackend\AbstractBackend

We don't recommend subclassing:

    Sabre\DAVACL\PrincipalBackend\PDO

You are required to implement the following methods:

1. `getPrincipalsByPrefix` is primarily used to get a list of principals for
   a path. For instance, you may receive the string `principals` which means
   that you have to return every principal that starts with `principals/`.
2. `getPrincipalByPath` returns information for a single prefix.
3. `updatePrincipal`. You can just leave this method empty in most cases.
4. `searchPrincipals`. Implement this if you want to allow CalDAV users to
   use auto-completion when inviting users as attendees, sharees or delegates.
5. `findbyUri`. Implement this if you want to enable delivery of CalDAV
   scheduling inivtes.
6. `getGroupMemberSet`, `setGroupMemberSet`, `getGroupMemberShip` can be
   ignored if you don't care about grouping yet.

For more details about these methods, be sure to simply open

    Sabre\DAVACL\PrincipalBackend\BackendInterface

As there's much more detail in the actual source files.


### Provisioning

Lots of people add automatic provisioning of principals to their servers.
If you are interested in this, make sure that you add the 'hook' for
provisioning to your authentication backend, not the principals backend.

You only really want to provision urls if you are certain a user can
authenticate. The principals system, and in particular getPrincipalsByPath()
_may_ return false positives.

Custom principal URL schemes
----------------------------

By default sabre/dav assumes the following url structure:

    principals/username

However, it may be desirable to have a structure such as:

    principals/users/username
    principals/groups/groupname

sabre/dav supports custom structures very poorly, and this is something we
would like to solve in the future.

At the moment we strongly discourage this, but if you insist, the following
chapters explain what needs to be done. The chapters assume that you use 
both CalDAV and CardDAV. If you don't use either of them, just ignore the
related bits from those steps.

We also assume in all examples that your company is named `Acme` and you
created all your custom classes in the `Acme` namespace.

### PrincipalBackend

This is the most obvious: you need to alter your principals backend to
support multiple prefixes.

In particular, your `getPrincipalsByPrefix` method needs to assume it may
receive strings such as:

    principals/users
    principals/groups

And the same thing applies to `getPrincipalsByPath`.

### Root nodes

Your `$nodes`, or root nodes that you pass to the server, first had an
entry like this:

    $principalBackend = new Acme\PrincipalBackend();
    $nodes = [
        new Sabre\DAVACL\PrincipalCollection($principalBackend)
    ];

This needs to be changed to something like this:

    $principalBackend = new Acme\PrincipalBackend();
    $nodes = [
        new Sabre\DAV\SimpleCollection('principals', [
            new Sabre\DAVACL\PrincipalCollection($principalBackend, 'principals/users')
            new Sabre\DAVACL\PrincipalCollection($principalBackend, 'principals/groups')
        ]
    ];

### Doing the same for Cal- and CardDAV.

This is unfortunately a bit worse. It's not possible to correctly override the
paths for Cal- and CardDAV.

You need to subclass a total of 4 classes. *Note that this code is 100%
untested*.

    namespace Acme;

    use Sabre;

    class CalendarRoot extends Sabre\CalDAV\CalendarRoot {

        function getName() {

            // Grabbing all the components of the principal path.
            $parts = explode('/', $this->principalPrefix);

            // We are only interested in the second part.
            return $parts[1];

        }

    }

    class AddressBookRoot extends Sabre\CalDAV\AddressBookRoot {

        function getName() {

            // Grabbing all the components of the principal path.
            $parts = explode('/', $this->principalPrefix);

            // We are only interested in the second part.
            return $parts[1];

        }

    }

    class CalDAVPlugin extends Sabre\CalDAV\Plugin {

        function getCalendarHomeForPrincipal($principal) {

            if (!substr($principal, 0, strlen('principal/') !== 'principal/')) {
                throw new \LogicException('This is not supposed to happen');
            }
            return 'calendars/' . substr($principal,strlen('principal/')+1);

        }

    }

    class CardDAVPlugin extends Sabre\CardDAV\Plugin {

        function getAddressBookHomeForPrincipal($principal) {

            if (!substr($principal, 0, strlen('principal/') !== 'principal/')) {
                throw new \LogicException('This is not supposed to happen');
            }
            return 'addressbooks/' . substr($principal,strlen('principal/')+1);

        }

    }

Now lastly, you need make sure you're using your own new caldav and carddav
plugin, and your newly created node.

All these steps combined changes your server from this example:

    $principalBackend = new Acme\PrincipalBackend();
    $caldavBackend = new Sabre\CalDAV\Backend\PDO($pdo);
    $carddavBackend = new Sabre\CardDAV\Backend\PDO($pdo);

    $nodes = [
        new Sabre\DAVACL\PrincipalCollection($principalBackend)
        new Sabre\CalDAV\CalendarRoot($principalBackend, $caldavBackend),
        new Sabre\CalDAV\AddressBookRoot($principalBackend, $carddavBackend),
    ];

    $server = new Sabre\DAV\Server($nodes);

    $server->addPlugin(Sabre\CalDAV\Plugin());
    $server->addPlugin(Sabre\CardDAV\Plugin());

    $server->exec();

To this:

    $principalBackend = new Acme\PrincipalBackend();
    $caldavBackend = new Sabre\CalDAV\Backend\PDO($pdo);
    $carddavBackend = new Sabre\CardDAV\Backend\PDO($pdo);

    $nodes = [
        new Sabre\DAV\SimpleCollection('principals', [
            new Sabre\DAVACL\PrincipalCollection($principalBackend, 'principals/users')
            new Sabre\DAVACL\PrincipalCollection($principalBackend, 'principals/groups')
        ]
        new Sabre\DAV\SimpleCollection('calendars', [
            new Acme\CalendarRoot($principalBackend, $caldavBackend, 'principals/users'),
            new Acme\CalendarRoot($principalBackend, $caldavBackend, 'principals/groups'),
        ]
        new Sabre\DAV\SimpleCollection('addressbooks', [
            new Acme\AddressBookRoot($principalBackend, $carddavBackend, 'principals/users'),
            new Acme\AddressBookRoot($principalBackend, $carddavBackend, 'principals/groups'),
        ]
    ];

    $server = new Sabre\DAV\Server($nodes);

    $server->addPlugin(Acme\CalDAVPlugin());
    $server->addPlugin(Acme\CardDAVPlugin());

    $server->exec();


[1]: http://tools.ietf.org/html/rfc3744
[2]: /dav/caldav/
[3]: /dav/carddav/
[4]: /dav/acl/
