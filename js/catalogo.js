/* =========================================================
   CATALOGO.JS — catálogo + filtro + modal con info
========================================================= */

/* ─── Referencias al DOM ──────────────────────────────── */
const contenedor     = document.getElementById('listaPropiedades');
const galeriaInner   = document.getElementById('galeriaInner');
const galeriaInfo    = document.getElementById('galeriaInfo');
const galeriaTexto   = document.getElementById('galeriaTexto');
const galeriaModal   = new bootstrap.Modal('#galeriaModal');
const filtroSelect   = document.getElementById('filtroTipo');

/* ─── Estado global: lista completa de propiedades ───── */
let todasPropiedades = [];

/* ─── 1. Cargar JSON una sola vez ─────────────────────── */
fetch('data/propiedades.json')
  .then(res => res.json())
  .then(lista => {
    todasPropiedades = lista;
    pintar(lista);                               // pinta todo
  })
  .catch(err => console.error('Error al cargar propiedades:', err));

/* ─── 2. Escuchar cambios en el filtro ───────────────── */
filtroSelect.addEventListener('change', () => {
  const tipo = filtroSelect.value;               // "", Piso, Adosado, Casa
  const filtradas = tipo
    ? todasPropiedades.filter(p => p.tipo === tipo)
    : todasPropiedades;

  pintar(filtradas);
});

/* ─── 3. Delegación de clics para abrir el modal ─────── */
contenedor.addEventListener('click', e => abrirGaleria(e, todasPropiedades));

/* ─── Función para dibujar tarjetas ──────────────────── */
function pintar(lista) {
  contenedor.innerHTML = '';                     // limpia contenedor
  lista.forEach(p => contenedor.appendChild(crearCard(p)));
  animarEntrada();
}

/* ─── Animación de entrada ───────────────────────────── */
function animarEntrada() {
  const elementos = document.querySelectorAll('.animate-on-load');
  elementos.forEach((el, i) => {
    setTimeout(() => el.classList.add('show'), i * 100); // 100 ms de escalón
  });
}


/* ─── Crear tarjeta bootstrap ────────────────────────── */
function crearCard(p) {
  const col = document.createElement('div');
  col.className = 'col animate-on-load'; 

  col.innerHTML = `
    <article class="card h-100 shadow-sm">
      <img src="img/propiedades/${p.id}/${p.id}_1.png"
           class="card-img-top" loading="lazy" alt="${p.titulo}">
      <div class="card-body card_house d-flex flex-column">
        <h5 class="card-title">${p.titulo}</h5>
        <p class="card-text flex-grow-1">
          <i class="bi bi-geo-alt-fill me-1"></i>${p.localidad}<br>
          ${p.dormitorios} dorm · ${p.baños} baños · ${p.metros} m²
        </p>
        <h6 class="text-primary fw-bold mb-3">
          ${p.precio.toLocaleString('es-ES')} €
        </h6>
        <button class="btn btn-outline-primary w-100" data-id="${p.id}">
          Ver fotos
        </button>
      </div>
    </article>`;
  return col;
}

/* ─── Modal: generar carrusel + info ─────────────────── */
function abrirGaleria(evento, lista) {
  const btn = evento.target.closest('button[data-id]');
  if (!btn) return;

  const id   = btn.dataset.id;
  const prop = lista.find(p => p.id === id);
  if (!prop) return;

  /* 1. Slides del carrusel */
  galeriaInner.innerHTML = '';
  for (let i = 1; i <= prop.imagenes; i++) {
    galeriaInner.insertAdjacentHTML('beforeend', `
      <div class="carousel-item ${i === 1 ? 'active' : ''}">
        <img src="img/propiedades/${id}/${id}_${i}.png"
             class="d-block w-100" alt="${prop.titulo} foto ${i}">
      </div>`);
  }

  /* 2. Texto descriptivo */
  galeriaTexto.innerHTML = `
    <h5 class="mb-2">${prop.titulo}</h5>
    <p class="mb-1">
      <i class="bi bi-geo-alt-fill me-1"></i>${prop.localidad}<br>
      ${prop.dormitorios} dorm · ${prop.baños} baños · ${prop.metros} m²
    </p>
    <strong class="text-primary fs-5">
      ${prop.precio.toLocaleString('es-ES')} €
    </strong>`;

  /* 3. Mostrar modal */
  bootstrap.Carousel.getOrCreateInstance('#galeriaCarousel').to(0);
  galeriaModal.show();
}
