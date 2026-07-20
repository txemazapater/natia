# NATIA — Fase 0.3: Core ejecutable en memoria

- **Estado:** Completada
- **Fecha:** 2026-07-20
- **Dependencias:** [DOMAIN-MODEL.md](DOMAIN-MODEL.md), [ARCHITECTURE.md](ARCHITECTURE.md), [ROADMAP.md](ROADMAP.md)
- **Implementación:** [PHASE-0.3-IMPLEMENTATION-NOTES.md](PHASE-0.3-IMPLEMENTATION-NOTES.md)

---

## Objetivo

> Construir un Core ejecutable y verificable completamente en memoria que demuestre el lenguaje de dominio consolidado.

Al terminar esta fase, dos implementaciones independientes del Core deberían ser conceptualmente compatibles si siguen este documento y ADR-0003.

---

## Restricciones absolutas

**Prohibido** en Fase 0.3:

- GUI / VCL / FMX
- SQLite u otro store en disco
- Filesystem como persistencia o export a disco
- MCP, Docker, Git, plugins
- Proveedores reales (OpenAI, Ollama, HTTP real)
- Secretos reales / DPAPI
- Procesos externos
- Sincronización, multiusuario, agentes autónomos

**Permitido:**

- Código de dominio, application y contracts
- Repositorios, journal, connectors y exporter **in-memory**
- Pruebas unitarias / de aceptación que ejecuten el Core

---

## Estructura

```text
src/core/
  domain/
  application/
  contracts/
tests/core/
```

Sin carpetas `projections/`, `services/` genérico, `workers/`, `authority/`, `identity/` ricos.

---

## Alcance funcional

### Workspace

- Crear, renombrar, pasar a Active, archivar.
- `LifecycleStatus`: Draft | Active | Archived.
- Definición: nombre, instrucciones, preferencias `providerId` / `modelId` (opacos, opcionales).
- Añadir y eliminar **bindings** embebidos (`FileLocation`, `GenericEndpoint`).
- Persistencia vía `IWorkspaceRepository` in-memory.

### WorkspaceRuntime

- Crear con **`RuntimeId`** nuevo.
- Activar → Inactive → Activating → Ready | Failed.
- `EnsureConnected` puede llevar a Degraded sin destruir el Runtime.
- Detener (fin de vida del Runtime).
- **Varios Runtime** para el mismo `WorkspaceId` deben ser posibles en tests.
- No se persiste.

### Recursos

- `IResourceConnector` in-memory.
- Simular: conectar con éxito, fallar, degradar.
- API: `EnsureConnected(bindingId)`.
- Activation del Workspace **no** conecta bindings automáticamente.
- Sin Connections reales.

### Conversation

- Crear bajo un Workspace.
- Append de mensajes.
- Archivar.
- Carga perezosa **conceptual**: activar Workspace no carga todos los mensajes.
- No emitir Fact Event por mensaje.

### Knowledge

- Crear `Fact`, `Decision`, `Scratch`.
- Estados: Draft | Accepted | Rejected | Superseded.
- Procedencias: Authored | Imported | PromotedFromConversation | DerivedFromTool | ImportedFromRepository.
- Promover mensaje → Knowledge Draft con procedencia completa.
- Scratch **no** puede Accepted sin cambiar kind a Fact o Decision.
- Decision exige al menos: `context`, `decision`, `rationale` (y campos de estructura según DOMAIN-MODEL; `alternatives` / `consequences` pueden ser listas vacías explícitas si aún no hay contenido, pero el shape debe existir).

### Eventos

- **Fact Events** → `IEventJournal` in-memory con **Event Envelope**.
- **Session Events** → canal o lista separada / log de prueba (no journal de dominio).
- **Signal Events** → fuera del journal (ni siquiera necesarios en 0.3 salvo que un test demuestre exclusión).

Fact Events mínimos a emitir cuando corresponda:

```text
WorkspaceCreated, WorkspaceRenamed, WorkspaceArchived
BindingAdded, BindingRemoved
ConversationCreated, ConversationArchived
KnowledgeAccepted (y/o DecisionRecorded según diseño interno coherente)
```

### Exportación

- Puerto `IWorkspaceExporter`.
- Salida: string o estructura en memoria.
- Debe poder representar un Workspace (definición, bindings, knowledge, conversaciones según política de export mínima) **sin** conocer SQLite ni filesystem.

---

## Contratos

```text
IWorkspaceRepository
IConversationRepository
IKnowledgeRepository
IEventJournal
IResourceConnector
IWorkspaceExporter
```

No implementar: `IResourceBindingRepository`, `IWorkspaceCatalog`.

---

## Pruebas de aceptación (obligatorias)

1. Crear un Workspace y recuperarlo desde un repositorio en memoria.
2. Dos Runtime distintos pueden existir para el mismo `WorkspaceId`.
3. Activar un Workspace **sin** conectar automáticamente sus bindings.
4. `EnsureConnected` puede conectar, fallar, degradar el Runtime y dejar usable el resto del Workspace.
5. Añadir 10.000 mensajes **no** genera 10.000 Fact Events.
6. Promover un mensaje crea un KnowledgeEntry Draft con procedencia completa.
7. Un Scratch no puede aceptarse sin convertirse antes en Fact o Decision.
8. Una Decision exige `context`, `decision` y `rationale` (rechazo de dominio si faltan).
9. El journal contiene Fact Events y **no** Signal Events.
10. El exportador representa un Workspace sin SQLite ni filesystem.
11. Ningún test depende de VCL, FMX, SQLite, HTTP real, OpenAI, Ollama, MCP, Docker o Git.

---

## Criterios de salida

- Suite de aceptación en verde.
- Código del Core sin referencias a UI ni infra prohibida.
- Terminología alineada con DOMAIN-MODEL y ADR-0003.
- Un puerto claro para sustituir in-memory por SQLite en Fase 0.5 sin cambiar reglas de dominio.

## Fuera de alcance

Shell nativo, persistencia real, streaming de modelos, AuthorityPolicy completa, consolidación automática de memoria, Host, sync, MCP.
