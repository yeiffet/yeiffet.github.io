---
layout: base
title: Cacharreo
---
<div id="main">
    {% assign category = page.title|downcase %}
    <h1>Cacharreo</h1>
    <h3>También me gusta la electrónica, lo retro y modificaciones. Además de algunos que otros gadgets. Todo eso estará en esta sección</h3>
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