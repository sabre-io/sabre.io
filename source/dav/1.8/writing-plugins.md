---
title: Writing Plugins
layout: default
versions:
    "1.8": /dav/1.8/writing-plugins/
    "2.x": /dav/writing-plugins/
thisversion: "1.8"
---

sabre/dav uses an event system for plugin development. There's a big list of
supported events. Every [plugin](/dav/plugins) uses just these events to add
all the advanced functionality.


Handling an event
-----------------

Say we want to implement support for a new HTTP method, called `BREW`. We can
use the `unknownMethod` to handle any HTTP methods SabreDAV does not already
support.

The assumption in the following code snippet, is that there's already a
`$server` object, that's an intance of `Sabre\DAV\Server`.

    function brewHandler($method, $uri) {

        // Yea, globals are bad.. but read on.
        global $server;

        if ($method !== 'BREW') {
            return;
        }

        $server->httpResponse->sendBody('Coffee is under way!');
        return false;

    }

    $server->subscribeEvent('unknownMethod', 'brewHandler');

A few things to note in the previous example:

1. This specific event gets two arguments
2. `$method` is the HTTP method, such as `BREW`, `POST` or `GET`.
3. `$uri` is the path relative to the server's base path. It does not include
   a slash at the front.
4. In this example, we return nothing if the method is not `BREW`.
5. If the method is `BREW`, we return `false`.
6. `false` tells the server to _stop_ handling the event. We basically tell
   the server, "we handled the event, you can stop looking for a handler of
   this event".


Wrapping this in a plugin
-------------------------

If you have a few event handlers, and you would like to combine them into a
single class, you can turn this into a plugin class.

What follows, is an example that wraps the previous event handler into a
coffeepot plugin:

    class CoffeePlugin extends \Sabre\DAV\ServerPlugin {

        protected $server;

        function getName() {

            return 'coffee';

        }

        function initialize(\Sabre\DAV\Server $server){

            $this->server = $server;
            $server->subscribeEvent('unknownMethod', array($this, 'brewHandler'));

        }

        function getHTTPMethods($uri) {

            return array('BREW');

        }

        function brewHandler($method, $uri) {

            if ($method !== 'BREW') {
                return;
            }

            $this->server->httpResponse->sendBody('Coffee is under way!');
            return false;

        }

    }

Then if we want to use this plugin:

    $coffeePlugin = new CoffeePlugin();
    $server->addPlugin($coffeePlugin);

Events
------

The following events are supported in the server

### `report`

If an HTTP `REPORT` method is invoked, all subscribers to this event get the
opportunity to handle a `REPORT` request.

Example:

    function myReport($reportName,DOMDocument $dom, $uri) {

      // $reportName contains the report name in clark-notation.
      // For example:
      //
      // {DAV:}expand-properties

      return true;

    }

    $server->subscribeEvent('report','myReport');

### `beforeMethod`

beforeMethod is called whenever any http method handler is called.
this allows the event to override standard behaviour or block requests.

Example:

    function blockDELETE($methodName, $uri) {

      if ($methodname=='DELETE') throw new \Sabre\DAV\Exception\Forbidden();
      return true;

    }

    $server->subscribeEvent('beforeMethod','blockDELETE');

Note that the `$uri` argument was added in version 1.3.0

### `unknownMethod`

unknownMethod can be used to add support for new HTTP verbs (e.g.: `POST`).
An example can be seen higher up int the page.

### `beforeCreateFile`

This event is trigged before new files are created. Using this event it is
possible to intercept these actions and store them in a different spot.

Since 1.6 the 'parent' argument will also be sent along.

Example:

    function beforeCreateFile($path, $data, \Sabre\DAV\ICollection $parent) {

        if ($path=='somemagicpath') {
            file_put_contents('/tmp/createdfile',$data);
            return false;
        } else {
            return true;
        }

    }

    $server->subscribeEvent('beforeCreateFile','beforeCreateFile');

### `afterCreateFile`

This event is triggered, only if the creation of the file succeeded.

This event is only available since SabreDAV 1.6.

Example:

    function afterCreateFile($path, \Sabre\DAV\ICollection $parent) {

        // Do some logging here

    }

    $server->subscribeEvent('afterCreateFile','afterCreateFile');

### `beforeWriteContent`

This event is trigged before files are updated. Using this event it is
possible to intercept these actions, validate content or block them.

The 'node' and 'data' arguments are only available since version 1.6.

Example:

    function beforeWriteContent($path, \Sabre\DAV\IFile $node, &$data) {

        file_put_contents('/tmp/davlog', $path . " just got updated!\n",FILE_APPEND);

    }

    $server->subscribeEvent('beforeWriteContent','beforeWriteContent');

### `afterWriteContent`

This event is triggered, only if updating of an existing file succeeded.

This event is only available since SabreDAV 1.6.

Example:

    function afterWriteContent($path, \Sabre\DAV\IFile $node) {

        // Do some logging here

    }

    $server->subscribeEvent('afterWriteContent','afterWriteContent');

### `beforeBind`

This event is triggered whenever a new node is about to be created in the tree.
This is for example triggered by `PUT`, `MKCOL`, `COPY` and `MOVE`.

Example:

    function beforeBind($path) {

        if (permitted()) return true;
        else return false;

    }

    $server->subscribeEvent('beforeBind','beforeBind');

### `beforeUnbind`

This event is triggered whenever a node is about to be deleted. If an entire
tree of nodes is deleted, the event will only trigger once, for the top-level
node. The event is triggered by for example `DELETE`, and `COPY` and `MOVE` in
case the target resource was being overwritten.

Example:

    function beforeUnbind($path) {

        if (permitted()) return true;
        else return false;

    }

    $server->subscribeEvent('beforeUnbind','beforeUnbind');

### `afterUnbind`

This event is triggered after a node is deleted. If an entire tree of nodes is
deleted, the event will only trigger once, for the top-level node. The event is
triggered by for example `DELETE`, and `COPY` and `MOVE` in case the target
resource was being overwritten.

This event is only available since SabreDAV 1.6.

Example:

    function afterUnbind($path) {

        // Some logging could go here	

    }

    $server->subscribeEvent('afterUnbind','afterUnbind');

### `beforeLock`

The beforeLock event is triggered right before a resource is locked.
Intercepting this event allows you to block a users' lock, or change information
regarding the lock, such as the lock owner or lock timeout.

Example:

    function beforeLock($path, \Sabre\DAV\Locks\LockInfo $lock) {

        if (!permitted()) return false;

    }

    $server->subscribeEvent('beforeLock','beforeLock');

### `beforeUnlock`

The beforeUnlock event is triggered right before a resource is unlocked.
Intercepting this event allows you to block the unlock.

Example:

    function beforeUnlock($path, \Sabre\DAV\Locks\LockInfo $lock) {

        if (!permitted()) return false;

    }

    $server->subscribeEvent('beforeUnlock','beforeUnlock');

### `beforeGetProperties`

*Added in version 1.4*

This event is fired before all properties are collected. This will allow you
to add in any properties early in the process. Plugins use this to handle
properties, so that nodes don't have to.

Example:

    function beforeGetProperties($path, \Sabre\DAV\INode $node, &$requestedProperties, &$returnedProperties) {

      if (in_array('{DAV:}displayname', $requestedProperties) && $node instanceof CompanyX\MyNode) {

         $returnedProperties[200]['{DAV:}displayname'] = 'My fancy node';
         unset($requestedProperties['{DAV:}displayname']);

      }

    }

Both requested and returned properties are passed by reference. The
requestedProperties is a simple array with propertynames as values. If you
unset items from this list, it will ensure that subsequent lookups from other
sources (the property itself, and other plugins) won't look for that property
anymore.

returnedProperties is also an array, which looks like the following example:

    $properties = array(

        // 200 status code
        200 => array(
            '{DAV:}getcontenttype' => 'text/plain',
            '{DAV:}getcontentlength' => 1000,
        ),
        // These properties were not found
        404 => array(
            '{DAV:}yourmomsname' => null,
        )
    );

Properties are grouped by a HTTP status code. In each group there's a list of
properties with their values.

Note that if false is returned from this method, the node will be hidden from
directory listings and any further processing for properties is cancelled.

### `beforeGetPropertiesForPath`

*Added in version 1.7.8 and 1.8.6*

This event is fired before getPropertiesForPath is handled.
This allows you to intercept `PROPFIND` requests very early in the process.

The two main purposes of this are, to error early, or to pre-fetch certain
properties that are expensive to fetch one-by-one.

Example:

    function beforeGetPropertiesForPath($path, $requestedProperties, $depth) {

    }

    $server->subscribeEvent('beforeGetPropertiesForPath', 'beforeGetPropertiesForPath');

### `afterGetProperties`

This event is fired after all properties for a resource have been collected.
This allows you to rewrite, add or remove properties. The event receives 3
arguments:

* The path
* An array with properties (passed by reference)
* The `Sabre\DAV\INode` object

The third argument was added in SabreDAV 1.7.0.

The properties array is a multi-dimensional array. Simply put, it's built up as such:

    $properties = array(

        // 200 status code
        200 => array(
            '{DAV:}getcontenttype' => 'text/plain',
            '{DAV:}getcontentlength' => 1000,
        ),
        // These properties were not found
        404	=> array(
            '{DAV:}yourmomsname' => null,
        )
    );

Example:

    function afterGetProperties($uri, &$properties, \Sabre\DAV\INode $node) {

        if (isset($properties[404]['{DAV:}owner'])) {
            $propeties[200]['{DAV:}owner'] = 'evert';
            unset($properties[404]['{DAV:}owner']);
        }
        return true;

    }

    $server->subscribeEvent('afterGetProperties','afterGetProperties');


### `updateProperties`

This event is fired when properties are about to be updated, using for example
`PROPPATCH`. This allows plugins to handle updating certain properties, before
the standard subsystems get to it.

`$properties` - an associative array with properties that need to be updated.
The keys are the properties in clark-notation. If the value is null, it means
that the user requested to delete the property. Note that this argument is
passed by reference. If you choose to 'handle' updating the property, you must
remove the property from this array, so SabreDAV knows updating was successful.

`$result` - Another associative array. This array must contain the statuscodes
related to updating the properties. This array is indexed by a HTTP status code.
Each item has a list of properties as keys, the value for every property is null.

`$node` - An instance of `Sabre\DAV\INode`. This is the node that's actually
being updated. This argument was added for convenience.

If updating a property fails, you *must* return false to break the event chain.
Because updating properties should be atomic, any failure should result a
complete failure.

Example:

    /**
     * This example handles updating of the {DAV:}displayname property
     */
    function updateProperties(&$properties, &$result, \Sabre\DAV\INode $node) {
        if (!array_key_exists('{DAV:}displayname', $properties)) return;

        $newDisplayName = $properties['{DAV:}displayname'];
        // Do something relevant with the displayname here.

        // Success:
        $result[200]['{DAV:}displayname'] = null;

        // Unsetting the property so we don't get a double update
        unset($properties['{DAV:}displayname']);

    }

    $server->subscribeEvent('updateProperties','updateProperties');

### exception

*Added in version 1.7*

The server will trigger an 'exception' event whenever it's about to return an XML error document.

The actual exception is passed as the first argument.


Other examples
--------------

Check out `Sabre\DAV\Browser\Plugin`. This plugin generates HTML directory indexes
for GET requests to collections. This is useful if you want the contents of the
directory to be viewable by a browser.


Priority
--------

Sometimes it's needed to ensure your event handler is the first in the list to
be fired off. This can be achieved by adding a priority number to the argument
of subscribeEvent.

This should be used with care. The Authentication plugin uses this for example
to make sure authentication happens before any other process. The default
priority number is 100. Lower numbers for priorities will be fired off earlier.

Current reserved list of priorities (might be extended in the future). Please do not use any of these.

  * priority 10, set by the Auth plugin
  * priority 20 and 220, set by the ACL plugin (future)
  * priority 50, set by the Lock plugin
