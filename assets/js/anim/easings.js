export const easeInOut = (t) => (t<.5 ? 2*t*t : -1+(4-2*t)*t);
export const easeCubic = (t) => t*t*t;
export const easeOutCubic = (t) => (--t)*t*t+1;
export const easeInCubic = (t) => t*t*t;

