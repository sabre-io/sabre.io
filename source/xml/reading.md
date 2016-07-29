---
title: Reading XML
product: xml
layout: default
---

sabre/xml has a reader class called `Sabre\Xml\Reader`. This class extends
PHP's built-in [`XMLReader`][1] class.

The reader is extended quite a bit. So while you can find the exact same API
methods as in PHP's class, the way you interact with the reader will likely
look different.

Often you can just parse your XML documents by using the reader like this:

    $reader = new Sabre\Xml\Reader();
    $reader->xml($xml);
    $result = $reader->parse();

However, we recommend using the [Service][3] object instead. It's optional,
but it adds a few nice features. All of the following examples will be using
this boilerplate instead to parse XML:

    $service = new Sabre\Xml\Service();
    $result = $service->parse($xml);


Converting XML to a PHP array
-----------------------------

Let's take the following XML as our primary example.

    <?xml version="1.0" encoding="utf-8"?>
    <books xmlns="http://example.org/books">
        <book>
            <title>Snow Crash</title>
            <author>Neil Stephenson</author>
        </book>
        <book>
            <title>Dune</title>
            <author>Frank Herbert</author>
        </book>
    </books>

To convert this XML to a PHP array, we can just run this:

    $service = new Sabre\Xml\Service();

    print_r($service->parse($xml));

The output for this, is quite big:

    Array
        (
            [0] => Array
                (
                    [name] => {http://example.org/books}book
                    [value] => Array
                        (
                            [0] => Array
                                (
                                    [name] => {http://example.org/books}title
                                    [value] => Snow Crash
                                    [attributes] => Array
                                        (
                                        )

                                )

                            [1] => Array
                                (
                                    [name] => {http://example.org/books}author
                                    [value] => Neil Stephenson
                                    [attributes] => Array
                                        (
                                        )

                                )

                        )

                    [attributes] => Array
                        (
                        )

                )

            [1] => Array
                (
                    [name] => {http://example.org/books}book
                    [value] => Array
                        (
                            [0] => Array
                                (
                                    [name] => {http://example.org/books}title
                                    [value] => Dune
                                    [attributes] => Array
                                        (
                                        )

                                )

                            [1] => Array
                                (
                                    [name] => {http://example.org/books}author
                                    [value] => Frank Herbert
                                    [attributes] => Array
                                        (
                                        )

                                )

                        )

                    [attributes] => Array
                        (
                        )

                )
        )


Key-Value XML structures
------------------------

However, we can simplify this quite a bit. Our `book` element pretty much
looks like a key-value structure, so we can tell the parser to treat it as
such:

    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/books}book' => 'Sabre\Xml\Deserializer\keyValue',
    ];

    print_r($service->parse($xml));

This creates the new output:

    Array
    (
        [0] => Array
            (
                [name] => {http://example.org/books}book
                [value] => Array
                    (
                        [{http://example.org/books}title] => Snow Crash
                        [{http://example.org/books}author] => Neil Stephenson
                    )

                [attributes] => Array
                    (
                    )

            )

        [1] => Array
            (
                [name] => {http://example.org/books}book
                [value] => Array
                    (
                        [{http://example.org/books}title] => Dune
                        [{http://example.org/books}author] => Frank Herbert
                    )

                [attributes] => Array
                    (
                    )

            )

    )


### Stripping the XML namespaces

We added `keyValue` in our last example. `keyValue` really is simply a
function that gets automatically called. We can give that function a default
namespace, which will cause it to strip all namespace declarations if it
matches that specific namespace.

Our new code looks like this:


    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/books}book' => function(Reader $reader) {
            return Sabre\Xml\Deserializer\keyValue($reader, 'http://example.org/books');
        }
    ];

    print_r($service->parse($xml));

The new output:

    Array
    (
        [0] => Array
            (
                [name] => {http://example.org/books}book
                [value] => Array
                    (
                        [title] => Snow Crash
                        [author] => Neil Stephenson
                    )

                [attributes] => Array
                    (
                    )

            )

        [1] => Array
            (
                [name] => {http://example.org/books}book
                [value] => Array
                    (
                        [title] => Dune
                        [author] => Frank Herbert
                    )

                [attributes] => Array
                    (
                    )

            )


    )


### Parsing the `books` element as a collection of `book` items.

Lastly, in our XML object we have a root element `books` and a repeating child
element `book`. This too is a very common pattern in XML structures. We can
also instruct the parser to treat `books` as a collection of `book` and return
an even simpler array:

    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/books}book' => function(Reader $reader) {
            return Sabre\Xml\Deserializer\keyValue($reader, 'http://example.org/books');
        },
        '{http://example.org/books}books' => function(Reader $reader) {
            return Sabre\Xml\Deserializer\repeatingElements($reader, '{http://example.org/books}book');
        },
    ];

    print_r($service->parse($xml));

This last example will output:

    Array
    (
        [0] => Array
            (
                [title] => Snow Crash
                [author] => Neil Stephenson
            )

        [1] => Array
            (
                [title] => Dune
                [author] => Frank Herbert
            )
    )


Other standard XML parsers
--------------------------

There's a number of standard XML parsers included. Here's the list:


### keyValue

    Sabre\Xml\Deserializer\keyValue(Reader $reader, $namespace = null);

Example further up in this document.


### enum

    Sabre\Xml\Deserializer\enum(Reader $reader, $namespace = null);

This deserializer turns a bunch of xml elements into a flat PHP array.
Specifically it's intended for structures such as this:

    <fruit xmlns="urn:fruit">
        <apple>
        <banana>
        <orange>
    </fruit>

Parsing this:

    $service = new Sabre\Xml\Service();
    $service->elementMap['{urn:fruit}fruit'] = 'Sabre\Xml\Deserializer\enum';
    $result = $service->parse($xml);

    print_r($result);

This would yield:

    Array
    (
        [0] => {urn:fruit}apple
        [1] => {urn:fruit}banana
        [2] => {urn:fruit}orange
    )

You can also specify a default namespace, which will cause that namespace to be
stripped out. Example:

    $service = new Sabre\Xml\Service();
    $service->elementMap['{urn:fruit}fruit'] = function($reader) {
        return Sabre\Xml\Deserializer\enum($reader, 'urn:fruit');
    };
    $result = $service->parse($xml);

    print_r($result);

This would yield:

    Array
    (
        [0] => apple
        [1] => banana
        [2] => orange
    )

### repeatingElements

    Sabre\Xml\Deserializer\repeatingElements(Reader $reader, $childElementName);

repeatingElements is specifically tailored for XML structures that look like this:

    <collection xmlns="urn:fruit">
        <item>...</item>
        <item>...</item>
        <item>...</item>
        <item>...</item>
    </collection>

It allows to specifically say, `collection` always has a list of `item` elements
and please return those `item` element's values as an array.


### valueObject

    Sabre\Xml\Deserializer\valueObject(Reader $reader, $className, $namespace);

The valueObject deserializer function allows you to turn an XML element into
a PHP object of a specific class, mapping sub-elements to properties in the
class.

It's used internally by `Sabre\Xml\Service::mapValueObject`. Read more [here][2].


### XmlFragment

In some cases you might want to allow 'free form XML' to be specified in for
example an API. Atom for instance allows XHTML to be embedded, and WebDAV
allows users to store custom properties consisting of complex xml structures
with their own namespaces.

XmlFragment extracts an entire XML subtree and creates a object that can be
stored in a database, and later on embedded in an xml document again:


    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/}root' => 'Sabre\Xml\Element\XmlFragment',
    ];

    print_r($reader->parse($xml));

Output:

    Sabre\Xml\Element\XmlFragment Object
    (
                [xml:protected] =>
    <elem1 xmlns="http://example.org/">value1</elem1>
    <elem2 xmlns="http://example.org/" att="attvalue">value2</elem2>


    )


Custom element parsers
----------------------

Lets take this one step further… We have a simple class that represents the
books document:

    class Books {

        // A list of books.
        public $books = [];

    }

And we have a class for every book:

    class Book {

        public $title;
        public $author;

    }


By refactoring our parser a bit, we can automatically map these classes to
their respective XML elements:

    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        // handle a collection of books
        '{http://example.org/books}books' => function($reader) {
            $books = new Books();
            $children = $reader->parseInnerTree();
            foreach($children as $child) {
                if ($child['value'] instanceof Book) {
                    $books->books[] = $child['value'];
                }
            }
            return $books;
        },
        // handle a single book
        '{http://example.org/books}book' => function($reader) {
            $book = new Book();
            // Borrowing a parser from the KeyValue class.
            $keyValue = Sabre\Xml\Deserializer\keyValue($reader, 'http://example.org/books');

            if (isset($keyValue['title'])) {
                $book->title = $keyValue['title'];
            }
            if (isset($keyValue['author'])) {
                $book->author = $keyValue['author'];
            }

            return $book;

        },
    ];

    print_r($service->parse($xml));

This gives us the following output:

    Books Object
    (
        [books] => Array
            (
                [0] => Book Object
                    (
                        [title] => Snow Crash
                        [author] => Neil Stephenson
                    )

                [1] => Book Object
                    (
                        [title] => Dune
                        [author] => Frank Herbert
                    )

            )

    )



Using the XmlDeserializable interface
-------------------------------------

The last example had 2 custom deserializers. We can also integrate straight
into the classes they are supposed to deserialize.

The following two classes rebuild the `Book` and `Books` classes so they can
parse themself from an XML document, and also write them in a new document:

    class Books implements Sabre\Xml\XmlDeserializable {

        // A list of books.
        public $books = [];

        static function xmlDeserialize(Sabre\Xml\Reader $reader) {

            $books = new self();
            $children = $reader->parseInnerTree();
            foreach($children as $child) {
                if ($child['value'] instanceof Book) {
                    $books->books[] = $child['value'];
                }
            }
            return $books;

        }

    }

    class Book implements Sabre\Xml\XmlDeserializable {

        public $title;
        public $author;

        static function xmlDeserialize(Sabre\Xml\Reader $reader) {

            $book = new self();

            // Borrowing a parser from the KeyValue class.
            $keyValue = Sabre\Xml\Element\KeyValue::xmlDeserialize($reader);

            if (isset($keyValue['{http://example.org/books}title'])) {
                $book->title = $keyValue['{http://example.org/books}title'];
            }
            if (isset($keyValue['{http://example.org/books}author'])) {
                $book->author = $keyValue['{http://example.org/books}author'];
            }

            return $book;

        }

    }

To use this:

    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/books}books' => 'Books',
        '{http://example.org/books}book' => 'Book',
    ];

    print_r($service->parse($xml));


Using ValueObjects for this instead
-----------------------------------

While the former classmapping example is a good way to learn how to write custom
deserializers, using the 'value objects' feature this could have been simplified
even further.

The exact same result could have been achieved by registering the PHP classes as
value objects:

    $service = new Sabre\Xml\Service();
    $service->mapValueObject('{http://example.org/books}books', 'Books');
    $service->mapValueObject('{http://example.org/books}book', 'Book');

    print_r($service->parse($xml));

For more information about this feature, read [Value Objects][2]. Value Objects
are a great way to map very simple XML structures to simple PHP classes. As soon
as either the XML or PHP classes are no longer 'simple', you will likely still
need to write your own (de-)serializers.


Summary of parsing XML objects
------------------------------

1. By default sabre/xml will always parse an XML document into an array.
2. It is possible to map certain XML using `elementMap`.
3. In the elementMap you can specify a custom deserializer strategy for
   a specific element.
4. Often this is simply a PHP callback. The PHP callback receives the
   `Xml\Reader` object as its only argument.
5. Default readers are provided to aid with parsing common xml structures.
   Examples are `keyValue` and `elements`.
6. Instead of a callback, you can also specify a class. If this class
   implements `Sabre\Xml\XmlDeserializable`, then that function will be
   called to deserialize the element.


Tips for custom deserializing functions
---------------------------------------

If you either specify custom callbacks in `$elementMap`, or you are using
`Sabre\Xml\XmlDeserializable`, you will end up with a function that receives
an instance of `Sabre\Xml\Reader` such as this:


    function myDeserializer(Sabre\Xml\Reader $reader) {

    }

The reader extends PHP's [XMLReader][1] object. You _must_ absolutely make
sure that you read the _entire_ XML element, and not half way. The simplest
possible deserializer function looks like this:


    function myDeserializer(Sabre\Xml\Reader $reader) {

        $reader->next();
        return 'foo';

    }

The [`next()`](http://php.net/manual/en/xmlreader.next.php) function is a
function that specifically instructs the PHP XMLReader to simply skip
the element and anything inside of it.

From within your deserializer function you can also easily call upon other
deserializer functions to do the parsing for you:


    function myDeserializer(Sabre\Xml\Reader $reader) {

        $keyValue = Sabre\Xml\Deserializer\keyValue($reader);
        return 'foo';

    }

Because any deserializer function (such as `keyValue`) is responsible for
reading the entire node, we no longer need to call `next()` here.

sabre/xml also adds a `parseAttributes()` method to the Reader to easily
get a list of attributes. Here's a deserializer function that just returns
the attributes and ignores sub-elements:

    function myDeserializer(Sabre\Xml\Reader $reader) {

        $attributes = $reader->parseAttributes();
        $reader->next();
        return $attributes;

    }

Note that you must read attributes before anything else.

You can also ask the reader to parse the entire sub-tree for you:


    function myDeserializer(Sabre\Xml\Reader $reader) {

        $subTree = $reader->parseInnerTree();
        return 'foo';

    }

Right now we are not doing anything with `$subTree`, but for every child
element `$subTree` has the following:

    * name
    * value
    * attributes

`parseInnerTree` keeps your `$classMap` into consideration for this. So any
child elements that are class-mapped will also correctly be parsed into this
new structure.

However, it is also possible to temporarily override the entire `$classMap` for
the subtree. This allows to disable all custom deserializers or specify your
own, but _only_ during parsing of the subtree.


    function myDeserializer(Sabre\Xml\Reader $reader) {

        $classMap = $reader->classMap;
        $classMap['{urn:foo]some-child-element'] = 'NewDeserializer';

        $subTree = $reader->parseInnerTree($classMap);
        return 'foo';

    }


Validate XML against a XSD
--------------------------

To validate XML content before parsing, use `setSchema()` inherited from `XMLReader`

    $service = new Sabre\Xml\Service();
    $reader = $service->getReader();
    $validXml = $reader->setSchema('myschema.xsd')
    if ($validXml) {
        $reader->xml($xml);
        print_r($reader->parse());
    }


[1]: http://php.net/manual/en/book.xmlreader.php
[2]: /xml/valueobjects/
[3]: /xml/service/
