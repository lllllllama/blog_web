import { inView } from '../anim/observer.js';

export function setupParallax(el, { intensity = 0.08 }={}){
  let lastY = 0; let active = false;
  const onScroll = ()=>{
    if (!active) return;
    const r = el.getBoundingClientRect();
    const mid = window.innerHeight/2;
    const dy = (r.top + r.height/2 - mid) * -intensity;
    el.style.transform = `translateY(${dy.toFixed(2)}px)`;
  };
  inView(el, { threshold: 0 }, () => { active = true; onScroll(); }, () => { active = false; el.style.transform='translateY(0)'; });
  window.addEventListener('scroll', onScroll, { passive: true });
}

