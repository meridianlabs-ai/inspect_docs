# Inspect Docs

Inspect Docs helps you create documentation websites for Python packages using Quarto:

- Author articles using all the features of standard Quarto markdown.
- Generate API reference pages from your source code via [griffe](https://mkdocstrings.github.io/griffe/).
- Automatically turn inline code references into links to documentation.
- Generate an [llms.txt](https://llmstxt.org) and Markdown doc pages so LLMs can ingest your site.

## Getting Started

### Installation

To create a new documentation site within a Python package:

``` bash
mkdir docs
cd docs
quarto use template meridianlabs-ai/inspect-docs
```

To take an existing doc site and update it to use `inspect-docs`:

``` bash
cd docs
quarto add meridianlabs-ai/inspect-docs
```

To update to a more recent version of the extension:

``` bash
cd docs
quarto update meridianlabs-ai/inspect-docs
```

### Configuration

Edit `docs/_quarto.yml` to reference the project type and provide basic site configuration:

``` yaml
project:
  type: meridianlabs-ai/inspect-docs

inspect-docs:
  title: "Package Title"
  description: "Package Description"
  url: https://example.com/mypackage
  repo: myorg/mypackage
  org: My Org
```

All `inspect-docs:` fields are optional; see [Options](#options) below for the full list.

### Dependencies

Inspect Docs requires Quarto \>= 1.7 plus a handful of Python packages. Add them to your `dev` dependencies:

``` toml
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
    "griffe>=2",
    "pyyaml",
    "types-PyYAML",
    "rich",
    "quarto-cli>=1.7",
]
```

Then install them:

``` bash
uv sync
```

### Preview

By default, Inspect Docs will symlink to any `README.md` and `CHANGELOG.md` in the root of your repo and create a site based on their contents. Preview it with:

``` bash
cd docs
quarto preview
```

## Articles

Articles are `.qmd` files you list under `navigation` in `_quarto.yml`. A simple navigation block looks like this:

``` yaml
inspect-docs:
  navigation:
    - text: Getting Started
      href: index.qmd
    - text: Guides
      contents:
        - text: Installation
          href: guides/install.qmd
```

Simple items become navbar links and sidebar entries. Items with `contents` become dropdowns and sidebar sections. See [Articles](./articles.html.md) for additional documentation on authoring and navigation.

## Reference

Create a `.qmd` file in a `reference/` directory, set a `reference:` field to the Python import path the page documents, and add H3 headings for each symbol:

``` markdown
---
title: Async Helpers
reference: my_package.aio
---

### run_async
### gather
```

Each H3 is replaced with the full signature, docstring, parameters, attributes, and a link to the source on GitHub — generated via [griffe](https://mkdocstrings.github.io/griffe/). The `reference:` field is required (pages without it are ignored) and tells Inspect Docs which module’s symbols to look up. Docstrings must be [Google-style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings). See [Reference](./reference.html.md) for a more in-depth guide.

## Interlinks

Inline code references to documented symbols are automatically linked to their reference pages on every page in the site:

``` markdown
See `MyClass` and `my_function()` for details.
```

`` `MyClass` `` (starts uppercase) links to the class’s reference page; `` `my_function()` `` (trailing `()`) links to the function’s reference page.

When `external_refs` is configured, inline code also resolves against other Inspect Docs sites. See [Interlinks](./interlinks.html.md) to learn more.

## llms.txt

Every site includes an auto-generated [`llms.txt`](https://llmstxt.org) at the root and per-page Markdown sources at `{page}.html.md`. A **Copy page** button in the page header lets readers grab the Markdown or open it in a new tab. See [llms.txt](./llms.html.md) for details.

## Options

Options available under `inspect-docs:` in `_quarto.yml`:

| Field | Description |
|----|----|
| `title` | Site title. Auto-extracted from the index page H1 if omitted. |
| `description` | Site description. Used for OpenGraph/Twitter cards and the `llms.txt` header. |
| `image` | Social card image (path or URL) embedded in OpenGraph/Twitter card metadata. |
| `logo` | Navbar logo image (path or URL). |
| `favicon` | Site favicon (path or URL). |
| `url` | Canonical site URL. Used when generating absolute links in `llms.txt`. |
| `repo` | GitHub repo as `org/repo`. Enables the navbar GitHub icon and source links on reference pages. |
| `org` | Organization name. Adds a left-side footer link. |
| `org_url` | Custom URL for the org footer link. Defaults to `https://github.com/{org}`. |
| `twitter` | Twitter/X handle (without `@`). Adds a Twitter icon to the footer right. |
| `module` | Python import name. Auto-discovered from `pyproject.toml`; set explicitly only when the import name differs from the distribution name. |
| `cli` | CLI binary name (for Click command pages). Auto-discovered from `pyproject.toml`’s `[project.scripts]`; set explicitly when the binary name differs from the module name. |
| `navigation` | Navbar and sidebar entries (see [Articles](./articles.html.md)). |
| `sidebar` | Sidebar mode: `true` (default when `navigation` is set) shows the main sidebar alongside a separate reference sidebar; `false` suppresses the main sidebar; `unified` merges the reference sidebar into the main sidebar. |
| `external_refs` | Map of `package_name: docs_url` for cross-package interlinking (see [Interlinks](./interlinks.html.md)). |

### Custom Navbar

The extension builds `website.navbar.left` from `inspect-docs.navigation` and `website.navbar.right` from `repo` + `CHANGELOG.md` detection. If you want finer control — for example, a flat top-level navbar with no dropdowns — you can provide `website.navbar.left` (or `right`) directly in `_quarto.yml`. When the extension sees a user-provided `left`, it skips its own generation (including the auto-appended “Reference” link, which you can add manually). The sidebar continues to auto-generate from `inspect-docs.navigation` either way.
