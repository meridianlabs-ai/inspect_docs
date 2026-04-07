# llms.txt

## Index Page

Inspect Docs produces an [`llms.txt`](https://llmstxt.org) index page at the root of your site, built from your site’s `title`, `description`, `navigation`, and reference pages:

``` markdown
# My Package

> Description of what the package does.

## Docs

- [Getting Started](https://docs.example.com/index.html): Install the package and render your first site.
- [Guides](https://docs.example.com/guides/index.html): Task-oriented walkthroughs.

## API Reference

- [my_package](https://docs.example.com/reference/my_package.html): Core tasks and utilities.
- [my_package.utils](https://docs.example.com/reference/my_package.utils.html): Helper functions.

## CLI Reference

- [my_package run](https://docs.example.com/reference/my_package_run.html): Run a task.
```

### Descriptions

Each entry in `llms.txt` uses the page’s frontmatter `description` field as its summary.

To use a different summary for `llms.txt` than the one shown on the page, set `llms-description`:

``` yaml
---
title: Getting Started
description: Get up and running in five minutes!
llms-description: Installation, first render, and project layout.
---
```

If `llms-description` is absent, `description` is used.

## Markdown Pages

Inspect Docs also publishes a plain-Markdown version of each page at the same URL with `.html.md` appended. A page rendered at `https://docs.example.com/guides/install.html` is also available at `https://docs.example.com/guides/install.html.md`.

Inspect Docs also injects a **Copy page** button into every page header. The button lets readers:

- **Copy as Markdown** — copy the page’s Markdown source to the clipboard.
- **Open as Markdown** — open the `.html.md` version in a new tab.
