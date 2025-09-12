export function setupToc(container, contentRoot){
  if (!contentRoot) return;
  const heads = contentRoot.querySelectorAll('h2, h3');
  if (!heads.length) { container.innerHTML = '<div class="toc-empty">无目录</div>'; return; }
  const ul = document.createElement('ul');
  heads.forEach(h => {
    if (!h.id) h.id = h.textContent.trim().toLowerCase().replace(/\s+/g,'-').replace(/[^\w\-]/g,'');
    const li = document.createElement('li');
    li.className = h.tagName.toLowerCase();
    const a = document.createElement('a');
    a.href = `#${h.id}`; a.textContent = h.textContent.trim();
    li.appendChild(a); ul.appendChild(li);
  });
  container.innerHTML = ''; container.appendChild(ul);

  const items = container.querySelectorAll('a');
  const obs = new IntersectionObserver((entries)=>{
    entries.forEach(e=>{
      const id = e.target.id;
      const link = container.querySelector(`a[href="#${CSS.escape(id)}"]`);
      if (!link) return;
      if (e.isIntersecting) {
        items.forEach(i=>i.classList.remove('active'));
        link.classList.add('active');
      }
    })
  }, { rootMargin: '-30% 0px -60% 0px', threshold: 0 });
  heads.forEach(h => obs.observe(h));
}

