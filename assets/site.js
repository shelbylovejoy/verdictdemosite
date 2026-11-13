/* Stamps press in once as they scroll into view. Without JS, or with
   prefers-reduced-motion, every stamp is simply visible. */
(function () {
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (reduce || !('IntersectionObserver' in window)) return;
  var stamps = document.querySelectorAll('.stamp');
  if (!stamps.length) return;
  document.documentElement.classList.add('js');
  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting) return;
      var el = e.target;
      var i = Number(el.getAttribute('data-i') || 0);
      setTimeout(function () { el.classList.add('is-in'); }, i * 90);
      io.unobserve(el);
    });
  }, { rootMargin: '0px 0px -10% 0px', threshold: 0.2 });
  stamps.forEach(function (el, i) { el.setAttribute('data-i', i % 4); io.observe(el); });
  /* safety: never leave a stamp hidden */
  setTimeout(function () { stamps.forEach(function (el) { el.classList.add('is-in'); }); }, 4000);
})();
