# Third-party visual assets

NATIA / NATIA Studio uses selected open-licensed visual resources. This page is the legal and operational summary for contributors.

## Registry

Machine-readable catalogue: [`metadata/third-party-assets.json`](../../metadata/third-party-assets.json).

Human notices at repository root:

- [`THIRD_PARTY_NOTICES.md`](../../THIRD_PARTY_NOTICES.md)
- [`NOTICE.md`](../../NOTICE.md)

Full license texts: [`licenses/`](../../licenses/).

## Included assets

### IBM Plex Sans & IBM Plex Mono

- **License:** SIL Open Font License 1.1
- **Copy:** [`licenses/fonts/ibm-plex/OFL-1.1.txt`](../../licenses/fonts/ibm-plex/OFL-1.1.txt)
- **Source:** https://github.com/IBM/plex
- **Artifacts:** `assets/fonts/ibm-plex/sans/`, `assets/fonts/ibm-plex/mono/` (TTF imported)
- **Notes:** Reserved Font Name “Plex”. Fonts must be loaded privately in-app; not installed globally.

### Phosphor Icons

- **License:** MIT
- **Copy:** [`licenses/icons/phosphor/MIT.txt`](../../licenses/icons/phosphor/MIT.txt)
- **Source:** https://github.com/phosphor-icons/core
- **Artifacts:** `assets/icons/phosphor/{regular,duotone,fill,bold}/` (SVG imported; ~1512 per weight)
- **Notes:** Prefer SVG components over icon fonts. Thin/Light not imported.

## NATIA license

The project’s own license is the root [`LICENSE`](../../LICENSE) file (MIT). Third-party terms apply **in addition** to NATIA’s license for the corresponding artifacts; they do not replace it.

## Historical note

Earlier Sprint 0 experiments briefly vendored DevExpress toolbar imagery. Those assets have been **removed** from the repository in favour of IBM Plex + Phosphor.
