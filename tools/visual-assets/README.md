# Visual assets tooling

## Build Phosphor index

Generates `assets/icons/phosphor/index.json` for the Visual Asset Registry.

```bat
python tools\visual-assets\build-phosphor-index.py
```

Requirements: Python 3.10+.

The index maps logical icon names to relative SVG paths for weights `regular`, `duotone`, `fill`, and `bold`. Filenames like `robot-duotone.svg` are normalized to the logical name `robot`.
