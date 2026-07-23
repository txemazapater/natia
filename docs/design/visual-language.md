# Visual language

NATIA Studio aims for a professional, calm, high-information-density interface — closer to an IDE or operational console than to a messaging app.

## Foundations

| Layer | Choice |
|-------|--------|
| UI type | **IBM Plex Sans** |
| Technical type | **IBM Plex Mono** |
| Icons | **Phosphor Icons** (SVG preferred) |
| Themes | Light / Dark / High Contrast (planned; tokens under `assets/themes/`) |

Detail: [typography.md](typography.md), [iconography.md](iconography.md).  
Legal: [../legal/third-party-assets.md](../legal/third-party-assets.md).

## Principles

1. **Clarity over decoration** — avoid saturated “gaming” aesthetics, exaggerated shadows, and noisy chrome.
2. **Attention is scarce** — every surface should reduce cognitive load ([foundation](../foundation/00_FOUNDATION.MD)).
3. **State is multi-channel** — colour must never be the only signal for status (pair with icon weight/shape/label).
4. **Private fonts** — embed or load fonts inside the application; do not install them into the OS font catalogue.
5. **SVG icons as components** — prefer individual SVG assets or generated components over icon fonts.
6. **Initiative-centric chrome** — navigation and density should support recovering mental state, not browsing files alone.

## Asset locations

```text
assets/fonts/ibm-plex/
assets/icons/phosphor/
assets/images/
assets/illustrations/
assets/logos/
assets/themes/
```

Binary fonts and full icon packs are **not** required in the repository until curated subsets are ready; placeholders mark import targets.
