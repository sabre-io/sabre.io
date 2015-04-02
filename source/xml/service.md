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

The service class
-----------------

This is the service class in birds eye view:


    namespace Sabre\Xml;

    class Service {

        /**
         * This is the element map. It contains a list of XML elements (in clark
         * notation) as keys and PHP class names as values.
         *
         * The PHP class names must implement Sabre\Xml\Element.
         *
         * Values may also be a callable. In that case the function will be called
         * directly.
         *
         * @var array
         */
        public $elementMap = [];

        /**
         * This is a list of namespaces that you want to give default prefixes.
         *
         * You must make sure you create this entire list before starting to write.
         * They should be registered on the root element.
         *
         * @var array
         */
        public $namespaceMap = [];

        /**
         * Returns a fresh XML Reader
         *
         * @return Reader
         */
        function getReader();

        /**
         * Returns a fresh xml writer
         *
         * @return Writer
         */
        function getWriter();

        /**
         * Parses a document in full.
         *
         * Input may be specified as a string or readable stream resource.
         * The returned value is the value of the root document.
         *
         * Specifying the $contextUri allows the parser to figure out what the URI
         * of the document was. This allows relative URIs within the document to be
         * expanded easily.
         *
         * The $rootElementName is specified by reference and will be populated
         * with the root element name of the document.
         *
         * @param string|resource $input
         * @param string|null $contextUri
         * @param string|null $rootElementName
         * @throws ParseException
         * @return array|object|string
         */
        function parse($input, $contextUri = null, &$rootElementName = null);

        /**
         * Parses a document in full, and specify what the expected root element
         * name is.
         *
         * This function works similar to parse, but the difference is that the
         * user can specify what the expected name of the root element should be,
         * in clark notation.
         *
         * This is useful in cases where you expected a specific document to be
         * passed, and reduces the amount of if statements.
         *
         * @param string $rootElementName
         * @param string|resource $input
         * @param string|null $contextUri
         * @return void
         */
        function expect($rootElementName, $input, $contextUri = null);

        /**
         * Generates an XML document in one go.
         *
         * The $rootElement must be specified in clark notation.
         * The value must be a string, an array or an object implementing
         * XmlSerializable. Basically, anything that's supported by the Writer
         * object.
         *
         * $contextUri can be used to specify a sort of 'root' of the PHP application,
         * in case the xml document is used as a http response.
         *
         * This allows an implementor to easily create URI's relative to the root
         * of the domain.
         *
         * @param string $rootElementName
         * @param string|array|XmlSerializable $value
         * @param string|null $contextUri
         */
        function write($rootElementName, $value, $contextUri = null);

    }
