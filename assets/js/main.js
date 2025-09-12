// Main entry (ESM): wires theme switcher, search, toc, and micro interactions

const prefersReduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// Theme switcher
(function initTheme() {
  const key = 'cyber-theme';
  const root = document.documentElement;
  const current = root.getAttribute('data-theme') || 'cyber-cyan';
  try {
    const saved = localStorage.getItem(key);
    root.setAttribute('data-theme', saved || current);
  } catch {}
  const group = document.querySelector('.theme-switcher');
  if (!group) return;
  const chips = group.querySelectorAll('.chip');
  function setTheme(t) {
    root.setAttribute('data-theme', t);
    try { localStorage.setItem(key, t); } catch {}
    chips.forEach(c => c.setAttribute('aria-pressed', c.dataset.theme === t ? 'true':'false'));
  }
  chips.forEach(chip => chip.addEventListener('click', () => setTheme(chip.dataset.theme)));
  const t = root.getAttribute('data-theme');
  chips.forEach(c => c.setAttribute('aria-pressed', c.dataset.theme === t ? 'true':'false'));
})();

// Lazy load components when needed
document.addEventListener('DOMContentLoaded', async () => {
  // Glitch title (hero)
  const glitchEl = document.querySelector('[data-component="glitch-title"]');
  if (glitchEl && !prefersReduced) {
    const { setupGlitchTitle } = await import('./components/glitch-title.js');
    setupGlitchTitle(glitchEl);
  }

  // Neon border for cards
  const neonTargets = document.querySelectorAll('[data-component="neon-border"]');
  if (neonTargets.length) {
    const { setupNeonBorder } = await import('./components/neon-border.js');
    neonTargets.forEach(setupNeonBorder);
  }

  // Parallax (optional)
  const parallaxTargets = document.querySelectorAll('[data-parallax]');
  if (parallaxTargets.length && !prefersReduced) {
    const { setupParallax } = await import('./components/scroll-parallax.js');
    parallaxTargets.forEach(el => setupParallax(el, { intensity: 0.1 }));
  }

  // TOC for posts
  const tocEl = document.querySelector('[data-component="toc"]');
  if (tocEl) {
    const { setupToc } = await import('./components/toc.js');
    setupToc(tocEl, document.querySelector('.post-content'));
  }

  // Search panel
  const searchLayer = document.querySelector('[data-component="search"]');
  if (searchLayer) {
    const { setupSearch } = await import('./components/search.js');
    setupSearch(searchLayer, { endpoint: '{{ site.search_index.path | default: "/search.json" }}' });
    document.querySelectorAll('[data-action="open-search"]').forEach(btn => btn.addEventListener('click', () => searchLayer.dispatchEvent(new CustomEvent('open'))));
  }

  // Copy buttons for code blocks
  document.querySelectorAll('pre > code').forEach(code => {
    const pre = code.closest('pre');
    const wrap = document.createElement('div');
    wrap.className = 'code-block';
    pre.parentNode.insertBefore(wrap, pre);
    wrap.appendChild(pre);
    const btn = document.createElement('button');
    btn.className = 'copy-btn';
    btn.type = 'button';
    btn.textContent = '复制';
    btn.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(code.textContent || ''); btn.textContent = '已复制'; setTimeout(() => btn.textContent = '复制', 1500); } catch {}
    });
    wrap.appendChild(btn);
  });
});

