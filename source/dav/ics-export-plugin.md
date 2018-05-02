---
title: iCalendar Export Plugin
type: plugin
plugin_name: icsexportplugin
plugin_since: 1.4.0
---

There are some Calendaring tools that don't yet support CalDAV, but they do
have support for the 'Subscribe to' feature.

Starting with SabreDAV 1.4, there is now a plugin that grabs an existing
calendar, and exports it as a file that's compatible with these applications.

Setup
-----

To use this plugin, simply add it to your server:

    $icsPlugin = new \Sabre\CalDAV\ICSExportPlugin();
    $server->addPlugin($icsPlugin);

After this is added, you can generate these exports by finding a url to your
calendar, and adding ?export at the end of the url. This will automatically
trigger a download.

Sample url

    http://dav.example.org/calendars/user1/mycalendar?export


Options
-------

The ICSExport plugin supports several options since version 2.0.

| option        | description                                         | example               |
| ------------- | --------------------------------------------------- | --------------------- |
| start         | Only show events from _after_ this unix timestampo  | `start=1391707119`    |
| end           | Only show events from _before_ this unix timestamp  | `end=1391707215`      |
| expand        | Automatically expand recurring events               | `expand=1`            |
| accept        | Convert the iCalendar data to [jCal][1]             | `accept=jcal`         |
| componentType | Filter by componentType, such as only `VTODO`.      | `componentType=VTODO` |


* If you want to use `expand`, you _must_ specify `start` and `end`.
* Using `start`, `end` or `expand` automatically filters out `VTODO` and
  `VJOURNAL`, because only `VEVENT` is currently supported. If you need support
  for `VJOURNAL` and `VTODO`, open a [feature request][2].
* `componentType` was added in sabre/dav 3.0.

Sample url:

    http://dav.example.org/calendars/user1/mycalendar?export&start=1391707119&end=1391707215&expand=1&accept=jcal


[1]: /vobject/json
[2]: https://github.com/sabre-io/dav/issues/new

