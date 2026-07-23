# Iconography

## System

**Phosphor Icons** is the primary icon set for NATIA Studio.

- License: MIT — [`licenses/icons/phosphor/MIT.txt`](../../licenses/icons/phosphor/MIT.txt)
- Upstream: https://github.com/phosphor-icons/core · https://phosphoricons.com/
- Manifest: [`assets/icons/phosphor/manifest.json`](../../assets/icons/phosphor/manifest.json)

## Weight roles

| Weight | When to use |
|--------|-------------|
| **Regular** | Everyday actions and navigation |
| **Duotone** | Agents, tools, memory (NEMO), context, primary entities |
| **Fill** | Active or selected states |
| **Bold** | Alerts and critical actions |
| **Thin / Light** | Avoid at small sizes (legibility) |

## Rules

1. Prefer **SVG components / SVG files**, not an icon font.
2. Curate a subset; do not ship the entire Phosphor catalogue by default.
3. Colour must not be the only means of communicating state — combine with weight (e.g. Fill), shape, or text.
4. Keep hit targets and optical sizes consistent across the Studio chrome.
5. Map domain concepts deliberately (e.g. NEMO, Initiative, Capability) to stable Duotone icons once the curated set exists.

## Artifact status

SVG weight sets are imported:

```text
assets/icons/phosphor/regular/   (1512)
assets/icons/phosphor/duotone/   (1512)
assets/icons/phosphor/fill/      (1512)
assets/icons/phosphor/bold/      (1512)
```

Update `manifest.json` if a curated product subset is tracked explicitly.
