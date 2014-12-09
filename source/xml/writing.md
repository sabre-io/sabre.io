---
title: Writing XML
product: xml
layout: default
---

sabre/xml has a writer class called `Sabre\Xml\Writer`. This class extends
PHP's built-in [`XMLWriter`][1] class, so its entire API also works here.

The writer has several additions to the standard API that make it more easy
to use.


Automatically apply namespaces
------------------------------

The `startElement`, `writeElement` and `writeAttribute` methods have been
changed a bit, so they can accept [clark notation][2] for their node names.

What this means, is that you can call

    $writer->namespaceMap = [
        '{http://example.org/}foo' => 'foo',
    ];
    $writer->writeElement('{http://example.org/}foo','bar');

This would result in the following xml:

    <?xml version="1.0"?>
    <foo:bar xmlns:foo="http://example.org/">bar</foo:bar>

This means you can fully ignore `startElementNS`, `writeElementNS` and
`writeAttributeNS`, which all often behave in unexpected ways and have
been broken in several PHP versions.

By always specifying the fully qualified namespace and element name, you
disconnect the 'real xml element name' with the 'human readable prefix'.

Your code should ideally never be aware of the prefix. It's strictly for
beautifaction of xml.


The `write` method
------------------

The `write` method allows you to quickly write complex xml structures.

We're explaining this method by example.

    $writer = new Sabre\Xml\Writer();
    $writer->openMemory();
    $writer->namespaceMap = [
        'http://example.org/' => 'e',
    ];

    $writer->startElement('{http://example.org/}root');

    $writer->write('hello');

    $writer->endElement();
    echo $writer->outputMemory();

This results in the following xml:

    <?xml version="1.0">
    <e:root>hello</e:root>

If instead of the string `hello`, we wrote this:

    $writer->write([
        '{http://example.org/ns}title' => 'Foundation',
        '{http://example.org/ns}author' => 'Isaac Asimov',
    ]);

The output becomes:

    <?xml version="1.0">
    <e:root>
        <e:title>Foundation</e:title>
        <e:author>Isaac Asimov</e:author>
    </e:root>

This array can be nested:

    $ns = '{http://example.org/}';

    $writer->write([
        $ns . 'title' => 'Foundation',
        $ns . 'author' => [
            $ns . 'firstname' => 'Isaac',
            $ns . 'lastname'  => 'Asimov',
        ]
    ]);

Output:

    <?xml version="1.0">
    <e:root>
        <e:title>Foundation</e:title>
        <e:author>
            <e:firstname>Isaac</e:firstname>
            <e:lastname>Asimov</e:lastname>
        </e:author>
    </e:root>

Need attributes? Use the extended syntax:

    $writer->write([
        [
            'name' => '{http://www.w3.org/1999/xhtml}a',
            'attributes' => [
                'href' => 'http://sabre.io/',
            ],
            'value' => 'Sabre website',
        ]
    ]);

This could output:

    <a href="http://sabre.io/">Sabre website</a>

You can even mix these syntaxes:

    $ns = '{http://www.w3.org/2005/Atom}';
    $writer->namespaceMap['http://www.w3.org/2005/Atom'] = '';

    $writer->write([
        $ns . 'feed' => [
            $ns . 'title' => 'Example Feed',
            [
                'name' => $ns . 'link',
                'attributes' => ['href' => 'http://example.org/']
            ],
            $ns . 'updated' => '2003-12-13T18:30:02Z',
            $ns . 'author' => [
                $ns . 'name' => 'John Doe',
            ],
            $ns . 'id' => 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6',

        ]
    ]);

Output:

    <?xml version="1.0"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title>Example Feed</title>
      <link href="http://example.org/"/>
      <updated>2003-12-13T18:30:02Z</updated>
      <author>
        <name>John Doe</name>
      </author>
      <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
    </feed>


Serializing objects
-------------------

All of this becomes more useful when you start mapping objects to XML elements. As an example, we'll create a simple object that represents an Atom Entry (a.k.a. a blogpost).

    class AtomEntry implements Sabre\Xml\XmlSerializable {

        public $title;
        public $link;
        public $id;
        public $updated;
        public $summary;

        $ns = '{http://www.w3.org/2005/Atom}';

        function xmlSerialize(Sabre\Xml\Writer $writer) {

            $writer->write([
                $ns . 'title' => $this->title,
                [
                   'name' => $ns . 'link',
                   'attributes' => ['href' => $this->link]
                ],
                $ns . 'updated' => $this->updated,
                $ns . 'id' => 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a',
                $ns . 'summary' => 'Some text.'
            ]);

        }

    }

To use this new class:

    $entry = new AtomEntry();
    $entry->title = 'Atom-Powered Robots Run Amok';
    $entry->link = 'http://example.org/2003/12/13/atom03';
    $entry->id = 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a';
    $entry->updated = '2003-12-13T18:30:02Z';
    $entry->summary = 'Some text.';

Now to serialize it:

    $writer->write(
    	'{http://www.w3.org/2005/Atom}entry' => $entry,
    );

Output:

    <entry xmlns="http://www.w3.org/2005/Atom">
      <title>Atom-Powered Robots Run Amok</title>
      <link href="http://example.org/2003/12/13/atom03"/>
      <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
      <updated>2003-12-13T18:30:02Z</updated>
      <summary>Some text.</summary>
    </entry>

One thing to note from the last example, is that the `AtomEntry` class does not actually encode it's own 'parent element'. This is a design choice. We feel that it's a best practice for every serializable object to only ever represent a _value_ but not its _identity_.


This allows serializers to be re-used for different element names, but this starts to make even more sense when you re-use the exact same classes for serialization and deserialization. Deserialization is covered on the [reading xml][4] page in the documentation.


[1]: http://php.net/manual/en/book.xmlwriter.php
[2]: /xml/clark-notation/
[3]: https://tools.ietf.org/html/rfc4287
[4]: /xml/reading/
