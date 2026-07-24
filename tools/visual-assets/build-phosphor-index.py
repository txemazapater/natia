#!/usr/bin/env python3
"""Build assets/icons/phosphor/index.json from the imported SVG folders."""

from __future__ import annotations

import json
import sys
from pathlib import Path

WEIGHTS = ("regular", "duotone", "fill", "bold")
SUFFIX = {
    "regular": "",
    "duotone": "-duotone",
    "fill": "-fill",
    "bold": "-bold",
}


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def icon_name_from_file(weight: str, filename: str) -> str | None:
    if not filename.endswith(".svg"):
        return None
    stem = filename[:-4]
    suffix = SUFFIX[weight]
    if suffix:
        if not stem.endswith(suffix):
            return None
        return stem[: -len(suffix)]
    if any(stem.endswith(s) for s in SUFFIX.values() if s):
        return None
    return stem


def build_index(phosphor_root: Path) -> dict:
    icons: dict[str, dict[str, str]] = {}
    missing_reports: list[str] = []

    for weight in WEIGHTS:
        folder = phosphor_root / weight
        if not folder.is_dir():
            raise SystemExit(f"Missing weight folder: {folder}")
        for path in sorted(folder.glob("*.svg")):
            name = icon_name_from_file(weight, path.name)
            if not name:
                continue
            rel = f"{weight}/{path.name}".replace("\\", "/")
            icons.setdefault(name, {})[weight] = rel

    incomplete = 0
    for name in sorted(icons):
        entry = icons[name]
        for weight in WEIGHTS:
            if weight not in entry:
                incomplete += 1
                missing_reports.append(f"{name}: missing {weight}")

    payload = {
        "schemaVersion": 1,
        "provider": "phosphor",
        "weights": list(WEIGHTS),
        "iconCount": len(icons),
        "incompleteCount": incomplete,
        "icons": {name: icons[name] for name in sorted(icons)},
    }
    return payload, missing_reports


def main() -> int:
    root = repo_root()
    phosphor = root / "assets" / "icons" / "phosphor"
    out = phosphor / "index.json"

    payload, missing = build_index(phosphor)
    out.write_text(json.dumps(payload, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")

    print(f"Wrote {out}")
    print(f"Icons: {payload['iconCount']}")
    print(f"Incomplete weight entries: {payload['incompleteCount']}")
    if missing[:20]:
        print("Sample missing weights:")
        for line in missing[:20]:
            print(f"  {line}")
    # Incomplete weights are informational (some icons may lack a weight); not fatal.
    return 0


if __name__ == "__main__":
    sys.exit(main())
