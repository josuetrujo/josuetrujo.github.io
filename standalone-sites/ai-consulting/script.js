// ==========================================================================
// LUMEN AI — Interaction layer
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {

  // --- Mobile nav toggle ---
  const toggle = document.querySelector('.nav-toggle');
  const links = document.querySelector('.nav-links');
  if (toggle && links) {
    toggle.addEventListener('click', () => {
      const open = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open);
    });
    links.querySelectorAll('a').forEach(a => {
      a.addEventListener('click', () => links.classList.remove('open'));
    });
  }

  // --- Mark current page in nav ---
  const path = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-links a').forEach(a => {
    const href = a.getAttribute('href');
    if (href === path || (path === '' && href === 'index.html')) {
      a.classList.add('active');
    }
  });

  // --- Scroll reveal ---
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('in');
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });

  document.querySelectorAll('.reveal').forEach(el => io.observe(el));

  // --- Contact form (graceful no-backend handling) ---
  const form = document.querySelector('#contact-form');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const data = new FormData(form);
      const name = data.get('name') || 'there';
      const subject = encodeURIComponent(`New inquiry from ${data.get('name') || 'website'}`);
      const body = encodeURIComponent(
        `Name: ${data.get('name')}\n` +
        `Email: ${data.get('email')}\n` +
        `Company: ${data.get('company')}\n` +
        `Business type: ${data.get('industry')}\n` +
        `Goal: ${data.get('goal')}\n\n` +
        `Message:\n${data.get('message')}`
      );
      // Opens user's email client with prefilled message.
      // REPLACE the address below with your real inbox.
      window.location.href = `mailto:hello@lumen-ai.example?subject=${subject}&body=${body}`;
      const status = document.querySelector('#form-status');
      if (status) {
        status.textContent = `Thanks ${name} — your email app should open with the details ready to send.`;
        status.style.opacity = '1';
      }
    });
  }
});
