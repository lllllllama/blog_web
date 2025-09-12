export function setupGlitchTitle(el){
  const base = el.textContent.trim();
  el.setAttribute('data-text', base);
  let t;
  function jitter(){
    const dx = (Math.random()*2-1)*1.2;
    const dy = (Math.random()*2-1)*0.6;
    el.style.transform = `translate(${dx}px, ${dy}px)`;
    t = setTimeout(()=>{ el.style.transform = 'translate(0,0)'; }, 120 + Math.random()*120);
  }
  const onEnter = ()=>{ jitter(); };
  el.addEventListener('mouseenter', onEnter);
  // Soft idle glitches
  let idle = setInterval(()=>{ if (document.visibilityState==='visible') jitter(); }, 3200);
  el.addEventListener('mouseleave', ()=>{ clearTimeout(t); el.style.transform='translate(0,0)'; });
  document.addEventListener('visibilitychange', ()=>{ if (document.hidden) clearInterval(idle); else idle = setInterval(jitter, 3200); });
}

