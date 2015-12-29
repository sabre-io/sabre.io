---
title: The XML service
product: xml
layout: default
---

While sabre/xml has a separate reader and writer class, it also offers a
central service class. This class may be used as a design pattern to globally
configure your xml readers and writers.

This service can be injected in your dependency injection container or service
locator.

We fully intend developers to take this class and subclass it to configure and
add to the object to make it as useful as possible.

The service class
-----------------

This is the service class in birds eye view:


    namespace Sabre\Xml;

    class Service {

        /**
         * List of parsers for specifix XML objects.
         */
        public $elementMap = [];

        /**
         * List of prefixes for XML namespaces
         */
        public $namespaceMap = [];

        /**
         * List of PHP classes and custom serializers for them.
         */
        public $classMap = [];

        /**
         * Parses a document.
         */
        function parse($input, $contextUri = null, &$rootElementName = null);

        /**
         * Parses a document, throw an exception if it was a different
         * document than what you expected.
         */
        function expect($rootElementName, $input, $contextUri = null);

        /**
         * Generates an XML document
         */
        function write($rootElementName, $value, $contextUri = null);

        /**
         * Returns a fresh XML Reader
         */
        function getReader();

        /**
         * Returns a fresh XML writer
         */
        function getWriter();

        /**
         * Maps an XML element to a PHP class.
         */
        function mapValueObject($elementName, $className);

        /**
         * Turn a mapped PHP object into an XML document
        function writeValueObject($object, $contextUri = null);

    }

For more information about `$elementMap`, `parse()`, `expect()` and
`getReader()`, head to the [Reading XML][1] section.

For more information about `$namespaceMap`, `$classMap`, `write()` and
`getWriter()`, head to the [Writing XML][2] section.

For more information about `mapValueObject()` and `writeValueObject`,
head to the [Value Objects][3] section.

[1]: /xml/reading/
[2]: /xml/writing/
[3]: /xml/valueobjects/
