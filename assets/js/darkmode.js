(() => {
  const KEY = 'prefers-color-scheme';
  const root = document.documentElement;
  const initial = localStorage.getItem(KEY);
  const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  if (initial === 'dark' || (!initial && prefersDark)) {
    root.setAttribute('data-theme', 'dark');
  }

  window.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('darkmode-toggle');
    if (!btn) return;
    btn.addEventListener('click', () => {
      const isDark = root.getAttribute('data-theme') === 'dark';
      root.setAttribute('data-theme', isDark ? 'light' : 'dark');
      localStorage.setItem(KEY, isDark ? 'light' : 'dark');
    });
  });
})();

