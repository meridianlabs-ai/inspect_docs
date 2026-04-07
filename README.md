# Inspect Docs

A Quarto project type extension for Python package documentation with automatic API reference generation.

## Overview

`inspect-docs` automatically creates documentation websites for Python packages with minimal configuration. From a single `_quarto.yml` and a handful of `.qmd` files you get:

- A navbar + sidebar site built on Quarto, with sensible defaults.
- Automatically generated **API reference** pages from your source code (via [griffe](https://mkdocstrings.github.io/griffe/)) and Click CLI commands.
- Interlinks that automatically turn inline ``` `MyClass` ``` and ``` `my_function()` ``` into links to the right reference page — locally *or* across other `inspect-docs` sites you depend on.
- An auto-generated [`llms.txt`](https://llmstxt.org) and per-page Markdown source so LLMs can ingest your docs.


## Getting Started

To create a new documentation site within a Python package:

```bash
mkdir docs
cd docs
quarto use template meridianlabs-ai/inspect-docs
```

To take an existing doc site and update it to use `inspect-docs`:

```bash
cd docs
quarto add meridianlabs-ai/inspect-docs
```

Then, edit your `_quarto.yml` to reference the project type and provide basic site configuration:

```yaml
project:
  type: meridianlabs-ai/inspect-docs

inspect-docs:
  title: "Package Title"
  description: "Package Description"
  url: https://example.com/mypackage
  repo: myorg/mypackage
  org: My Org
```

To update to a more recent version of the extension:

```bash
cd docs
quarto update meridianlabs-ai/inspect-docs
```

## First Render

Before rendering for the first time, add the documentation dependencies to your project. `inspect-docs` requires Quarto 1.9.36 or later plus a handful of Python packages, which should live in your `dev` dependencies. For example:

```toml
[dependency-groups]
dev = [
    "ruff",
    "pytest",
    "pyright",
    ...
    {include-group = "doc"},
]
doc = [
    "jupyter",
    "panflute",
    "markdown",
    "griffe",
    "pyyaml",
    "types-PyYAML",
    "quarto-cli>=1.9.36",
]
```

Then install them:

```bash
uv sync
```

By default, `inspect-docs` will symlink to any `README.md` and `CHANGELOG.md` in the root of your repo and create a site based on their contents. Once the dependencies are installed, preview the site with:

```bash
cd docs
quarto preview
```

## Articles

Add articles by creating `.qmd` files in the documentation directory. If you don't want to share the `README.md` create an `index.qmd` to replace it. As you add articles you'll also need to list them in site `navigation`. For example:

```yaml
project:
  type: meridianlabs-ai/inspect-docs

inspect-docs:
  title: "Package Title"
  description: "Package Description"
  url: https://example.com/mypackage
  repo: myorg/mypackage
  org: My Org
  navigation:
    - text: Getting Started
      href: index.qmd
    - text: Guides
      contents:
        - text: Installation
          href: guides/install.qmd
        - text: Configuration
          href: guides/config.qmd
```

### Navigation

The `navigation` key defines both the navbar and sidebar from a single source:

- Simple items (`text` + `href`) appear as navbar links and sidebar entries.
- Items with `contents` become navbar dropdown menus and sidebar sections.
- A "Reference" link is automatically appended to the navbar when a `reference/` directory exists.


## Reference

Place reference `.qmd` files in a `reference/` directory. The extension auto-discovers them and builds the reference sidebar and cross-reference index.

### Python API

Create a `.qmd` file whose title matches your module name. Add H3 headings for each symbol to document:

```markdown
---
title: my_package
---

## Task

### my_function
### MyClass

## Utilities

### helper_function
```

The H2 headings are organizational sections (rendered as-is). Each H3 heading is replaced with full API documentation generated from the Python source via [griffe](https://mkdocstrings.github.io/griffe/) -- including the function/class signature, docstring, parameters, attributes, methods, and a link to the source code on GitHub.

Docstrings must use [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings).

For submodule pages, use a dotted title:

```markdown
---
title: my_package.utils
---

### format_output
### parse_input
```

### CLI Commands

For [Click](https://click.palletsprojects.com/) CLI commands, use the filename convention `<module>_<command>.qmd`:

```markdown
---
title: my_package run
description: Run a task.
---
```

The CLI module and attribute are derived from the filename. For `my_package_run.qmd`, the extension loads the Click command from `my_package._cli.run` (attribute `run`). The page is populated with usage, description, options, and subcommands.

### Filename Conventions

Reference pages follow these filename patterns:

| Pattern | Type | Example |
|---|---|---|
| `<module>.qmd` | API (main module) | `my_package.qmd` |
| `<module>.<sub>.qmd` | API (submodule) | `my_package.utils.qmd` |
| `<module>_<command>.qmd` | CLI command | `my_package_run.qmd` |

### Reference Index

A `reference/index.qmd` is automatically generated from the discovered reference pages, using the `description` field from each page's frontmatter.

### Inline Reference

You can embed API reference documentation in any page (not just reference pages) using the `reference` attribute on a heading.

First, add a `reference` metadata field to the page's frontmatter pointing to the module:

```markdown
---
title: Getting Started
reference: my_package
---
```

Then use the `reference` attribute on any heading:

```markdown
## Key functions

### My Function {reference="my_function"}

Some additional context about this function...

### My Class {reference="MyClass"}
```

The heading content becomes the display title while the `reference` attribute specifies which Python object to document.

## Interlinks

Inline code references to documented symbols are automatically linked to their reference pages on every page in the site, not just reference pages:

- ``` `MyClass` ``` -- class names (starts with uppercase) link to the class's reference page
- ``` `my_function()` ``` -- function calls (ends with `()`) link to the function's reference page

When `external_refs` is configured (see below), inline code references also resolve against those external packages, so a single ``` `SomeClass` ``` may link to your own docs *or* a dependency's docs.

## External References

You can link to API symbols documented in *other* `inspect-docs` sites by declaring them under `external_refs` in `_quarto.yml`:

```yaml
inspect-docs:
  external_refs:
    inspect_ai: https://inspect.aisi.org.uk
    other_package: https://docs.example.com/other
```

At render time the extension fetches `{url}/reference/refs.json` from each listed package and caches it locally. Inline code references in your prose are then resolved against both the local project and the external packages:

- ``` `SomeClass` ``` -- resolved locally first, then against external packages
- ``` `other_package::SomeClass` ``` -- force lookup in a specific external package

Links point at the external site's reference pages, so readers can move seamlessly between projects.

If a fetch fails (e.g. the site is down or the URL is wrong) the build does **not** fail: the extension reuses the previously cached copy if one exists, otherwise it prints a warning and continues without that package's links.
Any site built with `inspect-docs` is automatically a valid `external_refs` target — `reference/refs.json` is generated and published as part of every render, so other projects can point at your site's URL and pick up your symbols with no extra configuration on your end.

## llms.txt

The extension automatically generates an [llms.txt](https://llmstxt.org) file at the root of your rendered site, giving LLMs a structured map of your documentation. No configuration is required -- it's built from your `title`, `description`, `navigation`, and reference pages.

Each page's entry uses its frontmatter `description` field as the summary. If you want a different summary for the llms.txt specifically, set `llms-description`:

```yaml
---
title: Getting Started
description: A short intro shown on the page itself.
llms-description: Installation, first render, and project layout.
---
```

Alongside `llms.txt`, every page is also published as plain Markdown (at the page URL with `.html.md` appended), and a **Copy page** button in the page header lets readers copy the Markdown or open it in a new tab -- handy for pasting into a chat with an LLM.

## Diagrams

You can embed [Excalidraw](https://excalidraw.com) diagrams directly by referencing a `.excalidraw` file as an image. The extension converts it to SVG at build time (Node.js dependencies are installed on first use and results are cached):

```markdown
![Architecture](diagrams/architecture.excalidraw)
```

Optional attributes control appearance:

```markdown
![Architecture](diagrams/architecture.excalidraw){theme=dark background=true padding=20 scale=2}
```

| Attribute    | Default | Description                           |
|--------------|---------|---------------------------------------|
| `theme`      | `light` | `light` or `dark`                     |
| `background` | `false` | Include the Excalidraw background     |
| `padding`    | `10`    | Padding around the diagram, in pixels |
| `scale`      | `1`     | Export scale factor                   |


## Configuration Reference

All fields under `inspect-docs:` in `_quarto.yml` are optional; sensible defaults apply.

| Field           | Description                                                                                   |
|-----------------|-----------------------------------------------------------------------------------------------|
| `title`         | Site title. Auto-extracted from the index page H1 if omitted.                                 |
| `description`   | Site description. Used for OpenGraph/Twitter cards and the llms.txt header.                   |
| `url`           | Canonical site URL. Used when generating absolute links in llms.txt.                          |
| `repo`          | GitHub repo as `org/repo`. Enables the navbar GitHub icon and source links on reference pages. |
| `org`           | Organization name. Adds a left-side footer link.                                              |
| `module`        | Python import name. Auto-discovered from `pyproject.toml`; set explicitly only when the import name differs from the distribution name. |
| `navigation`    | Navbar and sidebar entries (see [Navigation](#navigation)).                                   |
| `sidebar`       | Show the sidebar. Defaults to `true` when `navigation` is set.                                |
| `external_refs` | Map of `package_name: docs_url` for cross-package interlinking (see [External References](#external-references)). |

### Page Frontmatter

These fields are set on individual `.qmd` pages, not in `_quarto.yml`:

| Field             | Description                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------|
| `title`           | Page title. On reference pages this also identifies the module being documented.                     |
| `description`     | One-line summary. Used in the auto-generated reference index and as the page's `llms.txt` entry.     |
| `llms-description`| Optional override for the `llms.txt` entry when you want a different summary than `description`.     |
| `reference`       | Module name for [Inline Reference](#inline-reference) — enables `{reference="..."}` heading attributes on this page. |
