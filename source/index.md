---
layout: home
sidebar: none
generator: pagination
pagination:
    max_per_page: 5
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
            <a href="{{ site.url }}/dav"><small>Or learn more...</small></a>
        </div>
        <ul class="list-features">
            <li><i class="fa fa-fw fa-rocket"></i><a href="{{ site.url }}/dav/scalability">Scalable</a> design.</li>
            <li><i class="fa fa-fw fa-share-alt"></i>Extensive <a href="{{ site.url }}/dav/caldav-sharing">sharing</a> and <a href="{{ site.url }}/dav/caldav-proxy">delegation</a> features.</li>
            <li><i class="fa fa-fw fa-clock-o"></i>Powerful <a href="{{ site.url }}/dav/scheduling">scheduling and free/busy</a> capabilities.</li>
            <li><i class="fa fa-fw fa-lock"></i>Flexible <a href="{{ site.url }}/dav/acl">ACL</a> and <a href="{{ site.url }}/dav/authentication">authentication</a> system.</li>
            <li><i class="fa fa-fw fa-coffee"></i>Supported on <a href="{{ site.url }}/dav/clients">all major platforms</a>.</li>
        </ul>
    </div>
</section>
<section class="box box--trusted">
    <div class="box-wrapper">
        <h1 class="box-headline">Trusted by</h1>
        <a href="https://www.atmail.com" title="sabre/dav is trusted by atmail.">
            <img src="{{ site.url }}/img/trusted/atmail.png" alt="atmail works with sabre/dav">
        </a><a href="http://tech.blog.box.com/2014/10/in-search-of-an-open-source-webdav-solution/" title="sabre/dav is trusted by Box.">
            <img src="{{ site.url }}/img/trusted/box.png" alt="Box works with sabre/dav">
        </a><a href="https://fruux.com" title="sabre/dav is developed by fruux.">
            <img src="{{ site.url }}/img/trusted/fruux.png" alt="Our consumer product fruux is powered by sabre/dav">
        </a><a href="http://owncloud.org" title="sabre/dav is trusted by ownCloud.">
            <img src="{{ site.url }}/img/trusted/owncloud.png" alt="Owncloud works with sabre/dav">
        </a>
    </div>
</section>
<section class="box box--lineup">
    <div class="box-wrapper">
        <h1 class="box-headline">The full sabre.io lineup</h1>
        <a href="{{ site.url }}/dav">
            <h3>sabre/dav</h3>
            The leading open-source CalDAV, CardDAV and WebDAV server
        </a>
        <a href="{{ site.url }}/http">
            <h3>sabre/http</h3>
            An OOP abstraction layer for the PHP server api.
        </a>
        <a href="{{ site.url }}/vobject">
            <h3>sabre/vobject</h3>
            A library for parsing and manipulating vCard, iCalendar, jCard and jCal.
        </a>
        <a href="{{ site.url }}/event">
            <h3>sabre/event</h3>
            Utilities for lightweight event-based programming in PHP.
        </a>
        <a href="{{ site.url }}/xml">
            <h3>sabre/xml</h3>
            The only XML library that you may not hate.
        </a>
    </div>
</section>
<div class="box box--turquoise">
    <div class="box-wrapper">
        <section class="box box--enterprise">
            <a href="https://fruux.com"><img src="{{ site.url }}/img/fruux_logo.png"></a>
            <h1>Enterprise support</h1>
            <h2>sabre/dav and the other sabre.io projects are developed by <a href="https://fruux.com/">fruux</a>.</h2>
            <div class="promo">
                <h3>We provide:</h3>
                <ul>
                    <li>Enterprise support.</li>
                    <li>Customization.</li>
                    <li>Integrating into your existing infrastructure.</lI>
                    <li>Both on-premise and SaaS deployments.</li>
                </ul>
            </div>
            <a href="mailto:sales@fruux.com" class="bubble">
                <i class="fa fa-2x fa-envelope-o"></i>
                <strong>Contact us</strong> <br>
                to discuss your requirements.
            </a>
        </section>
        <section class="box box--news">
            <h1>News</h1>
            {% for post in page.pagination.items %}
                <article class="blog-entry">
                    <time>{{ post.date|date("M. jS, Y") }}</time>
                    <h1><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h1>
                    {{ post.blocks.content|split('</p>')|first|raw -}}
                </article>
                {% if not loop.last %}<hr />{% endif %}
            {% endfor %}
        </section>
    </div>
</div>
<figure class="bg--cloudy">
    <img src="{{ site.url }}/img/home_background.jpg">
</figure>