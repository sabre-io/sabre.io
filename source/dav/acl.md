---
layout: default
type: plugin
plugin_name: acl
plugin_since: 1.4.0
---

ACL
===

Since version 1.4 SabreDAV comes with some support for ACL ([rfc3744][1]). At the
moment it is possible for nodes (files, directories) to define their own ACL,
so SabreDAV will automatically enforce it.

What the SabreDAV ACL plugin provides
-------------------------------------

What ACL is not:

* This will not magically work in WebDAV clients. In fact, none of the standard WebDAV clients I've tested have support for this. So even though ACL is enforced on the server, clients might not properly display ACL information, let alone change it.
* This will not allow you to lock down your filesystem. ACL support purely exists as a developer API if you create your own node classes.

What it does do:

  * The ACL system is used heavily by the CalDAV and CardDAV systems.
  * Most ACL rules are 'hardcoded', but these can be overridden by extending correct node classes.

Setting up
----------

To add ACL support, you can do so by adding the ACL plugin to your server:

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $server->addPlugin($aclPlugin);

Principals
----------

'Principals' are users or groups in WebDAV terminilogy. Privileges
(permissions) are assigned to principals.

A principal must exist in the directory tree. The easiest way to do this, is
to add a top-level 'principals' collection to your tree.

    use
      Sabre\DAVACL,
      Sabre\DAV;

    // Assuming we have a database connection
    $principalBackend = new DAVACL\PrincipalBackend_PDO($pdo);

    $tree = array(
        new DAVACL\PrincipalCollection($principalBackend),
        new My_Own_Collection_Class(),
    );

    $server = new DAV\Server($tree);

    $aclPlugin = new DAVACL\Plugin();
    $server->addPlugin($aclPlugin);

    $server->exec();


Advanced settings
-----------------

The ACL plugin has a couple of public properties that can alter it's behaviour.

### Administrators

Since version 1.6, SabreDAV now has an 'adminPrincipals' property. When a
principal url is added to this property, these urls will automatically be
injected in every single ACL rule with '{DAV:}all' privileges.

This implies that these principals get permission to do anything they want.

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $aclPlugin->adminPrincipals[] = 'principals/adminuser1';

### Locking down nodes without ACL information


By default the ACL plugin will grant access to any node that does not
implement `Sabre\DAVACL\IACL`. If you want to lock down access to any node
that does not have an explicit ACL list defined you can do this like so:

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $aclPlugin->allowAccessToNodesWithoutACL = false;

### Hiding nodes that the user does not have access to

By default inaccessible nodes will show up in directory listings, but any
attempts to read data or properties from them will result in a permission
denied error. Sometimes it's desirable to hide nodes from directory listings
altogether. You can do this like so:

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $aclPlugin->hideNodesFromListings = true;

### Determining the users principal url, based on their username

By default the ACL Plugin will try to find the Authentication plugin to
determine who's currently logged in. After that it will prepend the username
with 'principals/' to determine the correct principal path. If your users
are in for example principals/users you can change this as follows:

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $aclPlugin->defaultUsernamePath = 'principals/users';

Note that this path must not begin or end with a slash.

This property is only used in the `getCurrentUserPrincipal` method.

### Searching on principal properties

By default, the ACL plugin allows for searching for principals based on two
properties:

  * {DAV:}displayname
  * {http://sabredav.org/ns}email-address

To expand this to allow searching other (custom or not) properties, you can
add these in the following manner:

    $aclPlugin = new \Sabre\DAVACL\Plugin();
    $aclPlugin->principalSearchPropertySet[] = '{http://example.org/ns}my-prop';

[1]: http://tools.ietf.org/html/rfc3744
