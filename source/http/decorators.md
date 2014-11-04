---
title: Request and Response decorators
layout: default
product: http
---

It may be useful to extend the Request and Response objects in your
application, if you for example would like them to carry a bit more
information about the current request.

For instance, you may want to add an `isLoggedIn` method to the Request object.

Simply extending Request and Response may pose some problems:

1. You may want to extend the objects with new behaviors differently, in
   different subsystems of your application,
2. The `Sapi::getRequest` factory always returns an instance of
   `Request` so you would have to override the factory method as well,
3. By controlling the instantiation and depend on specific `Request` and
   `Response` instances in your library or application, you make it harder to
   work with other applications which also use `sabre/http`.

In short: it would be bad design. Instead, it's recommended to use the
[decorator pattern][6] to add new behavior where you need it. `sabre/http`
provides helper classes to quickly do this.

Example:

    use Sabre\HTTP;

    class MyRequest extends HTTP\RequestDecorator {

        function isLoggedIn() {

            return true;

        }

    }

Our application assumes that the true `Request` object was instantiated
somewhere else, by some other subsystem. This could simply be a call like
`$request = Sapi::getRequest()` at the top of your application,
but could also be somewhere in a unit test.

All we know in the current subsystem is that we received a `$request` and
that it implements `Sabre\HTTP\RequestInterface`. To decorate this object,
all we need to do is:

    $request = new MyRequest($request);

And that's it, we now have an `isLoggedIn` method, without having to mess
with the core instances.

[6]: http://en.wikipedia.org/wiki/Decorator_pattern
