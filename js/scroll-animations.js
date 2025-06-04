// js/scroll-animations.js
document.addEventListener('DOMContentLoaded', () => {
  const options = {
    root: null,          // viewport
    rootMargin: '0px',
    threshold: 0.1       // basta con que se vea un 10 %
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // ⇢ entra en pantalla → añade la clase que anima
        entry.target.classList.add('animate');
      } else {
        // ⇢ sale de pantalla → quita la clase para que pueda reanimarse
        entry.target.classList.remove('animate');
      }
    });
  }, options);

  // Observa todos los elementos marcados
  document.querySelectorAll('.animate-on-scroll')
          .forEach(el => observer.observe(el));
});
