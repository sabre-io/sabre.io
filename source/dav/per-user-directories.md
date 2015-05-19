---
title: Per-user directories
layout: default
---

A question that comes up often on the mailing list, is how to create a WebDAV
server that has a personal space for files for each user.

sabre/dav does not have a standard facility to do this yet, so it's up to you
to write the logic. This tutorial assumes that you've followed and understood
the [Getting Started][1] and [Virtual Filesystems][2] documentation.


The Problem
-----------

It's not very hard to create a collection that has a directory for each user.

For instance, you may have a `home` collection as such:

    <?php

    namespace MyServer;

    use Sabre\DAV\Collection;
    use Sabre\DAV\FS;

    class HomeCollection extends Collection {

        protected $users = ['alice','bob','charly'];

        protected $path = '/opt/sabredav/userdir/';

        function getChildren() {

           $result = [];
           foreach($this->users as $user) {

                $result[] = new FS\Directory($path . '/' . $user);

           }
           return $result;

        }

        function getName() {

            return 'home';

        }

    }

This collection loops through an array of users, and automatically shows a
node for each user.

This is a bit simplistic. You would normally want the users array to come
from a database, and you really should also implement a `getChild()` method.

In addition, you could automatically call `mkdir()` to create new home
directories for users that don't have a home directory yet.

We assume that this is easy, and you figured all of this out. The problem
people immediately come across is that they don't want to allow users to get
access to other users' home directories.

This all comes down to the question, who is currently logged in?

Given this `server.php` file:

    <?php

    $tree = [
        new MyServer\HomeCollection();
    ];

    $server = new Sabre\DAV\Server($tree);

    $authBackend = new Sabre\DAV\Auth\Backend\PDO($pdo);
    $authPlugin = new Sabre\DAV\Auth\Plugin($authBackend);

    $server->addPlugin($authPlugin);

    $server->exec();

It's not easy to figure out who is currently logged in. This code can be
re-organized as such:

    <?php

    $authBackend = new Sabre\DAV\Auth\Backend\PDO($pdo);
    $authPlugin = new Sabre\DAV\Auth\Plugin($authBackend);

    $userName = $authPlugin->getUserName();

    $tree = [
        new MyServer\HomeCollection();
    ];

    $server = new Sabre\DAV\Server($tree);

    $server->addPlugin($authPlugin);
    $server->exec();

As you can see, the `$authPlugin` has a `getUserName()` function that gives
you the info, but there's a problem: `getUserName()` always returns `null`
at that point in time.


The simple solution
-------------------

The authentication plugin only starts doing work *after* the server has been
started with `$server->exec()`. The easiest way to work around this, is by
injecting the `$authPlugin` into our earlier `HomeCollection` class.

    <?php

    namespace MyServer;

    use Sabre\DAV\Collection;
    use Sabre\DAV\FS;
    use Sabre\DAV\Auth\Plugin as AuthPlugin;

    class HomeCollection extends Collection {

        protected $users = ['alice','bob','charly'];
        protected $path = '/opt/sabredav/userdir/';
        protected $authPlugin;

        function __construct(AuthPlugin $authPlugin) {

            $this->authPlugin = $authPlugin

        }

        /** ---snip--- **/

    }

Now you can determine right within `getChildren()` and `getChild()` wether or
a user is allowed to have access to a specific collection.

Just call `$this->authPlugin->getCurrentUser()` and return the nodes that are
appropriate for each user.


The better solution
-------------------

While the previous solution may be good enough for many, it's not our
preferred solution.

sabre/dav ships with a very advanced access-control system using the [ACL][3]
plugin and [principals][4] system.

This system allows you to determine per-node what any user may do. You could
for example:

1. Create admin users that have access to everything.
2. Put users in groups, and also create per-group collections.
3. Give users read-only access on a per-node basis.

This all sounds great, but it's also definitely a bit harder to implement. If
you are interested in this solution, you need a few things:

1. A working `principals/` directory structure.
2. You need to add the `Sabre\DAVACL\Plugin` plugin to the server.
3. Any nodes that you want to add Access control to, must implement
   `Sabre\DAVACL\IACL`.

We'll start with item number 3, and show you how to add the `IACL` interface
to these two classes:

* Sabre\DAV\FS\Directory
* Sabre\DAV\FS\File

Since we want to simply base our nodes on `Sabre\DAV\FS\Directory` and
`Sabre\DAV\FS\File`, but we need to add 5 identical methods from
`Sabre\DAVACL\IACL` to both of them, the fastest way to do this, is a trait:

    <?php

    namespace MyServer;

    trait ACLTrait {

        /**
         * This is a principal URL such as principals/alice
         */
        public $owner;

        /**
         * Returns the owner principal
         *
         * This must be a url to a principal, or null if there's no owner
         *
         * @return string|null
         */
        function getOwner() {

            return $this->owner;

        }

        /**
         * Returns a group principal
         *
         * This must be a url to a principal, or null if there's no owner
         *
         * @return string|null
         */
        function getGroup() {

            return null;

        }

        /**
         * Returns a list of ACE's for this node.
         *
         * Each ACE has the following properties:
         *   * 'privilege', a string such as {DAV:}read or {DAV:}write. These are
         *     currently the only supported privileges
         *   * 'principal', a url to the principal who owns the node
         *   * 'protected' (optional), indicating that this ACE is not allowed to
         *      be updated.
         *
         * @return array
         */
        function getACL() {

            return [
                [
                    'privilege' => '{DAV:}all',
                    'principal' => '{DAV:}owner',
                    'protected' => true,
                ]
            ];

        }

        /**
         * Updates the ACL
         *
         * This method will receive a list of new ACE's as an array argument.
         *
         * @param array $acl
         * @return void
         */
        function setACL(array $acl) {

            throw new \Sabre\DAV\Exception\Forbidden('Not allowed to change ACL's');

        }

        /**
         * Returns the list of supported privileges for this node.
         *
         * The returned data structure is a list of nested privileges.
         * See Sabre\DAVACL\Plugin::getDefaultSupportedPrivilegeSet for a simple
         * standard structure.
         *
         * If null is returned from this method, the default privilege set is used,
         * which is fine for most common usecases.
         *
         * @return array|null
         */
        function getSupportedPrivilegeSet() {

            return null;

        }

    }

Now to implement this trait in our new classes:

    <?php

    namespace MyServer;

    use Sabre\DAV\Exception\NotFound;

    class ACLDirectory extends Sabre\DAV\FS\Directory implements Sabre\DAVACL\IACL {

        use AclTrait;

        function __construct($path, $owner) {

            parent::__construct($path);
            $this->owner = $owner;

        }

        function getChild($name) {

            $path = $this->path . '/' . $name;

            if (!file_exists($path)) throw new NotFound('File with name ' . $path . ' could not be located');

            if (is_dir($path)) {

                return new ACLDirectory($path);

            } else {

                return new ACLFile($path);

            }
        }

        function getChildren() {

            $result = [];
            foreach(scandir($this->path) as $file) {

                if ($file==='.' || $file==='..') {
                    continue;
                }
                $result[] = $this->getChild($file);

            }

            return $result;

        }

    }

    class ACLFile extends Sabre\DAV\FS\File implements Sabre\DAVACL\IACL {

        use AclTrait;

        function __construct($path, $owner) {

            parent::__construct($path);
            $this->owner = $owner;

        }

    }

And lastly, instantiate our new classes correctly from the `HomeCollection` class:

    <?php

    namespace MyServer;

    use Sabre\DAV\Collection;

    class HomeCollection extends Collection {

        protected $users = ['alice','bob','charly'];

        protected $path = '/opt/sabredav/userdir/';

        function getChildren() {

           $result = [];
           foreach($this->users as $user) {

                $result[] = new ACLDirectory($path . '/' . $user, 'principals/' . $user);

           }
           return $result;

        }

        function getName() {

            return 'home';

        }

    }

But, since we already have a fully-working principals system, we can simplify
`HomeCollection` quite a bit, by making use of the existing classes for
this.

The `Sabre\DAVACL\AbstractPrincipalCollection` class only does one thing:
it loops through all the principals in a principal backend, and creates one
node per user.

This is how you could refactor your `HomeCollection` to use it:

    <?php

    namespace MyServer;

    use Sabre\DAVACL\AbstractPrincipalCollection;

    class HomeCollection extends AbstractPrincipalsCollection {

        protected $path = '/opt/sabredav/userdir/';

        function getName() {

            return 'home';

        }

        /**
         * This method returns a node for a principal.
         *
         * The passed array contains principal information, and is guaranteed to
         * at least contain a uri item. Other properties may or may not be
         * supplied by the authentication backend.
         *
         * @param array $principalInfo
         * @return IPrincipal
         */
        function getChildForPrincipal(array $principalInfo) {

            $principalUri = $principalInfo['uri'];
            $principalBaseName = basename($principalInfo['uri']); // will contain something like 'alice'.

            $principalDataPath = $this->path . $principalBaseName;
            if (!is_dir($principalDataPath)) {
                mkdir($principalDataPath);
            }

            return new AclDirectory($this->path. $principalBaseName, $principalUri);

        }

    }

And then lastly, to instantiate everything `server.php`:

    <?php

    $authBackend = new Sabre\DAV\Auth\Backend\PDO($pdo);
    $principalBackend = new Sabre\DAVACL\PrincipalBackend\PDO($pdo);

    $tree = [
        new MyServer\HomeCollection($principalBackend),
        new Sabre\DAVACL\PrincipalsCollection($principalBackend),
    ];

    $server = new Sabre\DAV\Server($tree);

    $authPlugin = new Sabre\DAV\Auth\Plugin($authBackend);
    $server->addPlugin($authPlugin);

    $aclPlugin = new Sabre\DAV\ACL\Plugin();
    $server->addPlugin($aclPlugin);

    $server->exec();

The sabre/dav 3.0 solution
--------------------------

Since sabre/dav 3.0 the last few classes are now actually built in. Simply add
`Sabre\DAVACL\FS\HomeCollection` to your tree.

You still need a working principals backend though.

[1]: /dav/gettingstarted/
[2]: /dav/virtual-filesystems/
[3]: /dav/acl/
[4]: /dav/principals/
