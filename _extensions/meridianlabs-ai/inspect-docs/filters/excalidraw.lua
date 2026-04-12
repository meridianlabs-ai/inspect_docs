-- Rewrite .excalidraw image references to their pre-generated SVG files.
--
-- Usage in markdown:
--   ![caption](path/to/diagram.excalidraw)
--
-- The pre-render script converts .excalidraw files to SVG before Quarto
-- starts watching, so this filter only needs to rewrite image src paths.

function Image(el)
  if not el.src:match("%.excalidraw$") then
    return nil
  end

  el.src = el.src .. ".svg"

  -- Remove excalidraw-specific attributes so they don't pass through to HTML
  el.attributes["theme"] = nil
  el.attributes["background"] = nil
  el.attributes["padding"] = nil
  el.attributes["scale"] = nil

  return el
end
