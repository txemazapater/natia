# NATIA — Roadmap

## Filosofía del roadmap

NATIA se desarrolla en pruebas arquitectónicas pequeñas. Cada fase deja el proyecto más claro, medible y fácil de extender.

Prioridad vigente: **lenguaje de dominio + Core desacoplado + foundation alineada**, no «demostrar chat cuanto antes». Un modelo conversation-first sería incompatible con [ADR-0001](adr/0001-workspace-first-architecture.md), [ADR-0003](adr/0003-core-domain-refinement.md) y [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md).

Vocabulario de producto (post–ADR-0004):

- **Initiative** — raíz del trabajo intelectual;
- **Workspace** — memoria operativa 1:1;
- **NEMO** — característica de continuidad explicativa;
- **WorkspaceRuntime** vs **Cognitive Runtime** — no confundir;
- **Capability / Resource** — qué vs cómo.

## Estado de las fases

| Fase | Nombre | Estado |
|------|--------|--------|
| 0.1 | Modelo de dominio | Completada |
| 0.2 | Revisión crítica y consolidación arquitectónica | Completada |
| 0.3 | Core ejecutable en memoria | Completada |
| — | Foundation + ADR-0004 (reconciliación documental) | Completada (2026-07-22) |
| 0.4 | NATIA Studio (shell nativo) | **Parcial** — Sprint 0 embrión visual; integración Core pendiente |
| TBD | Initiative en el Core | **Pendiente de decisión de fase** |
| 0.5 | Persistencia operacional y exportación | Pendiente |
| 0.6 | Primer proveedor de IA | Pendiente |
| 0.7 | Conversaciones reales en producto | Pendiente |
| 0.8 | Recursos y conectores reales | Pendiente |
| 0.9 | MCP y herramientas | Pendiente |
| 1.0 | Primera versión pública | Pendiente |

Detalle Core 0.3: [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).  
Foundation: [`docs/foundation/`](foundation/00_FOUNDATION.MD).

---

## Fase 0.1 — Modelo de dominio

### Objetivo

Definir el lenguaje interno del producto antes de escribir código de UI o infraestructura.

### Entregables

- visión, principios, manifiesto;
- arquitectura inicial;
- ADR-0001 (anti-conversation-first / Workspace como continuidad);
- primer modelo de dominio y ADR-0002 (histórico).

### Criterios de salida

Vocabulario compartido inicial: Workspace, Runtime, Knowledge, Conversation, recursos, eventos.

**Estado:** completada. *(El vocabulario se refinó después con foundation + ADR-0004.)*

---

## Fase 0.2 — Revisión crítica y consolidación arquitectónica

### Objetivo

Intentar romper el modelo, corregir decisiones prematuras y eliminar contradicciones documentales.

### Entregables

- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md);
- [ADR-0003](adr/0003-core-domain-refinement.md);
- DOMAIN-MODEL, ARCHITECTURE y ROADMAP alineados al Core;
- alcance formal de la Fase 0.3.

**Estado:** completada.

---

## Fase 0.3 — Core ejecutable en memoria

### Objetivo

Core ejecutable y verificable **en memoria** que demuestre el lenguaje de dominio consolidado (Workspace-centric en código).

### Entregables

Ver [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).

Resumen: domain / application / contracts; Workspace, WorkspaceRuntime (N, RuntimeId), bindings, Conversation, Knowledge (Fact/Decision/Scratch); Fact Events; exporter in-memory; 21 tests Win32/Win64.

### Restricciones

Sin GUI, SQLite, MCP, providers reales, Docker, Git, plugins, HTTP real. **Sin entidad Initiative** (aún).

**Estado:** completada. Ver [PHASE-0.3-IMPLEMENTATION-NOTES.md](PHASE-0.3-IMPLEMENTATION-NOTES.md).

---

## Foundation y ADR-0004 — Reconciliación documental

### Objetivo

Alinear el Core y la documentación de producto con el modelo fundacional (Initiative, Cognitive Runtime, NEMO, Capability Graph) sin reescribir aún el código 0.3.

### Entregables

- `docs/foundation/` (00–07, 99);
- [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md) Accepted;
- propagación de vocabulario a README, DOMAIN-MODEL, ARCHITECTURE, ROADMAP.

### Criterios de salida

Un desarrollador puede leer foundation + ADR-0004 + DOMAIN-MODEL y saber qué está en código y qué es deuda (Initiative).

**Estado:** completada a nivel documental (2026-07-22).

---

## Fase 0.4 — NATIA Studio (shell nativo)

### Objetivo

Demostrar la experiencia de escritorio nativa sin contaminar el Core.

**NATIA Studio** es el nombre del cliente de referencia (Windows · Delphi · VCL). El concepto arquitectónico del entorno sigue siendo el **Desktop** ([04_DESKTOP.MD](foundation/04_DESKTOP.MD)); Studio es el producto que lo implementa. El Sprint 0 es su **embrión visual**.

### Entregables

| Entrega | Estado |
|---------|--------|
| Ejecutable nativo Windows (Delphi/VCL) — `NatiaStudio` | Sí (Sprint 0) |
| Shell visual 5 zonas + módulos mock (Home, Chat, NEMO, …) | Sí (Sprint 0) |
| Datos simulados; sin HTTP/IA/persistencia real | Sí |
| Ruta de código `src/apps/studio/Delphi/` | Sí |
| Consumo real del Core / fachada de dominio | Pendiente |
| Ajustes de aplicación, logging, diagnósticos medidos | Pendiente |
| Navegación Initiative-centric (más allá del mock IDE) | Pendiente |

### Criterios de salida (fase completa)

Arranque rápido, cierre predecible, idle razonable; dominio testeable sin GUI; Studio consume Core sin duplicar reglas.

**Estado:** parcial (embrión visual listo).

---

## TBD — Initiative en el Core

### Objetivo

Introducir la entidad `Initiative` (1:1 con Workspace) en dominio, contratos, aplicación y tests, sin romper el perímetro mental de ADR-0003.

### Notas

- **No tiene número de fase fijo aún.** Se decidirá tras alinear expectativas de producto (¿antes del store 0.5?, ¿junto al shell real?, ¿después de persistencia?).
- Criterio mínimo esperado: `InitiativeId`, repositorio o fábrica, creación Initiative→Workspace, partición estable, tests verdes, envelope de eventos preparado para `initiativeId` opcional.
- NEMO **no** se convierte en entidad en esta fase: sigue siendo característica del Workspace.

---

## Fase 0.5 — Persistencia operacional y exportación

### Objetivo

Sustituir la memoria por la fuente operativa de verdad y demostrar exportación documental.

### Entregables

- store operacional (candidato: SQLite);
- journal de Fact Events;
- recuperación tras apagado anormal;
- `IWorkspaceExporter` a disco;
- backup/restore; **sin** dual-write permanente.

### Criterios de salida

Un Workspace (y, si ya existiera Initiative, su par) sobrevive al reinicio; export/import redondo; secretos nunca en claro.

---

## Fase 0.6 — Primer proveedor de IA

### Objetivo

Conectar un Resource de modelo (API estilo OpenAI) sin acoplar el Workspace al vendor.

### Entregables

Registro de Providers; `SecretReference`; chat + streaming + cancelación; errores normalizados; diagnósticos con redacción.

### Criterios de salida

Configurar endpoint, elegir modelo, stream y cancelar sin congelar la UI.

---

## Fase 0.7 — Conversaciones reales en producto

### Objetivo

Conversaciones del dominio usables a diario en NATIA Studio.

### Entregables

CRUD en Studio; historial perezoso; metadatos provider/model; Markdown; export; promoción a Knowledge (apoyo a NEMO).

### Criterios de salida

Usables sin cuenta remota obligatoria; journal **sin** un Fact Event por mensaje.

---

## Fase 0.8 — Recursos y conectores reales

### Objetivo

Adapters reales bajo activation perezosa (`EnsureConnected`).

### Criterios de salida

Abrir Workspace no arranca el mundo; conectar es explícito; fallos no tiran el proceso UI.

---

## Fase 0.9 — MCP y herramientas

### Objetivo

Consumir ecosistemas de herramientas abiertos sin hacer de MCP la arquitectura interna (MCP = Resource, no Capability Graph completo).

### Criterios de salida

Al menos un MCP externo usable sin comprometer el proceso principal.

---

## Fase 1.0 — Primera versión pública

### Objetivo

Cognitive workspace nativo estable para uso diario.

### Cualidades requeridas

- arranque medible;
- Initiative + Workspace usables (Initiative en Core ya resuelta);
- continuidad NEMO comprensible;
- store + export;
- provider local y remoto;
- conversaciones y knowledge;
- tools/MCP supervisados;
- documentación de seguridad, backup y migración;
- instalador / portable.

---

## Direcciones post-1.0

Sujeto a evidencia: Cognitive Runtime más rico, Capability Graph dinámico, RAG local, terminal/Git, workers remotos / SAPIENS, colaboración, sync, clientes alternativos (Lazarus), marketplace tras protocolo de extensión estable.

## Funcionalidades deliberadamente aplazadas

Entrenamiento de modelos, runtime de modelos propio, autonomía irrestricta, IDE embebido en navegador, cuenta cloud propietaria obligatoria, paridad UI multiplataforma completa, estándares nuevos sin necesidad demostrada.

## Definición de progreso

Una fase no está completa porque exista código. Está completa cuando:

- el comportamiento es predecible;
- los fallos son visibles;
- el uso de recursos está medido cuando aplica;
- la documentación coincide con la realidad;
- los datos del usuario pueden recuperarse (desde 0.5);
- la arquitectura permanece más simple que la tentación de sobreingeniería.
