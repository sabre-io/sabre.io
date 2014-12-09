---
title: Reading XML
product: xml
layout: default
---

sabre/xml has a reader class called `Sabre\Xml\Reader`. This class extends
PHP's built-in [`XMLReader`][1] class.

The reader is extended quite a bit. So while you can find the exact same API
methods as in PHP's class, the way you interact with the Reader will likely
look very different.


Converting XML to a PHP array
-----------------------------

Lets take the following XML as our primary example.

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

To convert this xml to a PHP array, we can just run this:

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

However, we can simplify this quite a bit. Our 'book' element pretty much
looks like a key->value structure, so we can tell the parser this:

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

Custom element parsers
----------------------

Lets take this one step further... We have a simple class that represents the
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
their respective xml elements:

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
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

The last example had 2 custom deserializers. We can also integrate straight
into the classes they are supposed to deserialize.

The following two classes rebuild the Book and Books classes so they can
parse themself from an xml document, and also write them in a new document:

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

[1]: http://php.net/manual/en/book.xmlreader.php
