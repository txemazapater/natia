# Typography

## Families

| Family | Role |
|--------|------|
| **IBM Plex Sans** | General interface: labels, menus, body, titles |
| **IBM Plex Mono** | Code, logs, paths, commands, identifiers, technical data |

License: SIL Open Font License 1.1 — [`licenses/fonts/ibm-plex/OFL-1.1.txt`](../../licenses/fonts/ibm-plex/OFL-1.1.txt).  
Upstream: https://github.com/IBM/plex  
Registry: [`metadata/third-party-assets.json`](../../metadata/third-party-assets.json)

## Hierarchy (initial guidance)

- **Sans Regular / Medium** — default UI text.
- **Sans SemiBold / Bold** — section titles and emphasis (sparingly).
- **Mono Regular** — terminal, logs, diffs, IDs, JSON/YAML snippets.
- **Mono Bold** — highlighted technical tokens when needed.

Exact point sizes and line heights will be fixed when theme tokens land in `assets/themes/`.

## Runtime rules

1. Load typefaces **privately** within NATIA Studio (resource embedding / private font API).
2. Do **not** install IBM Plex into the Windows (or other OS) font directory as part of setup.
3. Respect the OFL **Reserved Font Name** “Plex” when redistributing or modifying fonts.
4. Prefer a minimal weight subset in the shipping client to keep download and memory small.

## Artifact status

Font binaries are imported as TTF under:

- `assets/fonts/ibm-plex/sans/` (16 files)
- `assets/fonts/ibm-plex/mono/` (16 files)
