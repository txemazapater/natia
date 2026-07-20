# NATIA — Modelo de dominio del Core

- **Estado:** Vigente (alineado con [ADR-0003](adr/0003-core-domain-refinement.md))
- **Fecha de consolidación:** 2026-07-20
- **Alcance:** Diseño conceptual del dominio. La implementación comienza en la [Fase 0.3](PHASE-0.3-EXECUTABLE-CORE.md).

---

## Resumen ejecutivo

NATIA no es un cliente de chat. Es un **Workspace persistente** que conserva la continuidad de un proyecto a lo largo del tiempo. Las conversaciones, las herramientas, los proveedores de IA y los servicios externos son **vistas y dependencias** sobre ese Workspace, no su sustituto.

**Decisiones centrales:**

1. El Workspace es la raíz lógica del producto.
2. Un Workspace puede tener **N** ejecuciones (`WorkspaceRuntime`), cada una con `RuntimeId`.
3. Conversación ≠ conocimiento ≠ memoria operativa (Scratch) ≠ contexto ensamblado.
4. Binding (declaración) ≠ Connection (sesión viva) ≠ Adapter/Provider (código).
5. Una única fuente operativa de verdad (transaccional); la representación documental es exportación.
6. Activation perezosa: abrir no implica conectar todos los recursos.
7. Solo Fact Events viven en el journal de dominio.

---

## Cambios posteriores a la revisión crítica

Este documento incorpora las correcciones de:

- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md) — revisión crítica (Fase 0.2)
- [ADR-0003](adr/0003-core-domain-refinement.md) — refinamiento vinculante

[ADR-0002](adr/0002-workspace-domain-model.md) queda como **Superseded** (historia). Su tesis central se conserva; sus decisiones operativas conflictivas se reemplazan aquí y en ADR-0003.

Correcciones principales respecto al borrador inicial:

| Antes (ADR-0002 / borrador) | Ahora (ADR-0003) |
|-----------------------------|------------------|
| Workspace ↔ Runtime 1:1 | 1:N; RuntimeId obligatorio |
| Ready = todo conectado | Ready = Workspace operable; conexiones aparte |
| JSON/MD canónico, SQLite índice | Store operacional canónico; export documental |
| 11 ResourceKinds; Credential kind | FileLocation, GenericEndpoint; solo SecretReference |
| Activation conecta todo | EnsureConnected bajo demanda |
| Journal mezcla mensajes y señales | Solo Fact Events; Session/Signal aparte |
| Sin memoria operativa | Scratch (kind de KnowledgeEntry) |
| IResourceBindingRepository | Bindings dentro de Workspace |
| EventRecord como «agregado» | Event Journal = infraestructura |

---

## 1. ¿Qué es realmente un Workspace?

### Qué representa

Un **Workspace** es el **contenedor persistente de continuidad** de un proyecto o línea de trabajo recurrente. Representa:

- **Identidad del proyecto:** nombre, propósito, etiquetas, estado administrativo.
- **Intención operativa:** instrucciones, preferencias (incl. `providerId` / `modelId` opacos).
- **Bindings:** qué recursos declara necesitar (`FileLocation`, `GenericEndpoint`, …).
- **Conocimiento tipado:** Fact, Decision, Scratch.
- **Historial de interacción:** conversaciones (agregado separado, particionado por WorkspaceId).
- **Historial de hechos:** Fact Events en el journal (infraestructura).

Metáfora: el Workspace es el **expediente vivo del proyecto**, no la mesa de trabajo efímera.

### Qué NO debe contener

| Excluido | Dónde vive |
|----------|------------|
| Estado de UI | Shell |
| Connections vivas, sockets, procesos | WorkspaceRuntime + Adapters |
| Secretos en claro | Credential store del SO vía SecretReference |
| Buffers de streaming | Signal Events / workers |
| Contexto ensamblado para un prompt | Servicio de aplicación (vista) |
| Endpoints y claves de Provider | Configuración de aplicación/máquina |
| Inferencias no curadas como hechos Accepted | Solo Draft / Scratch |

### Responsabilidades

**Del Workspace (dominio persistente):** identidad, definición, bindings, políticas declarativas mínimas, partición lógica de knowledge/conversations/events.

**Del WorkspaceRuntime:** ciclo de vida de una ejecución, readiness, Connections creadas en esa ejecución.

**De la aplicación:** casos de uso (activar, promover conocimiento, EnsureConnected, exportar).

**De la infraestructura:** store operacional, journal, connectors reales (fuera de Fase 0.3), credential store.

---

## 2. Entidad raíz y Runtime

### Workspace vs WorkspaceRuntime

| | Workspace | WorkspaceRuntime |
|---|-----------|------------------|
| Naturaleza | Persistente | Efímero |
| Identidad | `WorkspaceId` | `RuntimeId` (obligatorio) |
| Cardinalidad | 1 | N por Workspace |
| Contiene | Definición, bindings, lifecycle admin | Readiness, Connections de esa ejecución |

```text
Workspace 1 ───── N WorkspaceRuntime
```

Abrir un proyecto:

1. Cargar Workspace desde el store (vía repositorio).
2. Crear `WorkspaceRuntime` con nuevo `RuntimeId`.
3. Evaluar configuración mínima → `Ready` o `Failed`.
4. Emitir Session Events de activación (no Fact Events, salvo política futura explícita).

**Restricción de producto v1 (no del dominio):** la UI puede permitir un solo Runtime local activo por Workspace. El Core debe soportar N en pruebas.

**Host:** no es entidad ahora. Un Runtime podrá asociarse en el futuro a un host/nodo/instancia.

### Agregados y partición

| Concepto | Tratamiento | Justificación |
|----------|-------------|---------------|
| Workspace (+ bindings) | Agregado | Bindings son pocos; consistencia con la definición |
| Conversation (+ messages) | Agregado | Volumen alto; append-only |
| KnowledgeEntry | Entradas direccionables de la knowledge base | Persistencia independiente por entrada |
| Event Journal | Infraestructura append-only | No es agregado DDD |

Todos comparten `WorkspaceId` como clave de partición. Consistencia fuerte dentro de cada límite; eventual entre límites vía Fact Events cuando aplique.

---

## 3. Entidades del perímetro mínimo

| Entidad | Fase 0.3 | Notas |
|---------|----------|-------|
| `Workspace` | Sí | Incluye colección de bindings |
| `WorkspaceRuntime` | Sí | Con RuntimeId; no persistido |
| `Binding` | Sí | Embebido en Workspace |
| `Conversation` / `Message` | Sí | Agregado propio |
| `KnowledgeEntry` | Sí | Kinds Fact, Decision, Scratch |
| Fact Event / Envelope | Sí | Journal |
| `AuthorityPolicy` / `Identity` ricos | No | Fuera de 0.3 |
| Host, Milestone, Task, Snapshot | No | Futuro |

---

## 4. Recursos

### Vocabulario oficial

- **Binding** — declaración persistente en el Workspace.
- **Adapter** — código que habla un protocolo/tecnología.
- **Connection** — sesión viva en un Runtime.
- **Provider** — Adapter de modelos de IA a nivel de aplicación.
- **SecretReference** — referencia opaca; nunca secreto en el Workspace.

No usar Driver / Instance / Service como sinónimos salvo necesidad demostrada.

### Binding (estructura)

```text
Binding
├── id
├── kind: FileLocation | GenericEndpoint   # ampliables después
├── role                                    # ej. "workspace-files", "docs"
├── displayName
├── declaration                             # payload tipado por kind
├── required: boolean
├── secretRefs: SecretReference[]           # opcional; sin valores
└── metadata
```

Credenciales **no** son un kind. Providers de modelo **no** se embeben como endpoint en el Workspace: solo `providerId` + `modelId` en preferencias.

### Activación perezosa

```text
Abrir Workspace → cargar → crear Runtime → Ready|Failed
EnsureConnected(bindingId) → Connection | error
```

`required` bloquea operaciones que necesiten el recurso; no obliga a conectar al abrir.

Futuro (no 0.3): `StartFullEnvironment`.

---

## 5. Estado

### LifecycleStatus (Workspace, persistente)

```text
Draft → Active → Archived
```

(`Deleted` lógico puede añadirse después.)

### ReadinessStatus (Runtime, efímero)

```text
Inactive
Activating
Ready
Degraded
Failed
```

- **Ready:** el Workspace es operable en este Runtime. **No** implica Connections abiertas.
- **Degraded:** operable con alguna Connection fallida o recurso opcional indisponible.
- **Failed:** no se puede usar el Runtime (p.ej. definición inválida).

Errores de corrupción al cargar el Workspace son fallos del repositorio/persistencia, no un estado `Damaged` del Runtime.

---

## 6. Memoria

| Concepto | Qué es | Persistencia |
|----------|--------|--------------|
| **Conversation** | Transcripción humano↔IA (y similares) | Sí |
| **KnowledgeEntry Fact** | Hecho curado | Sí |
| **KnowledgeEntry Decision** | Decisión con estructura obligatoria | Sí |
| **KnowledgeEntry Scratch** | Memoria operativa durable | Sí |
| **Context** | Paquete ensamblado para una operación | No (salvo depuración futura / ContextSnapshot) |
| **Memoria** | Objetivo del producto, no una tabla | — |

### Scratch (memoria operativa)

Trabajo en curso, resúmenes de sesión, hipótesis, próximos pasos. **No puede Accepted** sin cambiar kind a Fact o Decision.

Evolución posible: entidad `WorkingNote` separada.

### KnowledgeEntry

- **Estados:** Draft, Accepted, Rejected, Superseded.
- **Procedencias:** Authored, Imported, PromotedFromConversation, DerivedFromTool, ImportedFromRepository.
- **Decision** requiere: `context`, `decision`, `alternatives`, `rationale`, `consequences`, opcionales `supersedes`, `externalReference`.

Promoción desde conversación crea Draft con procedencia; no es el único origen del conocimiento.

---

## 7. Eventos

### Tres destinos

| Destino | Uso | ¿Journal de dominio? |
|---------|-----|----------------------|
| **Fact Events** | Hechos del proyecto | Sí |
| **Session Events** | Ciclo de vida del Runtime / Connections | No por defecto (log de sesión) |
| **Signal Events** | UI, streaming, IPC | Nunca por defecto |

### Fact Events (ejemplos)

```text
WorkspaceCreated, WorkspaceRenamed, WorkspaceArchived
BindingAdded, BindingRemoved
KnowledgeAccepted, DecisionRecorded
ConversationCreated, ConversationArchived
```

### Session Events (ejemplos)

```text
RuntimeActivationStarted, RuntimeActivationCompleted, RuntimeActivationFailed
ConnectionEstablished, ConnectionLost
```

### Signal Events (ejemplos)

```text
TokenReceived, ToolProgress, StreamingChunk, WorkerHeartbeat
```

No: `DomainEventRecorded`. No: un Fact Event por mensaje.

### Envelope (Fact Events)

```text
eventId
workspaceId
runtimeId?
eventType
occurredAt
actor
correlationId?
causationId?
schemaVersion
payload
```

---

## 8. Persistencia

### Principio

Una **única fuente operativa de verdad**, transaccional y recuperable. Candidato futuro: SQLite. **No implementada en Fase 0.3** (solo memoria).

Exportación documental (JSON / Markdown / JSONL) obligatoria bajo demanda: backup, inspección, portabilidad. Sin dual-write permanente.

```text
Store operativo → consultas / transacciones / journal
                → IWorkspaceExporter (artefacto documental)
```

Layout de archivos de export: **no fijado**.

### Contratos

```text
IWorkspaceRepository
IConversationRepository
IKnowledgeRepository
IEventJournal
IResourceConnector
IWorkspaceExporter
```

### Qué persiste (cuando exista store)

Definición Workspace + bindings, Knowledge, Conversations/Messages, Fact Events, preferencias no secretas.

### Qué nunca persiste

Connections, secretos resueltos, Signal Events, buffers, UI, contexto ensamblado ordinario, inferencias no curadas como Accepted.

---

## 9. Arquitectura del Core (perímetro)

```text
src/core/
├── domain/         # Workspace, Runtime, Conversation, Knowledge, event types
├── application/    # casos de uso: create/activate, EnsureConnected, promote, export
└── contracts/      # repositorios, connector, journal, exporter
```

Sin `projections/`, `services/` genérico, `workers/`, `authority/`, `identity/` ricos en Fase 0.3.

Infraestructura (SQLite, filesystem, UI, providers, MCP) **fuera** de `core/`.

---

## Diagrama

```text
                 ┌──────────────────────┐
                 │      Workspace       │
                 │  (+ Bindings)        │
                 └──────────┬───────────┘
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌─────────────────┐
│ Conversation  │  │ KnowledgeEntry│  │  Event Journal  │
│ (+ Messages)  │  │ Fact/Dec/Scr  │  │  (Fact Events)  │
└───────────────┘  └───────────────┘  └─────────────────┘

                 ┌──────────────────────┐
                 │  WorkspaceRuntime    │
                 │  RuntimeId           │
                 │  Readiness           │
                 │  Connections[]       │
                 └──────────┬───────────┘
                            │ EnsureConnected
                            ▼
                 ┌──────────────────────┐
                 │ Adapter / Connector  │
                 └──────────────────────┘
```

---

## Puntos abiertos (deliberados)

1. Esquema SQLite y migraciones.
2. Layout de exportación.
3. Retención de Session Events.
4. Host / SAPIENS / Runtime remoto.
5. Sync y conflictos entre Knowledge.
6. ContextSnapshot de auditoría.
7. `StartFullEnvironment`.
8. Scratch → WorkingNote.
9. IPC entre procesos.

---

## Referencias

- [ADR-0001](adr/0001-workspace-first-architecture.md) — Workspace-first (Accepted)
- [ADR-0002](adr/0002-workspace-domain-model.md) — primer modelo (Superseded)
- [ADR-0003](adr/0003-core-domain-refinement.md) — refinamiento vigente (Accepted)
- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md)
- [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [ROADMAP.md](ROADMAP.md)
