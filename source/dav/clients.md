---
title: Clients
layout: default
use:
    - clients
---

While testing SabreDAV against various clients, we attempted to write down
known bugs and common pitfalls we've encountered.

Below is a list of all clients we have data on. If you have something to add,
your information is greatly welcomed.

<ul>
{% for client in data.clients %}
    <li><a href="{{ client.url }}">{{ client.title }}</a></li>
{% endfor %}
</ul>
