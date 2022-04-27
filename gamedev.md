---
layout: base
title: GameDev
---
<div id="main">
    {% assign category = page.title | downcase %}
    <h1>Desarrollo Juegos</h1>
    <h3>Todas las entradas de consejos, tutos y proyectos que llevo en marcha</h3>
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