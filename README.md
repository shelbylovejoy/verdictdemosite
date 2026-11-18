# shelbylovejoy.com

Personal site, served by GitHub Pages from `main` (see `CNAME`). Plain HTML and CSS, no build step.

- `index.html` — homepage (the passport)
- `verdict/` — the Verdict case study
- `duolingo/` — Duo Go concept page
- `resume/`, `resume/pm/`, `resume/swe/` — short links that open the resume PDFs at the root
- `assets/site.css`, `assets/site.js`, `assets/fonts/` — shared styles, a small script for the stamp animation, and self-hosted Gloock, Albert Sans and Azeret Mono
- `images/` — photos, case-study screenshots, favicon and Open Graph images

To preview locally, serve the repo root (paths are absolute), for example:

```bash
python3 -m http.server 8080
```

## Checking for AI tells

`.claude/agents/ai-tells-reviewer.md` is a Claude Code agent that reviews pages for design and copy that read as machine-generated. In Claude Code, ask it to "use the ai-tells-reviewer agent on index.html". It starts from a quick grep pass you can also run yourself:

```bash
bash scripts/ai-tells-lint.sh index.html verdict/index.html assets/site.css
```
