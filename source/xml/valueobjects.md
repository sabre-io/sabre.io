---
title: Value Objects
product: xml
layout: default
---

Since version 1.3, sabre/xml comes with a new facility to map XML elements to
PHP classes, in two directions: Value Objects.

Setup
-----

To demonstrate, lets take the following (partial) atom feed:

    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
     <title>Example Feed</title>
     <link href="http://example.org/"/>
     <updated>2003-12-13T18:30:02Z</updated>
     <author>
       <name>John Doe</name>
     </author>
     <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>

     <entry>
       <title>Atom-Powered Robots Run Amok</title>
       <link href="http://example.org/2003/12/13/atom03"/>
       <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
       <updated>2003-12-13T18:30:02Z</updated>
       <summary>Some text.</summary>
     </entry>

    </feed>

A PHP classes implementation might look something like this:

    namespace My\Atom;

    class Feed {

        public $title;
        public $link = [];
        public $updated;
        public $author;
        public $id;
        public $entry = [];

    }

    class Author {

        public $name;
        public $email;

    }

    class Entry {

        public $title;
        public $link = [];
        public $id;
        public $updated;
        public $summary;

    }

To let sabre/xml automatically map between these two, simply use the Service
class:

    $service = new Sabre\Xml\Service();
    $service->namespaceMap['http//www.w3.org/2005/Atom'] = 'atom';

    $service->mapValueObject('{http://www.w3.org/2005/Atom}feed', 'My\Atom\Feed');
    $service->mapValueObject('{http://www.w3.org/2005/Atom}author', 'My\Atom\Author');
    $service->mapValueObject('{http://www.w3.org/2005/Atom}entry', 'My\Atom\Entry');

In case you are curious about the weird notation with the `{` and `}`, read
[clark-notation][2].

If you are running PHP 5.5 and up, you can also use `::class`. Example:

    $service->mapValueObject('{http://www.w3.org/2005/Atom}feed', Feed::class);
    $service->mapValueObject('{http://www.w3.org/2005/Atom}author', Author::class);
    $service->mapValueObject('{http://www.w3.org/2005/Atom}entry', Entry::class);

The `::class` construct basically returns a full class name. Because it's no
longer specified as a string, you can import classes into the current scope.


Parsing
-------

After that, all it takes to parse the atom feed is:

    $feed = $service->parse($xml);
    // Feed is an instance of My\Atom\Feed;

To automatically throw an error if the root xml element is an atom feed,
you can also use the `expect` method instead of `parse`.

    $feed = $service->expect('{http://www.w3.org/2005/Atom}feed', $xml);
    // Feed is an instance of My\Atom\Feed;


Writing
-------

Writing is similarly easy. Given that you have a `$feed` variable which refers
to a fully setup `My\Atom\Feed` object, all you have to do is call the following:

    $xml = $service->writeValueObject($feed);


How it works
------------

When you pass a classname to `mapValueObject`, sabre/xml automatically creates
an instance of that class when it comes across the element name you specified.

Take for instance this portion of the XML document:

     <entry xmlns="http://www.w3.org/2005/Atom">
       <title>Atom-Powered Robots Run Amok</title>
       <link href="http://example.org/2003/12/13/atom03"/>
       <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
       <updated>2003-12-13T18:30:02Z</updated>
       <summary>Some text.</summary>
     </entry>

When we call the following function:

    $service->mapValueObject('{http://www.w3.org/2005/Atom}entry', 'My\Atom\Entry');

We are basically saying:

* Map the element `entry`.
* In the XML namespace `http://www.w3.org/2005/Atom`
* To the PHP class `My\Atom\Entry`.

In this example all the child elements (`title`, `link`, `id`) are also all in
the same XML namespace. If this is the case, we will see if the class
`My\Atom\Entry` has a `public` property with the same name, and set its value.

If entry had sub-elements in a different XML namespace, they would be discarded.

One special trick is that if you define your class with a property and give it
a default value that's an array, `sabre/xml` will immediately assume that more
than one element may appear. In the above example, both `$authors` and `$entry`
was defaulted to an empty array. This signals `sabre/xml` that multiple
`<author>` and `<entry>` elements may appear as children and it will append
those to the array.


Under the hood
--------------

Ultimately this only works for simple mappings. As soon as your objects have
multiple namespaces, or if you need to parse out attributes, ValueObjects are
immediately too simplistic for you.

In those cases you need to write custom serializers/deserializers for your
objects. If you paid attention to the examples so far, you will have noted
that the atom feed contained this element:

       <link href="http://example.org/2003/12/13/atom03"/>

The parser in fact discarded the `href` atttribute and its value. The only
way around that is to write a custom deserializer.

The following example demonstrates how you would parse `<link>`. First, we
need a class representing atom links:

    namespace My\Atom;
    class Link {

        public $href;
        public $rel;
        public $type;
        public $hrefLang;
        public $title;
        public $length;

    }

And now, a custom deserializer, defined on the Service:

    $service->elementMap['{http://www.w3.org/2005/Atom}link'] = function($reader) {

        $link = new My\Atom\Link();
        foreach($reader->parseAttributes() as $key=>$value) {

            if (isset($link->{$key})) {
                $link->$key = $value;
            }

        }
        // Tell the reader we are done with this element
        $reader->next();
        return $link;

    };

The serializer is even simpler:

    $server->classMap['My\Atom\Link'] = function($writer, $link) {

        $writer->writeAttributes(
            get_object_vars($link)
        );

    }

Under the hood, that's also how the `mapValueObject` operates. It adds a
mapping to both the `$elementMap` and `$classMap`.


A more complete atom example
----------------------------

We've built a full atom parser for demonstrational purposes. You can find it
on [GitHub][3] and [Packagist][4].


[1]: https://tools.ietf.org/html/rfc4287
[2]: /xml/clark-notation/
[3]: https://github.com/fruux/sabre-xml-atom "Atom XML parser for PHP"
[4]: https://packagist.org/packages/sabre/xml-atom "Atom XML parser for PHP"
