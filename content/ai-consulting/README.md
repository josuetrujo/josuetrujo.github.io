# Lumen AI — Consulting Website

A four-page static site for an AI consulting business, ready to deploy on GitHub Pages or any static host.

## File structure

```
/
├── index.html        Home page
├── services.html     Services detail page
├── about.html        About / founder story
├── contact.html      Contact form
├── styles.css        Shared design system
├── script.js         Nav, scroll reveal, form handler
└── README.md         This file
```

No build step. No dependencies. Just HTML, CSS, and a tiny bit of JS.

## How to deploy on GitHub Pages

1. Create a new GitHub repo (public). Common names: `lumen-ai`, `consulting-site`, or `<username>.github.io` (if you want it at your root domain).
2. Upload all the files in this folder to the repo root.
3. Go to **Settings → Pages**.
4. Under **Source**, select `Deploy from a branch` → `main` → `/ (root)`.
5. Save. Your site goes live at `https://<username>.github.io/<repo-name>/` within a minute or two.

## A note about Quartz

Quartz is a Markdown-based static site generator built for Obsidian vaults — it expects `.md` files inside a `content/` folder and generates HTML from them. If you want to use Quartz specifically (rather than plain GitHub Pages), you'd need to either:

- Convert these pages to Markdown and lose most of the custom design, **or**
- Drop these HTML files into Quartz's `public/` or `static/` folder and link to them as standalone pages alongside your notes.

For a marketing site like this one, **plain GitHub Pages is the simpler path** — what you're already doing with this repo. Quartz shines for note collections, not marketing sites.

## Things to customize before launch

Find-and-replace these placeholders across all `.html` files (and `script.js`):

| Find | Replace with |
|---|---|
| `Lumen AI` | Your real company name |
| `hello@lumen-ai.example` | Your real email address |
| `Sacramento, California` | Your actual location, if different |
| `© 2026 Lumen AI Consulting` | Your real copyright line |

In `about.html`, the photo placeholder is a stylized "J" — swap the `.about-photo` div for a real `<img>` tag pointing at a headshot (e.g. `<img src="founder.jpg" alt="Josue Trujillo" />`).

In `script.js`, the contact form currently opens the visitor's email client via `mailto:`. If you want real form submissions, replace the `mailto:` logic with a service like Formspree, Web3Forms, or Netlify Forms (each is free for low volumes and requires only a tiny code change).

## Design notes

- **Type**: Fraunces (display serif) + Manrope (body) + JetBrains Mono (labels), all from Google Fonts.
- **Colors**: warm cream background, deep ink text, vermillion accent. Set as CSS variables at the top of `styles.css` — change them once, change the whole site.
- **Motion**: subtle scroll reveals, a marquee on the home page, hover states on the nav and buttons. All respects `prefers-reduced-motion`.
- **Responsive**: tested down to 360px width.
- **Accessibility**: semantic HTML, labelled form fields, keyboard-navigable, color-contrast safe.

## License

Yours. Do whatever you want with it.
