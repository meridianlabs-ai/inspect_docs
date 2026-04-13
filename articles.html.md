# Articles – Inspect Docs

Articles are the prose pages of your docs site: guides, tutorials, explainers, design notes—anything that isn’t auto-generated API reference. They’re written as `.qmd` files and organized through the `navigation` key in `_quarto.yml`.

## Basics

By default, Inspect Docs will symlink any `README.md` and `CHANGELOG.md` from the root of your repo into the docs directory. The README becomes your landing page (rendered at `index.qmd`) unless you create your own `index.qmd`, in which case the README symlink is skipped and your page takes precedence.

If you’d rather write a dedicated landing page that’s different from your README, just create `docs/index.qmd` and populate it however you like—the rest of the site behaves identically.

Add more articles by creating a `.qmd` file anywhere in your docs directory with a title and (optionally) a description in the frontmatter:

``` markdown
---
title: Getting Started
description: Install the package and render your first site.
---

Welcome!
```

The `description` field is used in the auto-generated reference index, in OpenGraph/Twitter cards, and as the page’s entry in `llms.txt`.

## Navigation

The `navigation` key in `_quarto.yml` defines both the navbar and the sidebar from a single source.

### Simple entries

Top-level items with `text` and `href` become navbar links *and* sidebar entries:

``` yaml
inspect-docs:
  navigation:
    - text: Getting Started
      href: index.qmd
    - text: FAQ
      href: faq.qmd
```

### Nested sections

Items with a `contents` list become navbar dropdown menus and sidebar sections:

``` yaml
inspect-docs:
  navigation:
    - text: Getting Started
      href: index.qmd
    - text: Guides
      contents:
        - text: Installation
          href: guides/install.qmd
        - text: Configuration
          href: guides/config.qmd
        - text: Publishing
          href: guides/publish.qmd
```

The dropdown label (“Guides” above) doesn’t have an `href` of its own—it just groups the child entries.

### Automatic entries

Inspect Docs adds a couple of navbar entries automatically:

- A **Reference** link is appended to the navbar whenever a `reference/` directory exists.
- A **Changelog** link is added to the navbar’s right side whenever the project root contains a `CHANGELOG.md`.

You don’t need to list either of these in `navigation`.

## Diagrams

Quarto has built-in support for [Mermaid](https://quarto.org/docs/authoring/diagrams.html#mermaid) and [Graphviz](https://quarto.org/docs/authoring/diagrams.html#graphviz) diagrams — see [Quarto’s diagram documentation](https://quarto.org/docs/authoring/diagrams.html).

Inspect Docs adds support for [Excalidraw](https://excalidraw.com). Embed an `.excalidraw` file as an image and the extension converts it to SVG at build time (Node.js dependencies are installed on first use; results are cached):

``` markdown
![Architecture](diagrams/architecture.excalidraw)
```

Optional attributes control the rendered output:

``` markdown
![Architecture](diagrams/architecture.excalidraw){theme=dark background=true padding=20 scale=2}
```

| Attribute    | Default | Description                           |
|--------------|---------|---------------------------------------|
| `theme`      | `light` | `light` or `dark`                     |
| `background` | `false` | Include the Excalidraw background     |
| `padding`    | `10`    | Padding around the diagram, in pixels |
| `scale`      | `1`     | Export scale factor                   |
