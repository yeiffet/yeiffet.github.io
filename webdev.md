---
layout: base
title: WebDev
---
<div id="main">
    {% assign category = page.title | downcase %}
    <h1>Desarrollo web</h1>
    <h2>Aquí encontraras posts de desarrollo web y paradigmas</h2>
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