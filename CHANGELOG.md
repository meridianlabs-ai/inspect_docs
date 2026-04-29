## Unreleased

- Skip griffe step if there is no reference generation in play.
- Cache HTML→Markdown conversion in post-render to skip the per-page `quarto pandoc` subprocess when content is unchanged.                                    
- Cache reference frontmatter and symbol scan in pre-render so unchanged `reference/*.qmd` files are not re-read on every render.                         
- Skip the external-refs network download when the local `refs-{pkg}.json` cache was written within the last 24 hours (delete the file to force a refresh).       
  

## 1.0.4 (14 April 2026)

- Interlinking for pages in sub-directories.

## 1.0.3 (12 April 2026)

- Various improvements.

## 1.0.2 (10 April 2026)

- Only write files that have changed in pre-render.py.

## 1.0.1 (07 April 2026)

- Changes required for Inspect Scout docs migration.

## 1.0.0 (07 April 2026)

- Initial release.

