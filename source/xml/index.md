---
title: sabre/xml
product: xml 
layout: default
---

An XML library for PHP you may not hate, sabre/xml is the simplexml for 2014.

If you are writing or consuming API's in PHP, chances are that you need to
work with xml. In some cases you may even prefer it.

You may have started with [SimpleXML][1] and after a while switched to using
[the DOM][2] after realizing SimpleXML is really not that simple if you
strictly use xml namespaces everywhere.

For writing XML, you may have found that using the DOM requires far too much
code, or you may simply generate your xml by `echo`ing strings, knowing that
it may not be the best idea.

sabre/xml hopes to solve your issues, by wrapping `[XMLReader][3]` and
`[XMLWriter][4]`, and providing standard design patterns around:

1. Quickly generating XML based on simple array structures.
2. Providing a simple xml-to-object mapping structure.
3. Re-usability of parsers.

Generating XML 
--------------

Genering XML largely follows the [XMLWriter][4] api, but a lot of useful
features have been tacked on.

    $xmlWriter = new Sabre\Xml\Writer();
    $xmlWriter->openMemory();
    $xmlWriter->startDocument();
    $xmlWriter->setIndent(true);
    $xmlWriter->namespaceMap = ['http://example.org' => 'b'];

    $xmlWriter->write(['{http://example.org}book' => [ 
        '{http://example.org}title' => 'Cryptonomicon',
        '{http://example.org}author' => 'Neil Stephenson', 
    ]]);
    
This will create the following document:

    <?xml version="1.0"?>
    <b:book xmlns:b="http://example.org">
     <b:title>Cryptonomicon</b:title>
     <b:author>Neil Stephenson</b:author>
    </b:book>

You can serialize objects by implementing `Sabre\Xml\XmlSerializable`. This
interface is designed to work identical to PHP 5.5's [JsonSerializable][5]. 


A simple parser example
-----------------------

    <?php

    $input = <<<XML
    <article xmlns="http://example.org/">
        <title>Hello world</title>
        <content>Fuzzy Pickles</content>
    </article>
    XML;

    $reader = new Sabre\Xml\Reader();
    $reader->elementMap = [
        '{http://example.org/}article' => 'Sabre\Xml\Element\KeyValue',
    ];
    $reader->xml($input);
    
    print_r($reader->parse());

This will output something like:

    Array
    (
        [name] => {http://example.org/}article
        [value] => Array
            (
                [{http://example.org/}title] => Hello world
                [{http://example.org/}content] => Fuzzy Pickles
            )

        [attributes] => Array
            (
            )

    )

The key in the last example, is that we tell the parser to treat the contents
of the `article` xml node as a key-value structure.

This is optional, but by adding this hint the resulting output becomes a lot
simpler.

The parser comes with a few parsing strategies for common needs, and you can
easily create your own by creating your own deserializer classes, or just by
proving a callback:

    $reader->elementMap = [
        '{http://example.org/}article' => function(Sabre\Xml\Reader $reader) {
            // Read the element's contents, and return the result here.
        }
    ];


[1]: http://php.net/manual/en/book.simplexml.php
[2]: http://ca2.php.net/manual/en/book.dom.php
[3]: http://php.net/manual/en/book.xmlreader.php
[4]: http://php.net/manual/en/book.xmlwriter.php
[5]: http://php.net/manual/en/class.jsonserializable.php
