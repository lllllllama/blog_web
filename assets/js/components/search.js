function createIndex(list){
  // 简易倒排索引：title + tags + categories + content
  const index = new Map();
  list.forEach((doc, i) => {
    const text = `${doc.title} ${doc.tags?.join(' ')||''} ${doc.categories?.join(' ')||''} ${doc.summary} ${doc.content}`.toLowerCase();
    const tokens = text.split(/[^\p{L}\p{N}]+/u).filter(Boolean);
    const seen = new Set();
    tokens.forEach(t => { if (seen.has(t)) return; seen.add(t); if (!index.has(t)) index.set(t, []); index.get(t).push(i); });
  });
  return {
    search(q){
      q = q.trim().toLowerCase(); if (!q) return [];
      const tokens = q.split(/\s+/).filter(Boolean);
      let ids = null;
      tokens.forEach(t => { const hits = index.get(t)||[]; ids = ids===null ? new Set(hits) : new Set(hits.filter(id => ids.has(id))); });
      return Array.from(ids||[]);
    }
  }
}

export function setupSearch(layer, { endpoint='/search.json' }={}){
  const input = layer.querySelector('input[type="search"]');
  const results = layer.querySelector('.search-results');
  let data = []; let idx = null; let open = false; let active = -1;

  async function ensure(){ if (data.length) return; const res = await fetch(endpoint, { cache: 'no-store' }); data = await res.json(); idx = createIndex(data); }

  function render(ids){
    results.innerHTML = '';
    ids.slice(0, 30).forEach(id => {
      const d = data[id];
      const a = document.createElement('a'); a.className='search-item'; a.href=d.url; a.innerHTML = `<strong>${d.title}</strong><br><small>${new Date(d.date).toLocaleDateString()} · ${(d.tags||[]).join(', ')}</small><div>${d.summary||''}</div>`;
      results.appendChild(a);
    });
  }

  function openLayer(){
    open = true; layer.hidden = false; document.body.style.overflow='hidden'; input.focus(); input.select();
  }
  function closeLayer(){
    open = false; layer.hidden = true; document.body.style.overflow=''; active=-1; results.innerHTML=''; input.value='';
  }

  layer.addEventListener('open', async ()=>{ await ensure(); openLayer(); });
  layer.addEventListener('click', (e)=>{ if (e.target === layer) closeLayer(); });
  layer.querySelector('[data-action="close-search"]').addEventListener('click', closeLayer);

  document.addEventListener('keydown', (e)=>{
    if (e.key === '/' && !open && !['INPUT','TEXTAREA'].includes(document.activeElement.tagName)) { e.preventDefault(); layer.dispatchEvent(new CustomEvent('open')); }
    if (e.key === 'Escape' && open) { e.preventDefault(); closeLayer(); }
  });

  input.addEventListener('input', ()=>{
    const q = input.value.trim(); if (!q) { results.innerHTML=''; return; }
    const ids = idx.search(q);
    render(ids);
  });
}

