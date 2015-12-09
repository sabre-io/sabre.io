---
product: xml 
layout: default
title: Clark-notation
---

sabre/xml heavily relies on clark-notation for xml elements. This means that in a lot
of places, you need to specify both the xml namespace and 'localname'.

A few examples:

    {http://www.w3.org/2005/Atom}entry
    {http://www.w3.org/1999/xhtml}h1
    {DAV:}multistatus

This basically means that these element names are composed of:

    {uri}localname

sabre/xml makes sure this gets transformed into:

    <localname xmlns="uri" />

The reason for this is that we don't want people to rely on prefixes such as the 'atom'
keyword in the following sample:

    <atom:entry xmlns:atom="http://www.w3.org/2005/Atom" />

We noticed that a lot of people assume that the 'atom' part (in this example) is standard,
and then expect other people generating xml to use the same prefixes. This is incorrect,
because the prefix is only intended to make it easier for humans to read.

The real, canonical xml element name is composed out of the namespace uri and local name,
so we needed a format that combined both in one string.

Other people already used the so-called clark-notation, so we decided to do the same.

