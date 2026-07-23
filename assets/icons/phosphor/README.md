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

## Artifact locations

Full SVG sets (curated for Studio consumption; prefer subsetting in the client if needed):

```text
assets/icons/phosphor/
├── regular/     ← everyday actions / navigation
├── duotone/     ← agents, tools, memory, context, entities
├── fill/        ← active / selected
├── bold/        ← alerts / critical
├── README.md
└── manifest.json
```

Thin / Light weights are intentionally not imported (discouraged at small sizes).

See also: [`docs/design/iconography.md`](../../../docs/design/iconography.md).
