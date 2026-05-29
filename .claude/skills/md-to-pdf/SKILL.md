---
name: md-to-pdf
description: Convert markdown files to well-formatted PDF. Use when the user wants to export, render, or convert a .md file to PDF.
---

# Markdown to PDF

Convert markdown to PDF using pandoc with xelatex. Produces clean sans-serif output with syntax-highlighted code blocks.

## Prerequisites

- `pandoc` (brew install pandoc)
- `basictex` (brew install --cask basictex)
- LaTeX packages: `sudo tlmgr install fontspec unicode-math selnolig upquote microtype parskip xurl bookmark fancyvrb csquotes framed fvextra`

## Command

```bash
pandoc INPUT.md -o OUTPUT.pdf \
  --resource-path=DIRECTORY_CONTAINING_IMAGES \
  --pdf-engine=xelatex \
  -H ~/.claude/skills/md-to-pdf/wrap-code.tex \
  -V mainfont="Helvetica Neue" \
  -V monofont="Menlo" \
  -V fontsize=11pt \
  -V geometry:margin=1in \
  -V colorlinks=true \
  -V linkcolor=NavyBlue \
  -V urlcolor=NavyBlue \
  --syntax-highlighting=tango
```

## Usage Notes

- `--resource-path` must point to the directory containing any images referenced in the markdown (relative paths). Usually the directory the markdown file lives in.
- `-H wrap-code.tex` loads `fvextra` and redefines pandoc's `Highlighting` environment with `breaklines`/`breakanywhere`, so long lines in code blocks wrap inside the page (with a `↪` continuation marker) instead of running off the right edge.
- On macOS, `Helvetica Neue` and `Menlo` are always available. On Linux, substitute with `DejaVu Sans` / `DejaVu Sans Mono`. On Windows, `Segoe UI` / `Cascadia Code`.
- `Helvetica Neue` lacks some glyphs (e.g. `→ U+2192`). If pandoc warns `Missing character`, pre-process the source to render those glyphs as math, e.g. `sed 's/→/$\\rightarrow$/g' IN.md > tmp.md`, then convert `tmp.md`.
- If the output PDF lands in a sandboxed-unwritable directory (e.g. `~/Downloads`), write to `$TMPDIR` first and `mv` it to the destination.
- The `tango` syntax highlighting theme works well with light backgrounds. Other options: `kate`, `monochrome`, `espresso`, `haddock`, `zenburn`.
