---
title: vCard export plugin
type: plugin
plugin_name: vcfexportplugin
plugin_since: 1.7.0
---

The vCard export plugin allows you to export an entire addressbook, to a
single .vcf file.

This plugin was added in SabreDAV 1.7.

Setup
-----

To use this plugin, simply add it to your server:

    $vcfPlugin = new \Sabre\CardDAV\VCFExportPlugin();
    $server->addPlugin($vcfPlugin);

After this is added, you can generate these exports by finding a url to your
addressbook, and adding ?export at the end of the url. This will automatically
trigger a download.

Sample url

    http://dav.example.org/addressbooks/user1/mycontacts?export
