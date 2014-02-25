---
title: List of plugins
layout: default
use:
    - plugins 
---

<table>
    {% for plugin in data.plugins %}
    <tr>
        <td>{{ plugin.plugin_name }}</td>
        <td>{{ plugin.plugin_since }}</td>
    </tr>
    {% endfor %}
</table>
