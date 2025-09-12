---
layout: page
title: 标签
permalink: /pages/tags/
---

<div class="tags-page">
  <p>共 {{ site.tags | size }} 个标签。</p>
  {% assign tags = site.tags | sort %}
  <ul class="tag-list">
  {% for tag in tags %}
    <li id="{{ tag[0] }}"><h3>#{{ tag[0] }} <small>({{ tag[1].size }})</small></h3>
      <ul>
      {% for post in tag[1] %}
        <li>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          <span class="date">{{ post.date | date: "%Y-%m-%d" }}</span>
        </li>
      {% endfor %}
      </ul>
    </li>
  {% endfor %}
  </ul>
</div>

