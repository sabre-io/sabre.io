---
title: Requests, responses and the PHP SAPI
product: http
layout: default
---

On the PHP SAPI side, `sabre/http` basically wraps a number of concepts in PHP:

* `$_SERVER`,
* `$_POST`,
* `$_GET`,
* `$_FILES`,
* `php://input`,
* `echo()`,
* `header()`,
* `php://output`.

Effectively, it provides an OOP wrapper around these things. Half of these
items relate the HTTP request, and the other half to the HTTP response.

The easiest way to instantiate a request object is as follows:

    use Sabre\HTTP;

    include 'vendor/autoload.php';

    $request = HTTP\Sapi::getRequest();

This line should only happen once in your entire application. Everywhere else
you should pass this request object around.

You should always typehint on its interface:

    function handleRequest(HTTP\RequestInterface $request) {

        // Do something with this request :)

    }

You can create a response object as such:

    use Sabre\HTTP;

    include 'vendor/autoload.php';

    $response = new HTTP\Response();
    $response->setStatus(201); // created!
    $response->setHeader('X-Foo', 'bar');
    $response->setBody(
        'success!'
    );

After you have fully constructed your response, you must call:

    HTTP\Sapi::sendResponse($response);

This line should generally also appear once in your application (at the very
end).
