---
layout: page
title: 域名与部署状态
permalink: /pages/status/
---

下面的检测运行在浏览器端，仅用于快速自查你的自定义域是否正确生效。

<div id="status" class="card" style="padding:16px">
  <p><strong>当前访问域名</strong>：<code id="host">—</code></p>
  <p><strong>是否匹配期望域名</strong>（<code>lllllllama.me</code>）：<span id="host-ok">—</span></p>
  <p><strong>访问协议</strong>：<code id="proto">—</code>，HTTPS 强制：<span id="https-ok">—</span></p>
  <p><strong>页面路径</strong>：<code id="path">—</code></p>
  <hr/>
  <p><strong>应配置的 DNS（Namecheap → Advanced DNS）</strong></p>
  <ul>
    <li>A 记录：Host <code>@</code> 指向 <code>185.199.108.153</code>、<code>185.199.109.153</code>、<code>185.199.110.153</code>、<code>185.199.111.153</code></li>
    <li>可选 AAAA（IPv6）：<code>2606:50c0:8000::153</code>、<code>2606:50c0:8001::153</code>、<code>2606:50c0:8002::153</code>、<code>2606:50c0:8003::153</code></li>
    <li>CNAME：Host <code>www</code> → <code>lllllllama.github.io</code></li>
  </ul>
  <p>GitHub 仓库 Settings → Pages → Custom domain 填 <code>lllllllama.me</code>，并启用 Enforce HTTPS。</p>
  <p>外部检测工具（任选其一）：
    <br/><a href="https://dnschecker.org/#A/lllllllama.me" target="_blank" rel="noopener">dnschecker A</a> ·
    <a href="https://dnschecker.org/#CNAME/www.lllllllama.me" target="_blank" rel="noopener">dnschecker CNAME</a>
  </p>
</div>

<script>
  (function () {
    var expected = 'lllllllama.me';
    var host = location.hostname;
    var proto = location.protocol;
    var path = location.pathname;
    var hostOk = host === expected || host === ('www.' + expected);
    var httpsOk = proto === 'https:';
    function $(id){ return document.getElementById(id); }
    $('host').textContent = host || '（空）';
    $('proto').textContent = proto || '（空）';
    $('path').textContent = path || '（空）';
    $('host-ok').textContent = hostOk ? '是 ✅' : '否 ❌';
    $('https-ok').textContent = httpsOk ? '是 ✅' : '否 ❌';
  })();
  </script>

提示：DNS 修改后通常 5–30 分钟内生效，最久可达 24 小时。证书签发完成后再启用或自动启用 HTTPS 强制。

