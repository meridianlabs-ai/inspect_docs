# Reference

Reference pages document your package’s public API. Place `.qmd` files in a `reference/` directory and Inspect Docs auto-discovers them, builds a reference sidebar, and generates a cross-reference index. H3 headings on each page are replaced with full API documentation generated from your Python source.

Every reference page must declare its binding via a frontmatter `reference:` field — the Python import path (for API pages) or CLI command path (for CLI pages) that the page documents. Pages without a `reference:` field are ignored. Filenames are not used for matching, so you can name the files however you like.

## Python API

A reference page documents a single module. Set `reference:` to that module’s import path, then add H2 headings for organizational sections (rendered as-is) and H3 headings for each symbol:

``` markdown
---
title: Async Helpers
reference: my_package.aio
---

## Coroutines

### run_async
### gather

## Utilities

### shield
```

The H3 headings above resolve to `my_package.aio.run_async`, `my_package.aio.gather`, and `my_package.aio.shield`. Each is replaced with the full function or class documentation: signature, docstring, parameters, attributes, methods, and a “source” link pointing at your repo on GitHub.

A page documenting the project’s main module sets `reference:` to that module name:

``` markdown
---
title: Scanner API
reference: my_package
---

### Scanner
### scanner_decorator
```

The H3 headings here resolve to `my_package.Scanner` and `my_package.scanner_decorator`.

### Title defaulting

Page title precedence:

1.  Frontmatter `title:` if present.
2.  Else, the value of `reference:` (which is convenient for single-module pages — `reference: my_package.utils` becomes the displayed title with no extra typing).
3.  Else, Quarto’s normal title behavior (first H1 / filename).

### Docstring conventions

Docstrings must be written in [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings):

``` python
def run_task(name: str, *, timeout: float = 30.0) -> TaskResult:
    """Run a task by name.

    Args:
        name: The registered task name.
        timeout: Maximum seconds to wait before cancelling.

    Returns:
        The result of the task, or a cancellation marker if it timed out.

    Raises:
        TaskNotFoundError: If no task is registered under `name`.
    """
```

If a symbol has no docstring, Inspect Docs emits a warning during the render and skips that entry.

## CLI Commands

For packages that expose a [Click](https://click.palletsprojects.com/) CLI, reference pages bind to a command via the same `reference:` field:

``` markdown
---
reference: my_package run
---
```

The page displays as `my_package run` (title defaulted from `reference:`) and is populated with usage, description, options, and subcommands derived from the Click command at `my_package._cli.run`.

A page is treated as a CLI command page when its `reference:` value starts with `<cli>` (binary name + space) or equals `<cli>` exactly. Otherwise it’s an API page.

### CLI binary name

Inspect Docs needs to know your CLI binary name to recognize CLI pages. By default it’s auto-discovered from `pyproject.toml`’s `[project.scripts]` table — preferring an entry whose value references `{module}._cli`. If that doesn’t pick the right one, set it explicitly in `_quarto.yml`:

``` yaml
inspect-docs:
  module: my_package
  cli: my-binary    # only needed if it differs from the module name
```

The CLI binary name is independent of the Python module name. For example, a package named `inspect_scout` whose `pyproject.toml` exposes a `scout` script would set (or auto-discover) `cli: scout`, and CLI pages would use `reference: scout <command>`.

## Inline Reference

You can embed API reference documentation on any article page (i.e. outside `reference/`) by using the `reference` attribute on a heading:

``` markdown
---
title: Getting Started
reference: my_package
---

## Key functions

### My Function {reference="my_function"}

Some additional context about this function…

### My Class {reference="MyClass"}
```

The page-level `reference:` field declares the binding (same field as on reference pages). On article pages outside `reference/`, only headings with an explicit `{reference="..."}` attribute become symbols; plain H3s remain plain headings.

## Reference Index

A `reference/index.qmd` is automatically generated from the discovered reference pages. It groups API pages and CLI command pages into separate tables, each row showing the page title and its `description` field.
