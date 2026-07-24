# Visual Asset Registry (VAR) 0.1

## Purpose

NATIA Studio must request visual capabilities by **logical identifiers**, not filesystem paths:

```text
phosphor://robot/duotone
```

The Visual Asset Registry interprets the id, locates the resource, rasterizes it for VCL, caches the bitmap, and falls back safely when resolution fails.

VAR 0.1 is intentionally small: Phosphor icons only, in-memory cache, no plugins, no binary packs.

## Architecture

Code lives under `src/visual/` (not `src/core/`) so Core remains free of VCL / Winapi dependencies.

| Unit | Role |
|------|------|
| `Natia.Visual.Types` | Request / resolved asset types |
| `Natia.Visual.Provider` | `IVisualAssetProvider` |
| `Natia.Visual.Provider.Phosphor` | `phosphor://` + `index.json` |
| `Natia.Visual.Cache` | In-memory bitmap cache (owns originals) |
| `Natia.Visual.SvgRasterizer` | GDI+ SVG subset → `TBitmap` |
| `Natia.Visual.Registry` | Orchestration, fallback, DPI |
| `Natia.Visual.Bootstrap` | App-level init / shutdown |
| `Natia.Visual.Paths` | Locate `assets/` and repo files |
| `Natia.Visual.Logging` | Minimal log hook |

```text
UI → ResolveIcon(id, size, dpi)
       → cache?
       → provider.ResolveSourcePath
       → SVG rasterize
       → cache put
       → return bitmap copy
```

Ownership: the cache owns stored bitmaps; `TResolvedVisualAsset` delivers a **copy**. The caller frees the resolved object.

## Identifiers (VAR 0.1)

```text
phosphor://<name>/<weight>
```

Weights: `regular`, `duotone`, `fill`, `bold` (`thin` / `light` rejected).

Names are normalized to lowercase. Path traversal (`..`), absolute paths, and extra `/` segments are rejected.

## Requests

```pascal
Resolved := VisualAssets.ResolveIcon('phosphor://robot/duotone', 24, Screen.PixelsPerInch);
try
  Image.Picture.Assign(Resolved.Bitmap);
finally
  Resolved.Free;
end;
```

Physical size: `Round(LogicalSize × DPI / 96)`.

## Phosphor provider & index

Catalog index: `assets/icons/phosphor/index.json`  
Regenerate:

```bat
python tools\visual-assets\build-phosphor-index.py
```

See `tools/visual-assets/README.md`.

Assets root resolution (in order):

1. `NATIA_ASSETS_ROOT` env var
2. `assets` next to the executable
3. Walk up from the exe looking for repo `assets/`

## Cache

Key: `assetId|logicalSize|dpi|state`  
Example: `phosphor://robot/duotone|24|144|normal`

`ClearCache` empties the dictionary. Cache hits are logged at debug level only.

## Fallback

1. Requested id  
2. `phosphor://question/regular`  
3. Drawn emergency “?” bitmap  

`UsedFallback := True` on the result. Failures are logged; Studio must not crash on missing icons.

## Colour / state

Minimal state colours exist (`normal`, `disabled`, `active`, `warning`, `error`). SVG `currentColor` is replaced with a hex colour. Full theming is out of scope for 0.1. Duotone opacity is respected when present; elliptical arcs are approximated.

## NATIA Studio integration

- Init in `MainForm.FormCreate` via `InitVisualAssets` (central bootstrap).
- Nav glyphs (Inicio, Iniciativas, Agentes, Memoria, Herramientas, Ajustes, VAR lab) resolve through VAR.
- Lab frame **Visual Asset Registry** (nav Help / magnifying-glass): gallery from `config/visual/var-demo.json`, weight/size selectors, cache and fallback diagnostics.

## Limitations (0.1)

- No `semantic://` / `module://`
- No downloadable providers or persistent cache
- No hot reload / binary asset packs
- SVG renderer is a Phosphor-oriented GDI+ subset (not a full SVG engine)
- No Skia / DevExpress dependency

## Evolution

Later: semantic aliases, module packages, better SVG (Direct2D/Skia), theme tokens, signed catalogs.
