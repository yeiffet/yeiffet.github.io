---
layout: base
title: WebDev
---
<div id="main">
    {% assign category = page.title | downcase %}
    <h1>Desarrollo Web</h1>
    <h3>Aquí encontraras posts de desarrollo web y todo lo relacionado con ello</h3>
    <br>

    <section>
      <ul class="posts">
        {% for post in site.posts %}
            {% if post.categories contains {{category}}  %}
                <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
            {% endif %}
        {% endfor %}
      </ul>
    </section>
</div>