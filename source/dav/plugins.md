---
layout: default
use:
    - plugins 
---

List of plugins
===============

<table>
    {% for plugin in data.plugins %}
    <tr>
        <td>{{ plugin.plugin_name }}</td>
        <td>{{ plugin.plugin_since }}</td>
    </tr>
    {% endfor %}
</table>
