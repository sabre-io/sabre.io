---
title: sabre/xml
product: xml
layout: default
---

*An XML library for PHP you may not hate.*

If you are writing or consuming API's in PHP, chances are that you need to
work with XML. In some cases you may even prefer it.

You may have started with [SimpleXML][1] and after a while switched to using
[the DOM][2] after realizing SimpleXML is really not that simple if you
strictly use xml namespaces everywhere.

For writing XML, you may have found that using the DOM requires far too much
code, or you may simply generate your XML by `echo`ing strings, knowing that
it may not be the best idea.

sabre/xml hopes to solve your issues, by wrapping [`XMLReader`][3] and
[`XMLWriter`][4], and providing standard design patterns around:

1. Quickly generating XML based on simple array structures,
2. Providing a super simple XML-to-object mapping,
3. Re-usability of parsers.


Writing XML
-----------

    $xmlService = new Sabre\Xml\Service();
    $xmlService->namespaceMap = ['http://example.org' => 'b'];

    $xmlService->write('{http://example.org}book', [
        '{http://example.org}title' => 'Cryptonomicon',
        '{http://example.org}author' => 'Neil Stephenson',
    ]);

This will create the following document:

    <?xml version="1.0"?>
    <b:book xmlns:b="http://example.org">
     <b:title>Cryptonomicon</b:title>
     <b:author>Neil Stephenson</b:author>
    </b:book>

You can serialize objects by implementing `Sabre\Xml\XmlSerializable`. This
interface is designed to work identical to PHP 5.5's [`JsonSerializable`][5].

[Read all the details here][6].

Reading XML
-----------

    <?php

    $input = <<<XML
    <article xmlns="http://example.org/">
        <title>Hello world</title>
        <content>Fuzzy Pickles</content>
    </article>
    XML;

    $service = new Sabre\Xml\Service();
    $service->elementMap = [
        '{http://example.org/}article' => 'Sabre\Xml\Element\KeyValue',
    ];

    print_r($service->parse($input));

This will output something like:

    Array
    (
        [{http://example.org/}title] => Hello world
        [{http://example.org/}content] => Fuzzy Pickles
    )

The key in the last example, is that we tell the parser to treat the contents
of the `article` XML node as a key-value structure.

This is optional, but by adding this hint the resulting output becomes a lot
simpler.

The parser comes with a few parsing strategies for common needs, and you can
easily create your own by writing deserializer classes, or just by providing a
callback:

    $service->elementMap = [
        '{http://example.org/}article' => function(Sabre\Xml\Reader $reader) {
            // Read the element's contents, and return the result here.
        }
    ];

[Read all the details here][7].

[1]: https://php.net/manual/en/book.simplexml.php
[2]: https://php.net/manual/en/book.dom.php
[3]: https://php.net/manual/en/book.xmlreader.php
[4]: https://php.net/manual/en/book.xmlwriter.php
[5]: https://php.net/manual/en/class.jsonserializable.php
[6]: /xml/writing/
[7]: /xml/reading/
