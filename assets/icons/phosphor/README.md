# Phosphor Icons (NATIA Studio)

Primary icon system for NATIA Studio.

- **License:** MIT — see [`licenses/icons/phosphor/MIT.txt`](../../../licenses/icons/phosphor/MIT.txt)
- **Upstream:** https://github.com/phosphor-icons/core  
- **Consumption model:** prefer **SVG components / SVG files**, not an icon font.

## Weight usage in NATIA

| Weight | Use |
|--------|-----|
| **Regular** | Everyday actions and navigation |
| **Duotone** | Agents, tools, memory (NEMO), context, primary entities |
| **Fill** | Active / selected states |
| **Bold** | Alerts and critical actions only |
| **Thin / Light** | Avoid at small sizes |

## Artifact locations (not yet populated)

Place selected SVG sets under this tree when incorporating upstream assets, for example:

```text
assets/icons/phosphor/
├── regular/     ← PLACEHOLDER until imported
├── duotone/
├── fill/
├── bold/
├── README.md
└── manifest.json
```

Do **not** commit the entire Phosphor catalogue unless product needs justify it. Prefer a curated subset tracked in `manifest.json`.

See also: [`docs/design/iconography.md`](../../../docs/design/iconography.md).
