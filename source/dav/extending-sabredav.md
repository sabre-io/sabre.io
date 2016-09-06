---
title: Extending sabre/dav
layout: default
---

If you are writing your own classes to extend sabre/dav, either because you
are creating your own nodes, backend classes or plugins, you're extending
sabre/dav.

We've noticed a fair amount of people doing this incorrectly. If you already
know how to define your own classes in your own namespace and actively use
composer, you can skip this guide.


Pick a namespace
----------------

All sabre/dav classes start with `Sabre\`. You are not allowed to use this
namespace. Instead, pick a different namespace that matches your product or
company.

For example, the [Baikal][1] project extends sabre/dav in a few places, and
puts all its classes in a `Baikal\` namespace. If your product is named `Foo`,
you might want to put everything in a `Foo` namespace, or maybe `Foo\DAV`.


Use composer for installation
-----------------------------

You should no longer use the `.zip` file install sabre/dav. Instead, you
must use composer.

To do this, start with an empty directory and create a `composer.json` file
that contains something like this:

    { 
        "name" : "foo/dav",
        "description" : "This is the FOO WebDAV server",
        "require" : {
            "sabre/dav" : "~{{site.latest_versions.dav}}"
        },
        "autoload" : {
            "psr-4" : {
                "Foo\\" : "src/"
            }
        }
    }

A few things in this file are important:

* Both `name` and `description` are something you should determine.
* The `name` is usually in the format `vendor/product`, so if your company
  is called `foo` and the product is called `dav`, `foo/dav` is a good name.
* The `require` part tells composer that your product _requires_ sabre/dav at
  the given version, or a higher, compatible version.
* Lastly, the `autoload` section tells composer that all the files in the PHP
  namespace `Foo` can be found in the `src` directory.

After you've done this, run `composer install` on the command line to have it
automatically download sabre/dav in the `vendor` directory.

Later on you can run `composer update` to update sabre/dav to the latest
version.

Get your server.php in order
----------------------------

Usually the next step is to get your own `server.php` written. You can just
copy example files from `vendor/sabre/dav/examples`, and they should mostly
just work.

Add your own classes
--------------------

Say if you are defining your own auth backend, this might look something like:
 

    <?php

    namespace Foo\Auth;

    class Backend extends \Sabre\DAV\Auth\Backend\AbstractBasic {

        ...

    }

    ?>

Since this file defines `Foo\Auth\Backend`, it must live in the following
filename:

    src/Auth/Backend


Why `src`? Because that's what we've picked in `composer.json`.

If you've set it up correctly, your `server.php` will now automatically be
able to autoload the php files in your namespace.

The full directory structure
----------------------------

If you've completed all the earlier steps, the directory structure in your
project should now look like this:

* `composer.json`
* `composer.lock`
* `server.php`
* `src/`
  * `Auth/`
    * `Backend.php`
* `vendor/`
  * `sabre/`
    * `dav/`
    * `event/`
    * `http/`
    * `vobject/`
    * `xml/`


Why can't I write my classes in the `Sabre/` namespace?
-------------------------------------------------------

The main reason in that from a philosophical point of view, you don't own
or the sabre/dav project. The main reason people tend to make changes in the
`Sabre/` namespace, is because they think it's the only way they can extend
sabre/dav.

The biggest issue is that you are now effectivelty making 'changes' to the
sabre/dav project by adding files, or maybe even changing existing ones.

This makes it incredibly hard to figure out what you've changed, and to do
updates in the future.

In contrast, if you did things the correct way, upgrading sabre/dav might be
a matter of `composer update`.

In general this is also a fairly big 'offense' for any PHP development. This
is not at all unique to sabre/dav, but the issue was common enough to warrant
a guide on this website.

[1]: /baikal/
