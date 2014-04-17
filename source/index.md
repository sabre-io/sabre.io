---
layout: home
sidebar: none
generator: pagination
pagination:
    max_per_page: 3
use:
    - posts
---
<section class="hero">
<h1>sabre/dav</h1>

<p>
An open source CardDAV, CalDAV and WebDAV server.
</p>

</section>
<div class="download">
    <a href="{{ site.url }}/dav/install">
        <i class="fa fa-download"></i>
        <h1>Install</h1>
    </a>
    <small>
        <a href="{{ site.url }}/dav/gettingstarted">Or learn more here..</a>
    </small>
</div>

<section class="box box-news">
    <h1>News</h1>
    {% for post in page.pagination.items %}
        <article>
            <h1><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h1>
            <time>{{ post.date|date("F jS, Y") }}</time>
            {{ post.blocks.content|raw }}
        </article>
        {% if not loop.last %}<hr />{% endif %}
    {% endfor %}
</section>

<section class="box box-features">
    <h1>Features</h1>
    <ul class="list list-features">
        <li>
            <i class="fa fa-rocket"></i>
            Fully WebDAV compliant
        </li>
        <li>
            <i class="fa fa-coffee"></i>
            Supported on all major platforms.
        </li>
        <li class="hr"></li>
        <li>
            <i class="fa fa-lock"></i>
            Locking support.
        </li>
        <li>
            <i class="fa fa-home"></i>
            Custom property support.
        </li>
        <li class="hr"></li>
        <li>
            <i class="fa fa-calendar"></i>
            CalDAV support.
        </li>
        <li>
            <i class="fa fa-book"></i>
            CardDAV support.
        </li>
        <li class="hr"></li>
        <li>
            <i class="fa fa-share"></i>
            Supports calendar sharing and delegating.
        </li>
        <li>
            <i class="fa fa-check"></i>
            &gt;95% unittest coverage.
        </li>
    </ul>
</section>

<section class="box box-enterprise">
    <h1>Enterprise support</h1>
    <h2>sabre/dav and the other sabre.io projects are developed by <a href="https://fruux.com/">fruux</a>.</h2>
    <div>
        <a href="https://fruux.com"><img src="{{site.url}}/img/fruux_logo.png"></a>
        <h3>We provide:</h3>
        <ul class="list list-checks">
            <li>Enterprise support.</li>
            <li>Customization.</li>
            <li>Integrating into your existing infrastructure.</lI>
            <li>Both on-premise and SaaS deployments.</li>
        </ul>
    </div>
    <p class="bubble">
        <i class="fa fa-2x fa-envelope-o"></i>
        <a href="/support">Contact us</a> <br>to discuss your requirements.
    </p>
</section>

<section class="project-box">

<h1>The full sabre.io project lineup</h1>

<dl>
    <dt><a href="{{site.url}}/dav">sabre/dav</a></dt>
    <dd>The leading open-source CalDAV, CardDAV and WebDAV server.</dd>
</dl>
<dl>
    <dt><a href="{{site.url}}/http">sabre/http</a></dt>
    <dd>An OOP abstraction layer for the PHP server api.</dd>
</dl>
<dl>
    <dt><a href="{{site.url}}/vobject">sabre/vobject</a></dt>
    <dd>A library for parsing and manipulating vCard, iCalendar, jCard and jCal.</dd>
</dl>
<dl>
    <dt><a href="{{site.url}}/event">sabre/event</a></dt>
    <dd>Utilities for lightweight event-based programming in PHP.</dd>
</dl>

</section>
