// Main entry (ESM): wires theme switcher, search, toc, and micro interactions

const prefersReduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// Theme switcher
(function initTheme() {
  const key = "cyber-theme";
  const root = document.documentElement;
  const current = root.getAttribute("data-theme") || "cyber-cyan";
  try {
    const saved = localStorage.getItem(key);
    root.setAttribute("data-theme", saved || current);
  } catch {}
  const group = document.querySelector(".theme-switcher");
  if (!group) return;
  const chips = group.querySelectorAll(".chip");
  function setTheme(t) {
    root.setAttribute("data-theme", t);
    try { localStorage.setItem(key, t); } catch {}
    chips.forEach(c => c.setAttribute("aria-pressed", c.dataset.theme === t ? "true" : "false"));
  }
  chips.forEach(chip => chip.addEventListener("click", () => setTheme(chip.dataset.theme)));
  const t = root.getAttribute("data-theme");
  chips.forEach(c => c.setAttribute("aria-pressed", c.dataset.theme === t ? "true" : "false"));
})();

document.addEventListener("DOMContentLoaded", async () => {
  const header = document.querySelector(".site-header");
  const navToggle = document.querySelector('[data-action="toggle-nav"]');
  const primaryNav = document.querySelector('.site-nav');
  const navLinks = document.querySelectorAll(".site-nav a");

  let neonModule;
  const normalizePath = (href) => {
    try {
      const url = new URL(href, window.location.origin);
      let pathName = url.pathname.replace(/index\.html$/i, "");
      if (pathName.length > 1 && pathName.endsWith("/")) {
        pathName = pathName.slice(0, -1);
      }
      return pathName || "/";
    } catch {
      return href;
    }
  };

  if (header) {
    const setHeaderState = () => {
      header.classList.toggle("scrolled", window.scrollY > 12);
    };
    setHeaderState();
    window.addEventListener("scroll", setHeaderState, { passive: true });
  }

  if (header && navToggle && primaryNav) {
    const closeNav = () => {
      header.classList.remove('is-nav-open');
      navToggle.setAttribute('aria-expanded', 'false');
    };
    navToggle.addEventListener('click', () => {
      const isOpen = header.classList.toggle('is-nav-open');
      navToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });
    primaryNav.querySelectorAll('a').forEach(link => link.addEventListener('click', closeNav));
    document.addEventListener('keyup', evt => {
      if (evt.key === 'Escape') closeNav();
    });
  }

  if (navLinks.length) {
    const currentPath = normalizePath(window.location.pathname);
    navLinks.forEach(link => {
      const rawHref = link.getAttribute("href") || link.href;
      const linkPath = normalizePath(rawHref);
      if (linkPath === currentPath) {
        link.classList.add("active");
        if (!link.hasAttribute("aria-current")) {
          link.setAttribute("aria-current", "page");
        }
      }
    });
  }

  const collectPostSummaries = () => {
    const seen = new Set();
    const items = [];
    document.querySelectorAll(".card .card-title a").forEach(link => {
      if (!link || !link.href) return;
      const key = normalizePath(link.href);
      if (seen.has(key)) return;
      seen.add(key);
      items.push({
        title: (link.textContent || '').trim(),
        url: link.href
      });
    });
    if (!items.length) {
      const datasetEl = document.getElementById('related-posts-data');
      if (datasetEl) {
        try {
          const dataset = JSON.parse(datasetEl.textContent || '[]');
          dataset.forEach(item => {
            if (!item || !item.url || !item.title) return;
            const key = normalizePath(item.url);
            if (seen.has(key)) return;
            seen.add(key);
            const absolute = new URL(item.url, window.location.origin).href;
            items.push({ title: item.title, url: absolute });
          });
        } catch {}
      }
    }
    return items;
  };

  const applyReadtime = (root = document) => {
    const averageWpm = 300;
    root.querySelectorAll('.readtime').forEach(el => {
      const words = Number(el.dataset.words || el.getAttribute('data-words') || 0);
      const minutes = Math.max(1, Math.round(words / averageWpm));
      el.textContent = `约 ${minutes} 分钟读完`;
    });
  };

  const postCache = collectPostSummaries();
  applyReadtime();

  const hotList = document.getElementById('hot-posts');
  if (hotList) {
    if (postCache.length) {
      hotList.innerHTML = '';
      postCache.slice(0, Math.min(8, postCache.length)).forEach((item, index) => {
        const li = document.createElement('li');
        const rank = document.createElement('span');
        rank.className = 'hot-rank';
        rank.textContent = `${index + 1}.`;
        const link = document.createElement('a');
        link.href = item.url;
        link.textContent = item.title;
        li.append(rank, link);
        hotList.append(li);
      });
    } else {
      const hotSection = hotList.closest('.hot-widget');
      if (hotSection) hotSection.style.display = 'none';
    }
  }

  const searchInput = document.getElementById('sidebar-search');
  if (searchInput && postCache.length) {
    const searchField = searchInput.parentElement;
    const suggestionHost = searchField || searchInput.closest('.search-widget');
    if (suggestionHost) {
      if (window.getComputedStyle && window.getComputedStyle(suggestionHost).position === 'static') {
        suggestionHost.style.position = 'relative';
      }
      const suggestionBox = document.createElement('div');
      suggestionBox.className = 'search-suggestions';
      suggestionHost.appendChild(suggestionBox);

      const hideSuggestions = () => {
        suggestionBox.style.display = 'none';
        suggestionBox.innerHTML = '';
      };

      searchInput.addEventListener('input', () => {
        const query = searchInput.value.trim().toLowerCase();
        suggestionBox.innerHTML = '';
        if (!query) {
          suggestionBox.style.display = 'none';
          return;
        }
        const matches = postCache.filter(item => item.title.toLowerCase().includes(query)).slice(0, 6);
        if (!matches.length) {
          suggestionBox.style.display = 'none';
          return;
        }
        matches.forEach(item => {
          const anchor = document.createElement('a');
          anchor.href = item.url;
          anchor.textContent = item.title;
          suggestionBox.appendChild(anchor);
        });
        suggestionBox.style.display = 'block';
      });

      searchInput.addEventListener('keydown', evt => {
        if (evt.key === 'Escape') {
          hideSuggestions();
        }
      });

      document.addEventListener('click', evt => {
        if (!suggestionHost.contains(evt.target)) {
          hideSuggestions();
        }
      });
    }
  }

  const relatedGrid = document.getElementById('related-cards');
  if (relatedGrid) {
    const relatedSection = document.getElementById('related');
    const dataEl = document.getElementById('related-posts-data');
    if (!dataEl) {
      if (relatedSection) relatedSection.style.display = 'none';
    } else {
      try {
        const dataset = JSON.parse(dataEl.textContent || '[]');
        const currentTags = Array.from(document.querySelectorAll('.meta-item.meta-tags .tag')).map(tag => tag.textContent.trim().toLowerCase()).filter(Boolean);
        const currentCats = Array.from(document.querySelectorAll('.meta-item.meta-categories .badge')).map(cat => cat.textContent.trim().toLowerCase()).filter(Boolean);
        const currentPath = normalizePath(window.location.pathname);
        const scored = dataset
          .filter(item => normalizePath(item.url) !== currentPath)
          .map(item => {
            const itemTags = Array.isArray(item.tags) ? item.tags.map(t => String(t).toLowerCase()) : [];
            const itemCats = Array.isArray(item.categories) ? item.categories.map(c => String(c).toLowerCase()) : [];
            let score = 0;
            if (currentTags.length) {
              score += itemTags.filter(tag => currentTags.includes(tag)).length * 2;
            }
            if (currentCats.length) {
              score += itemCats.filter(cat => currentCats.includes(cat)).length;
            }
            return { item, score };
          });
        const relevant = (currentTags.length || currentCats.length)
          ? scored.filter(entry => entry.score > 0).sort((a, b) => b.score - a.score)
          : scored;
        const fallback = relevant.length ? relevant : scored;
        const picks = fallback.slice(0, 3).map(entry => entry.item);
        if (!picks.length) {
          if (relatedSection) relatedSection.style.display = 'none';
        } else {
          const created = picks.map(item => {
            const card = document.createElement('article');
            card.className = 'card';
            card.dataset.component = 'neon-border';

            const coverLink = document.createElement('a');
            coverLink.className = 'card-cover';
            coverLink.href = new URL(item.url, window.location.origin).href;
            const img = document.createElement('img');
            img.src = item.cover || '/assets/img/cover.svg';
            img.alt = item.title || 'related post';
            img.loading = 'lazy';
            img.decoding = 'async';
            img.width = 800;
            img.height = 420;
            coverLink.appendChild(img);

            const body = document.createElement('div');
            body.className = 'card-body';

            const meta = document.createElement('div');
            meta.className = 'meta';
            const time = document.createElement('time');
            time.dateTime = item.date_iso || '';
            time.textContent = item.date || '';
            meta.appendChild(time);
            if (item.categories && item.categories.length) {
              const dot = document.createElement('span');
              dot.className = 'meta-dot';
              dot.setAttribute('aria-hidden', 'true');
              dot.textContent = '·';
              meta.appendChild(dot);
              const cat = document.createElement('span');
              cat.className = 'category';
              cat.textContent = Array.isArray(item.categories) ? item.categories.join(' / ') : item.categories;
              meta.appendChild(cat);
            }
            const readDot = document.createElement('span');
            readDot.className = 'meta-dot';
            readDot.setAttribute('aria-hidden', 'true');
            readDot.textContent = '·';
            meta.appendChild(readDot);
            const read = document.createElement('span');
            read.className = 'readtime';
            read.dataset.words = item.words || 0;
            meta.appendChild(read);

            const title = document.createElement('h3');
            title.className = 'card-title';
            const link = document.createElement('a');
            link.href = new URL(item.url, window.location.origin).href;
            link.textContent = item.title || '未命名文章';
            title.appendChild(link);

            const excerpt = document.createElement('p');
            excerpt.className = 'excerpt';
            excerpt.textContent = item.summary || '';

            body.append(meta, title, excerpt);

            if (Array.isArray(item.tags) && item.tags.length) {
              const tagsWrap = document.createElement('div');
              tagsWrap.className = 'tag-row';
              item.tags.slice(0, 4).forEach(tag => {
                const chip = document.createElement('span');
                chip.className = 'tag-chip';
                chip.textContent = `#${tag}`;
                tagsWrap.appendChild(chip);
              });
              body.appendChild(tagsWrap);
            }

            card.append(coverLink, body);
            return card;
          });
          created.forEach(card => relatedGrid.appendChild(card));
          applyReadtime(relatedGrid);
          if (created.length) {
            try {
              const module = neonModule || await import('./components/neon-border.js');
              const { setupNeonBorder } = module;
              created.forEach(setupNeonBorder);
              neonModule = module;
            } catch {}
          }
        }
      } catch {
        if (relatedSection) relatedSection.style.display = 'none';
      }
    }
  }

  // Glitch title (hero)
  const glitchEl = document.querySelector('[data-component="glitch-title"]');
  if (glitchEl && !prefersReduced) {
    const { setupGlitchTitle } = await import('./components/glitch-title.js');
    setupGlitchTitle(glitchEl);
  }

  // Neon border for cards
  const neonTargets = document.querySelectorAll('[data-component="neon-border"]');
  if (neonTargets.length) {
    neonModule = await import('./components/neon-border.js');
    const { setupNeonBorder } = neonModule;
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
    setupSearch(searchLayer, { endpoint: '/search.json' });
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
      try {
        await navigator.clipboard.writeText(code.textContent || '');
        btn.textContent = '已复制';
        setTimeout(() => btn.textContent = '复制', 1500);
      } catch {}
    });
    wrap.appendChild(btn);
  });
});