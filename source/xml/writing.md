---
title: Writing XML
product: xml
layout: default
---

sabre/xml has a writer class called `Sabre\Xml\Writer`. This class extends
PHP's built-in [`XMLWriter`][1] class, so its entire API also works here.

The writer has several additions to the standard API that make it more easy
to use.

You can easily instantiate and start using the Writer like this:

    $writer = new Sabre\Xml\Writer();
    $writer->openMemory();
    $writer->setIndent(true);
    $writer->startDocument();
    $writer->write('...');
    echo $writer->outputMemory();

Those functions follow the PHP API exactly, but it's a lot of typing.
sabre/xml provides a `Service` class that eases this a bit. This is the
same example using the `Service`:

    $service = new Sabre\Xml\Service();
    echo $service->write('...');

So while you can use either API, all the following examples use the
`Service` class.


The `write` method
------------------

The `write` method allows you to quickly write complex XML structures.

We're explaining this method by example.

    $service = new Sabre\Xml\Service();
    $service->namespaceMap = [
        'http://example.org/' => 'e',
    ];

    echo $service->write('{http://example.org/}root', 'hello');

This results in the following xml:

    <?xml version="1.0">
    <e:root>hello</e:root>

Instead of `hello`, we could also have written this:

    $service->write('{http://example.org/}root', [
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

    $service->write('{http://example.org/}root',[
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

    $service->write('{http://www.w3.org/1999/xhtml}p',
        [
            'name' => '{http://www.w3.org/1999/xhtml}a',
            'attributes' => [
                'href' => 'http://sabre.io/',
            ],
            'value' => 'Sabre website',
        ]
    ]);

This could output:

    <p>
        <a href="http://sabre.io/">Sabre website</a>
    </p>

You can even mix these syntaxes:

    $ns = '{http://www.w3.org/2005/Atom}';
    $service->namespaceMap['http://www.w3.org/2005/Atom'] = '';

    $service->write($ns . 'feed', [
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

        function xmlSerialize(Sabre\Xml\Writer $writer) {
            $ns = '{http://www.w3.org/2005/Atom}';

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

    $service->write([
    	'{http://www.w3.org/2005/Atom}entry' => $entry,
    ]);

Output:

    <entry xmlns="http://www.w3.org/2005/Atom">
      <title>Atom-Powered Robots Run Amok</title>
      <link href="http://example.org/2003/12/13/atom03"/>
      <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
      <updated>2003-12-13T18:30:02Z</updated>
      <summary>Some text.</summary>
    </entry>

One thing to note from the last example, is that the `AtomEntry` class does
not actually encode it's own 'parent element'. Element classes _should never_
encode their own element, only the element's value.

This allows serializers to be re-used for different element names, but this
starts to make even more sense when you re-use the exact same classes for
serialization and deserialization. Deserialization is covered on the
[reading XML][4] page in the documentation.


Separating serializers from objects
-----------------------------------

In the last example, the `AtomEntry` class had to get a `xmlSerialize` method
in order to be able to serialize itself. There's cases where that's not
desirable. The last example could be rewritten to use the `$classMap` to avoid
having to use the `XmlSerializable` interface.

The `$classMap` is a simple array that allows a user to specify a callback that
is responsible for serializing specific PHP classes.

Here's another version of the last example that takes advantage of this:

    class AtomEntry {

        public $title;
        public $link;
        public $id;
        public $updated;
        public $summary;

    }

    // Registering a custom serializer:
    $service->classMap['AtomEntry'] = function(Sabre\Xml\Writer $writer, $entry) {

        $ns = '{http://www.w3.org/2005/Atom}';

        $writer->write([
            $ns . 'title' => $entry->title,
            [
               'name' => $ns . 'link',
               'attributes' => ['href' => $entry->link]
            ],
            $ns . 'updated' => $entry->updated,
            $ns . 'id' => 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a',
            $ns . 'summary' => 'Some text.'
        ]);

    };


Value objects
-------------

For very simple PHP classes and XML elements it might be possible to use the
"value object" system instead. Read more on the [Value Objects][5] page.


Things the `write()` function can write
---------------------------------------

This is the full list of things that the `write()` function understands and
can turn into an xml document:

1. A `string`, which gets turned into a XML text.
2. An `integer` or `float`, which also gets turned into XML text.
3. `null`, which causes the writer to write nothing at all.
4. An array with at least a `name` key, will cause the writer to write an
   an element with that `name`. If it also contains `attributes` it will write
   those as well, and if it also has a `value` key it will just throw whatever
   value it is back into the `write()` function.
5. An array with keys that are in [clark-notation][2]. It will write elements
   with that name and it supports any type of value again.
6. A PHP callback, in which case the writer will just call that callback with
   the `Sabre\Xml\Writer` class as an argument.
7. A PHP object, if it has a registered serializer in `classMap`.
8. A PHP object that implements the `XmlSerializable` interface, in which case
   it will call it's `xmlSerialize` function.

And for most of these, anywhere you can nest values, the writer will traverse
the tree and keep on writing!


[1]: http://php.net/manual/en/book.xmlwriter.php
[2]: /xml/clark-notation/
[3]: https://tools.ietf.org/html/rfc4287
[4]: /xml/reading/
[5]: /xml/valueobjects/
