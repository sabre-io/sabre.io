---
layout: home
sidebar: none
generator: pagination
pagination:
    max_per_page: 3
use:
    - posts
---
<section class="box box--hero">
    <div class="box-wrapper">
        <h1>sabre/dav</h1>
        <div class="box-text">
            <p>
                An open source CardDAV, CalDAV and WebDAV server.
            </p>
            <a class="install" href="{{ site.url }}/dav/install">
                <i class="fa fa-download"></i>
                Install
            </a>
            <br>
            <a href="{{ site.url }}/dav/gettingstarted"><small>Or learn more here..</small></a>
        </div>
        <ul class="list-features">
            <li><i class="fa fa-fw fa-rocket"></i>Fully WebDAV compliant</li>
            <li><i class="fa fa-fw fa-coffee"></i>Supported on all major platforms.</li>
            <li><i class="fa fa-fw fa-lock"></i>Locking support.</li>
        </ul>
    </div>
</section>

<section class="box box--trusted">
    <div class="box-wrapper">
        <h1 class="box-headline">Trusted by</h1>
        <a href="#" title="Box trusts in sabredav.">
            <img src="{{site.url}}/img/trusted/box.png" alt="Box works with sabredav">
        </a><a href="#" title="Owncloud trusts in sabredav.">
            <img src="{{site.url}}/img/trusted/owncloud.png" alt="Owncloud works with sabredav">
        </a><a href="#" title="atmail trusts in sabredav.">
            <img src="{{site.url}}/img/trusted/atmail.png" alt="atmail works with sabredav">
        </a><a href="#" title="fruux trusts in sabredav.">
            <img src="{{site.url}}/img/trusted/fruux.png" alt="fruux works with sabredav">
        </a>
    </div>
</section>

<section class="box box--lineup">
    <div class="box-wrapper">
        <h1 class="box-headline">The full sabre.io project lineup</h1>
        <a href="{{site.url}}/dav">
            <h3>sabre/dav</h3>
            The leading open-source CalDAV, CardDAV and WebDAV server
        </a>
        <a href="{{site.url}}/http">
            <h3>sabre/http</h3>
            An OOP abstraction layer for the PHP server api.
        </a>
        <a href="{{site.url}}/vobject">
            <h3>sabre/vobject</h3>
            A library for parsing and manipulating vCard, iCalendar, jCard and jCal.
        </a>
        <a href="{{site.url}}/event">
            <h3>sabre/event</h3>
            Utilities for lightweight event-based programming in PHP.
        </a>
        <a href="{{site.url}}/event">
            <h3>sabre/xml</h3>
            Cookies and lollies for sugarbased development.
        </a>
    </div>
</section>

<section class="box box--enterprise">
    <div class="box-wrapper">
        <h1>Enterprise support</h1>
        <h2>sabre/dav and the other sabre.io projects are developed by <a href="https://fruux.com/">fruux</a>.</h2>
        <div class="promo">
            <a href="https://fruux.com"><img src="{{site.url}}/img/fruux_logo.png"></a>
            <h3>We provide:</h3>
            <ul>
                <li>Enterprise support.</li>
                <li>Customization.</li>
                <li>Integrating into your existing infrastructure.</lI>
                <li>Both on-premise and SaaS deployments.</li>
            </ul>
        </div>
        <a href="/support" class="bubble">
            <i class="fa fa-2x fa-envelope-o"></i>
            <strong>Contact us</strong> <br>
            to discuss your requirements.
        </a>
    </div>
</section>

<section class="box">
    <h1>News</h1>
    {% for post in page.pagination.items %}
        <article class="blog-entry">
            <time>{{ post.date|date("F jS, Y") }}</time>
            <h1><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h1>
            {{ post.blocks.content|raw }}
        </article>
        {% if not loop.last %}<hr />{% endif %}
    {% endfor %}
</section>

<figure class="bg--cloudy">
    <img src="{{site.url}}/img/home_background.jpg" alt="Colored clouds with a juicy flavor.">
</figure>