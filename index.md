---
layout: base
title: Desarrollo web
---
<div id="main">
    <h1>Bienvenidos a mi blog</h1>
    <h3>Aquí encontraras curiosidades y DevLogs de mis proyectos</h3>
    <br>
    <br>
    <h2>Últimos Posts</h2>
    <section id="four">
        {% for post in site.posts %}
        <section>
            <header>
                <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
                <h4>{{post.categories | capitalize}}</h4>
                <p>{{ post.date | date: "%-d %B %Y %X"}}</p>
            </header>
            <p>{{ post.excerpt }}</p>
        </section>
        {% endfor %}
    </section>
</div>