---
layout: default
sidebar: none
title: Blog
use:
    - posts
nocomments: true
---

{% for post in data.posts %}
<article class="blog-entry">
    <time>{{ post.date|date("F jS, Y") }}</time>
    <h1><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h1>
    {{ post.blocks.content|raw }}
</article>
{% if not loop.last %}<hr />{% endif %}
{% endfor %}
