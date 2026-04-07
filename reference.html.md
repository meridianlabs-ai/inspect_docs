# Reference

Reference pages document your package’s public API. Place `.qmd` files in a `reference/` directory and Inspect Docs auto-discovers them, builds a reference sidebar, and generates a cross-reference index. H3 headings on each page are replaced with full API documentation generated from your Python source.

Reference pages follow these filename patterns:

| Pattern                  | Type              | Example                |
|--------------------------|-------------------|------------------------|
| `<module>.qmd`           | API (main module) | `my_package.qmd`       |
| `<module>.<sub>.qmd`     | API (submodule)   | `my_package.utils.qmd` |
| `<module>_<command>.qmd` | CLI command       | `my_package_run.qmd`   |

## Python API

### Module Pages

Create a `.qmd` file whose `title` matches your module name. Use H2 headings for organizational sections (they render as-is) and H3 headings for each symbol to document:

``` markdown
---
title: my_package
description: Core tasks and utilities.
---

## Tasks

### my_function
### MyClass

## Utilities

### helper_function
```

Each H3 heading is replaced with the full function or class documentation: signature, docstring, parameters, attributes, methods, and a “source” link pointing at your repo on GitHub. The H2 headings remain as section separators in the rendered sidebar.

### Submodule Pages

For submodules, use a dotted title:

``` markdown
---
title: my_package.utils
description: Helper functions for working with tasks.
---

### format_output
### parse_input
```

The symbol names under a submodule page are resolved relative to that submodule — so `format_output` above becomes `my_package.utils.format_output`.

### Doc Generation

For each documented symbol, the following is extracted and rendered:

- The full signature (including type annotations and defaults).
- The docstring summary and extended description.
- Parameters, with types and per-parameter descriptions.
- For classes: attributes, methods, and inherited members.
- A “source” link back to the exact file and line in your repo (built from the `repo` field in `_quarto.yml`).

Docstrings must be written in [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings). For example:

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

If a symbol has no docstring, `inspect-docs` emits a warning during the render and skips that entry.

## CLI Commands

For packages that expose a [Click](https://click.palletsprojects.com/) CLI, reference pages for individual commands use the filename convention `<module>_<command>.qmd`:

``` markdown
---
title: my_package run
description: Run a task.
---
```

Given the filename `my_package_run.qmd`, `inspect-docs` loads the Click command from `my_package._cli.run` (attribute `run`) and populates the page with usage, description, options, and subcommands. No body content is needed — the frontmatter is enough.

## Inline Reference

You can embed API reference documentation on any page by using the `reference` attribute on a heading.

First, add a `reference` field to the page’s frontmatter pointing at the module the symbols live in:

``` markdown
---
title: Getting Started
reference: my_package
---
```

Then use the `reference` attribute on any heading:

``` markdown
## Key functions

### My Function {reference="my_function"}

Some additional context about this function…

### My Class {reference="MyClass"}
```

The heading content becomes the display title while the `reference` attribute specifies which Python object to document. Prose between H3s is preserved as-is.

## Reference Index

A `reference/index.qmd` is automatically generated from the discovered reference pages. It groups API pages and CLI command pages into separate tables, each row showing the page title and its `description` field.
