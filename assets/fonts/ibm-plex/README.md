# IBM Plex (NATIA Studio)

Selected typefaces for the NATIA visual language.

| Family | Role in NATIA |
|--------|----------------|
| **IBM Plex Sans** | General UI typography |
| **IBM Plex Mono** | Code, logs, paths, commands, identifiers, technical data |

- **License:** SIL Open Font License 1.1 — see [`licenses/fonts/ibm-plex/OFL-1.1.txt`](../../../licenses/fonts/ibm-plex/OFL-1.1.txt)
- **Upstream:** https://github.com/IBM/plex
- **Reserved Font Name:** “Plex” (see OFL)

## Artifact locations (not yet populated)

Place original font files here when incorporating the release:

```text
assets/fonts/ibm-plex/sans/   ← IBM Plex Sans (OTF/TTF/WOFF2 as chosen)
assets/fonts/ibm-plex/mono/   ← IBM Plex Mono (OTF/TTF/WOFF2 as chosen)
```

Until then, each subdirectory contains a `PLACEHOLDER.md` marker only.

## Application rules

- Load fonts **privately** inside NATIA Studio (embed / private font resources).
- Do **not** install fonts globally on the host operating system as part of the product install.
- Do not rename the font family in a way that violates the OFL Reserved Font Name rules.

See also: [`docs/design/typography.md`](../../../docs/design/typography.md).
