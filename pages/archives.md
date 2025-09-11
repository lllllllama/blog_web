---
layout: page
title: 归档
permalink: /pages/archives/
---

<h2>按年份归档</h2>

{% assign posts_by_year = site.posts | group_by_exp: 'p', 'p.date | date: "%Y"' %}
{% for year in posts_by_year %}
  <h3>{{ year.name }}</h3>
  <ul class="archive-list">
  {% for post in year.items %}
    <li>
      <span class="date">{{ post.date | date: "%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      {% if post.tags %}<span class="tags">{% for t in post.tags %}<em>#{{ t }}</em> {% endfor %}</span>{% endif %}
    </li>
  {% endfor %}
  </ul>
{% endfor %}

