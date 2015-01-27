---
title: WebDAV client
layout: default
---

Since version 1.5, SabreDAV ships with an experimental WebDAV client. 
The reason it's currently marked as experimental, is not because of stability
issues, but because it's API is very likely to change in newer versions.

It's really only a simple wrapper around Curl, along with some methods
specifically for parsing and creating certain XML-based requests.

Usage
-----

### Creating the object

This is simply done with the following code:

    use Sabre\DAV\Client;

    include 'vendor/autoload.php';

    $settings = array(
        'baseUri' => 'http://example.org/dav/',
        'userName' => 'user',
        'password' => 'password',
        'proxy' => 'locahost:8888',
    );

    $client = new Client($settings);

Only the baseUri is required. This will be used to calculate any relative
paths. Proxy may be handy for debugging, but most people will likely not use
it.

### Simple requests

Any request can be done with the 'request' method. This method takes 4
arguments, but only the first is required.

Examples:

    // Will do a GET request on the base uri
    $response = $client->request('GET'); 

    // Will do a HEAD request relative to the base uri
    $response = $client->request('HEAD', 'stuff');

    // Will do a PUT request with a request body
    $response = $client->request('PUT', 'file.txt', "New contents");

    // Will do a DELETE request with a condition
    $response = $client->request('DELETE', 'file.txt', null, array('If-Match' => '"12345765"'));

The response will always contain an array with the following keys:

* *body* - response body
* *statusCode* - HTTP response status code
* *headers* - HTTP response headers

If the HTTP status was higher than 400 (any error) an exception will be thrown.

Any request will also automatically follow redirects.

### Doing a PROPFIND request

To make it easier to do 'PROPFIND' requests, a seperate method is available.

Example:

    $client->propfind('collection', array(
        '{DAV:}displayname',
        '{DAV:}getcontentlength',
    ));

The response will be an array with keys for properties that have been found.
Any property the server responded with an error to will simply be excluded.

To do a Depth: 1 request, simply add a '1' to the last argument. For Depth: 1
requests, the response will be a multi-level array. The first level will have
keys for urls, and lists of properties for values. 

### Doing a PROPPATCH request

Doing a proppatch request is very similar.

Example:

    $client->proppatch('collection', array(
        '{DAV:}displayname' => 'New displayname!',
    ));

The proppatch function will not return anything and it throws an exception
if there was an error.

If you want to delete any property, simply specify 'null' for the property-
value.

### Discovering WebDAV features

There's a simple convenience method to receive all the items from the 'Dav:'
response header. 

Simply call the following:

    $features = $client->options();

If you did indeed connect with a valid WebDAV server, the response will
at least contain '1' and '3', and things like 'calendar-access' for a CalDAV
server. The return value is an array.

If the server was not a WebDAV server, the response will be empty.


