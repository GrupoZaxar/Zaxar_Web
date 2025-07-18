document.addEventListener('DOMContentLoaded', () => {
  const cards = document.querySelectorAll('.service-card');

  cards.forEach(card => {
    card.addEventListener('click', () => {
      cards.forEach(c => {
        if (c !== card) {
          c.classList.remove('active');
        }
      });
      card.classList.toggle('active');
    });
  });
});
