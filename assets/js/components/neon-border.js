export function setupNeonBorder(el){
  el.addEventListener('mouseenter', ()=>{
    el.style.boxShadow = getComputedStyle(document.documentElement).getPropertyValue('--accent-glow');
  });
  el.addEventListener('mouseleave', ()=>{
    el.style.boxShadow = 'var(--shadow)';
  });
}

