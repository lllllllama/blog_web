export function inView(target, options={}, onEnter, onLeave){
  const io = new IntersectionObserver((entries)=>{
    entries.forEach(e=>{
      if (e.isIntersecting) onEnter && onEnter(e.target, e);
      else onLeave && onLeave(e.target, e);
    })
  }, options);
  io.observe(target);
  return () => io.disconnect();
}

