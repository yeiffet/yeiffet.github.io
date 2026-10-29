---
layout: base
title: Tags
permalink: /tags/
---
<div id="main">
    <h1>Tags</h1>
    <h3>Todas las entradas agrupadas por tag</h3>
    <br>

    {% assign tags = site.tags | sort %}
    {% for tag in tags %}
    <section id="{{ tag[0] | slugify }}">
      <h2>{{ tag[0] }}</h2>
      <ul class="posts">
        {% for post in tag[1] %}
            <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
        {% endfor %}
      </ul>
    </section>
    {% endfor %}
</div>
