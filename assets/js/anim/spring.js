// Simple critically damped spring approximator
export function spring(from, to, stiffness=0.12, damping=0.85, threshold=0.002, cb){
  let v = 0; let x = from; let raf;
  function step(){
    const f = (to - x) * stiffness;
    v = v * damping + f;
    x += v;
    cb && cb(x);
    if (Math.abs(v) + Math.abs(to - x) > threshold) raf = requestAnimationFrame(step);
  }
  step();
  return () => cancelAnimationFrame(raf);
}

