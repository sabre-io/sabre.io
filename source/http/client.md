---
title: The HTTP client
product: http
layout: default
---

The `sabre/http` package also contains a simple wrapper around [cURL][4], which
will allow you to write simple clients, using the `Request` and `Response`
objects you're already familiar with.

It's by no means a replacement for something like [Guzzle][7], but it provides
a simple and lightweight API for making the occasional API call.

    use Sabre\HTTP;

    $request = new HTTP\Request('GET', 'http://example.org/');
    $request->setHeader('X-Foo', 'Bar');

    $client = new HTTP\Client();
    $response = $client->send($request);

    echo $response->getBodyAsString();

The client emits 3 events using [`sabre/event`][5]. `beforeRequest`,
`afterRequest` and `error`.

    $client = new HTTP\Client();
    $client->on('beforeRequest', function($request) {

        // You could use beforeRequest to for example inject a few extra headers.
        // into the Request object.

    });

    $client->on('afterRequest', function($request, $response) {

        // The afterRequest event could be a good time to do some logging, or
        // do some rewriting in the response.

    });

    $client->on('error', function($request, $response, &$retry, $retryCount) {

        // The error event is triggered for every response with a HTTP code higher
        // than 399.

    });

    $client->on('error:401', function($request, $response, &$retry, $retryCount) {

        // You can also listen for specific error codes. This example shows how
        // to inject HTTP authentication headers if a 401 was returned.

        if ($retryCount > 1) {
            // We're only going to retry exactly once.
        }

        $request->setHeader('Authorization', 'Basic xxxxxxxxxx');
        $retry = true;

    });

Asynchronous requests
---------------------

The client also supports doing asynchronous requests. This is especially handy
if you need to perform a number of requests, that are allowed to be executed
in parallel.

The underlying system for this is simply [curl's multi request handler][8],
but `sabre/http` provides a much nicer API to handle this.

Sample usage:

    use Sabre\HTTP;

    $request = new Request('GET', 'http://localhost/');
    $client = new Client();

    // Executing 1000 requests
    for ($i = 0; $i < 1000; $i++) {
        $client->sendAsync(
            $request,
            function(ResponseInterface $response) {
                // Success handler
            },
            function($error) {
                // Error handler
            }
        );
    }

    // Wait for all requests to get a result.
    $client->wait();

Check out `examples/asyncclient.php` for more information.

[4]: https://php.net/curl
[5]: https://github.com/sabre-io/event
[7]: http://guzzlephp.org/
[8]: https://php.net/curl_multi_init
