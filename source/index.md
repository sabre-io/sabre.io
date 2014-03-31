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
sabre/dav is the leading open source WebDAV, CardDAV and CalDAV server.
</p>

</section>
<div class="download">
    <a href="{{ site.url }}/dav/install">
        <i class="fa fa-download"></i>
        <h1>Download</h1>
    </a>
    <small>
        <a href="{{ site.url }}/dav/gettingstarted">Or learn more here..</a>
    </small>
</div>

<section class="news-box">
    <h1>News</h1>
    {% for post in page.pagination.items %}
        <article>
            <h1><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h1>
            {{ post.blocks.content|raw }}
            <p><a href="{{ post.url }}">comment</a></p>
        </article>
        <hr />
    {% endfor %}
</section>

<section class="features-box">
    <h1>Features</h1>
    <ul>
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

<section class="enterprise-box">
    <h1>Enterprise support</h1>
    <h2>sabre/dav is developed by <a href="https://fruux.com/">fruux</a>.</h2>
    <p>
    We provide:
    </p>
    <ul>
        <li>Enterprise support.</li>
        <li>Customization.</li>
        <li>Integrating into your existing infrastructure.</lI>
        <li>Both on-premise and SaaS deployments.</li>
    </ul>
    <p><a href="/contact">Contact us</a> to discuss your requirements.</p>
</section>

<section class="project-box">

<h1>The full sabre.io project lineup</h1>

<dl>
    <dt><a href="/dav">sabre/dav</a></dt>
    <dd>The leading open-source WebDAV, CalDAV and CardDAV server.</dd>
</dl>
<dl>
    <dt><a href="/http">sabre/http</a></dt>
    <dd>An OOP abstraction layer for the PHP server api.</dd>
</dl>
<dl>
    <dt><a href="/vobject">sabre/vobject</a></dt>
    <dd>A library for parsing and manipulating vCard, iCalendar, jCard and jCal.</dd>
</dl>
<dl>
    <dt><a href="/event">sabre/event</a></dt>
    <dd>Utilities for lightweight event-based programming in PHP.</dd>
</dl>

</section>
