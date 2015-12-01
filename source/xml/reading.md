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

    $reader = new Sabre\Xml\Reader();
    $reader->xml($xml);

    print_r($reader->parse());

The output for this, is quite big:

    Array
    (
        [name] => {http://example.org/books}books
        [value] => Array
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

        [attributes] => Array
            (
            )

    )


Key-Value XML structures
------------------------

However, we can simplify this quite a bit. Our `book` element pretty much
looks like a key-value structure, so we can tell the parser this:

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/books}book' => 'Sabre\Xml\Element\KeyValue',
    ];
    $reader->xml($xml);

    print_r($reader->parse());

This creates the new output:

    Array
    (
        [name] => {http://example.org/books}books
        [value] => Array
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

        [attributes] => Array
            (
            )

    )


Other standard XML parsers
--------------------------

There's a number of standard XML parsers included, we show an example of each.

Assume that every example below here uses an xml document that looks like this:

    <?xml version="1.0"?>
    <root xmlns="http://example.org/">
        <elem1>value1</elem1>
        <elem2 att="attvalue">value2</elem2>
    </root>


### Base

The 'Base' parser is the default, it causes every element to be deserialized
as an array with three keys:

1. name
2. value
3. attributes

You don't ever need to specify it, as it's the default. This is how it would
look like:

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/}root' => 'Sabre\Xml\Element\Base',
    ];
    $reader->xml($xml);

    print_r($reader->parse());

Output:

    Array
    (
        [name] => {http://example.org/}root
        [value] => Array
            (
                [0] => Array
                    (
                        [name] => {http://example.org/}elem1
                        [value] => value1
                        [attributes] = Array ( )
                    )
                [1] => Array
                    (
                        [name] => {http://example.org/}elem2
                        [value] => value2
                        [attributes] = Array
                            (
                                [att] => attvalue
                            )
                    )
            )
        [attributes] => Array ( )
    )

### KeyValue

`KeyValue` flattens the array a bit. The assumption is that an element has a set
of child elements, and every child element only appears once.

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/}root' => 'Sabre\Xml\Element\KeyValue',
    ];
    $reader->xml($xml);

    print_r($reader->parse());

Output:

    Array
    (
        [name] => {http://example.org/}root
        [value] => Array
            (
                [{http://example.org/}elem1] => value1
                [{http://example.org/}elem2] => value2
            )

        [attributes] => Array
            (
            )

    )

### Elements

Using `Elements` implies you only care about element names, not about their
contents. This could be useful in case you use elements as a sort of 'enum'
structure:

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/}root' => 'Sabre\Xml\Element\Elements',
    ];
    $reader->xml($xml);

    print_r($reader->parse());

Output:

    Array
    (
        [name] => {http://example.org/}root
        [value] => Array
            (
                [0] => {http://example.org/}elem1
                [1] => {http://example.org/}elem2
            )

        [attributes] => Array
            (
            )

    )

### XmlFragment

In some cases you might want to allow 'free form XML' to be specified in for
example an API. Atom for instance allows XHTML to be embedded, and WebDAV
allows users to store custom properties consisting of complex xml structures
with their own namespaces.

XmlFragment extracts an entire XML subtree and creates a object that can be
stored in a database, and later on embedded in an xml document again:


    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/}root' => 'Sabre\Xml\Element\XmlFragment',
    ];
    $reader->xml($xml);

    print_r($reader->parse());

Output:

    Array
    (
        [name] => {http://example.org/}root
        [value] => Sabre\Xml\Element\XmlFragment Object
            (
                [xml:protected] =>
    <elem1 xmlns="http://example.org/">value1</elem1>
    <elem2 xmlns="http://example.org/" att="attvalue">value2</elem2>

            )

        [attributes] => Array
            (
            )

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

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
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
            $keyValue = Sabre\Xml\Element\KeyValue::xmlDeserialize($reader);

            if (isset($keyValue['title'])) {
                $book->title = $keyValue['title'];
            }
            if (isset($keyValue['author'])) {
                $book->author = $keyValue['author'];
            }

            return $book;

        },
    ];
    $reader->xml($xml);

    print_r($reader->parse());

This finally gives us the following output:

    Array
    (
        [name] => {http://example.org/books}books
        [value] => Books Object
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

        [attributes] => Array
            (
            )

    )


Using element classes
---------------------

The last example had 2 custom deserializers. We can also integrate straight
into the classes they are supposed to deserialize.

The following two classes rebuild the `Book` and `Books` classes so they can
parse themself from an XML document, and also write them in a new document:

    class Books implements Sabre\Xml\Element {

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

        function xmlSerialize(Sabre\Xml\Writer $writer) {

            foreach($this->books as $book) {
                $writer->write(['{http://example.org/books}book' => $book]);
            }

        }


    }
    class Book implements Sabre\Xml\Element {

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

        function xmlSerialize(Sabre\Xml\Writer $writer) {

            foreach($this->books as $book) {
                $writer->write([
                    '{http://example.org/books}title' => $this->title,
                    '{http://example.org/books}author' => $this->author,
                ]);
            }

        }

    }

To use this:

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/books}books' => 'Books',
        '{http://example.org/books}book' => 'Book',
    ];

    $reader->xml($xml);
    print_r($reader->parse());


Validate XML against a XSD
--------------------------

To validate XML content before parsing, use `setSchema()` inherited from `XMLReader`

    $reader = new Sabre\Xml\Reader();
    $validXml = $reader->setSchema('myschema.xsd')
    if ($validXml) {
        $reader->xml($xml);
        print_r($reader->parse());
    }


[1]: http://php.net/manual/en/book.xmlreader.php
