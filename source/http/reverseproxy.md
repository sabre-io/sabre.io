---
title: Writing a reverse proxy
product: http
layout: default
---

With all these tools combined, it becomes very easy to write a simple reverse
http proxy.

    use
        Sabre\HTTP\Sapi,
        Sabre\HTTP\Client;

    // The url we're proxying to.
    $remoteUrl = 'http://example.org/';

    // The url we're proxying from. Please note that this must be a relative url,
    // and basically acts as the base url.
    //
    // If youre $remoteUrl doesn't end with a slash, this one probably shouldn't
    // either.
    $myBaseUrl = '/reverseproxy.php';
    // $myBaseUrl = '/~evert/sabre/http/examples/reverseproxy.php/';

    $request = Sapi::getRequest();
    $request->setBaseUrl($myBaseUrl);

    $subRequest = clone $request;

    // Removing the Host header.
    $subRequest->removeHeader('Host');

    // Rewriting the url.
    $subRequest->setUrl($remoteUrl . $request->getPath());

    $client = new Client();

    // Sends the HTTP request to the server
    $response = $client->send($subRequest);

    // Sends the response back to the client that connected to the proxy.
    Sapi::sendResponse($response);
