# NATIA — Modelo de dominio del Core

- **Estado:** Vigente (alineado con [ADR-0003](adr/0003-core-domain-refinement.md) y [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md))
- **Última alineación documental:** 2026-07-22
- **Alcance:** Diseño conceptual del dominio. El Core ejecutable actual es la [Fase 0.3](PHASE-0.3-EXECUTABLE-CORE.md).

---

## Resumen ejecutivo

NATIA no es un cliente de chat. Es un **cognitive workspace** organizado alrededor de **Initiatives**.

Jerarquía conceptual ([foundation](foundation/01_MODEL.MD), [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md)):

```text
Person → Intention → Initiative → Workspace → Context / Knowledge / …
```

| Concepto | Rol |
|----------|-----|
| **Initiative** | Raíz del producto: cuerpo coherente de trabajo intelectual en el tiempo. |
| **Workspace** | Estado vivo y memoria operativa de **exactamente una** Initiative. |
| **Conversation** | Superficie / evidencia; no es la raíz. |
| **NEMO** | Característica nombrada del Workspace: continuidad explicativa (*cómo hemos llegado aquí*). No es agregado ni producto. |
| **Capability** | Capacidad abstracta (qué). |
| **Resource** | Implementación reemplazable (cómo). |

**Decisiones centrales del Core (ADR-0003, siguen vigentes):**

1. Un Workspace puede tener **N** ejecuciones (`WorkspaceRuntime`), cada una con `RuntimeId`.
2. Conversación ≠ conocimiento ≠ Scratch ≠ contexto ensamblado.
3. Binding ≠ Connection ≠ Adapter/Provider.
4. Una única fuente operativa de verdad; la representación documental es exportación.
5. Activation perezosa: abrir no implica conectar todos los recursos.
6. Solo Fact Events viven en el journal de dominio.

**Deuda explícita:** el código de la Fase 0.3 modela `Workspace` sin entidad `Initiative`. La introducción de Initiative en el Core es una **decisión de fase pendiente**; hasta entonces el Workspace actúa como raíz *implementada*, subordinada conceptualmente a Initiative.

---

## Vocabulario: dos «Runtime»

| Término | Significado |
|---------|-------------|
| **WorkspaceRuntime** | Instancia de ejecución del Workspace (`RuntimeId`, readiness). Tipo del Core. |
| **Cognitive Runtime** | Bucle Observe → Understand → Contextualize → Reason → Plan → Act → Learn. Comportamiento fundacional; **no** es un agregado del Core 0.3. |

Prohibido usar *Runtime* sin calificador en documentos de arquitectura ([ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md)).

---

## Cambios posteriores a la revisión crítica

Este documento incorpora:

- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md) — revisión crítica (Fase 0.2)
- [ADR-0003](adr/0003-core-domain-refinement.md) — refinamiento del Core
- [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md) — reconciliación con `docs/foundation/`

[ADR-0002](adr/0002-workspace-domain-model.md) permanece **Superseded**. [ADR-0001](adr/0001-workspace-first-architecture.md) permanece Accepted en la tesis anti-chat; la raíz del producto es Initiative (ADR-0004).

| Antes | Ahora |
|-------|-------|
| Workspace = raíz del producto | Initiative = raíz; Workspace = memoria 1:1 |
| «Runtime» ambiguo | WorkspaceRuntime vs Cognitive Runtime |
| NEMO implícito / módulo UI | NEMO = característica de continuidad explicativa |
| Workspace ↔ Runtime 1:1 (borrador) | Workspace 1:N WorkspaceRuntime; RuntimeId obligatorio |
| Ready = todo conectado | Ready = Workspace operable; conexiones aparte |
| JSON/MD canónico | Store operacional canónico; export documental |
| Sin memoria operativa tipada | Scratch (kind de KnowledgeEntry) |

---

## 0. Initiative (conceptual; aún no en el perímetro 0.3)

Una **Initiative** representa un cuerpo de trabajo perseguido en el tiempo (p. ej. «Desarrollar NATIA Desktop», «Diseñar un appliance de monitorización»).

- Posee **exactamente un** Workspace.
- Agrupa objetivos, sesiones y la evolución del conocimiento.
- El Desktop debe navegar por Initiatives ([04_DESKTOP.MD](foundation/04_DESKTOP.MD)).

**En el Core actual:** no hay tipo `Initiative`. Los repositorios parten de `WorkspaceId`. Cuando se decida la fase de introducción, el mapeo previsto es:

```text
Initiative 1 ──── 1 Workspace
Workspace 1 ──── N WorkspaceRuntime
```

Sin reescritura destructiva: Initiative envuelve Workspace; los tests 0.3 se adaptan, no se desechan.

---

## 1. ¿Qué es realmente un Workspace?

### Qué representa

Un **Workspace** es el **estado vivo** de una Initiative: contenedor persistente de continuidad operativa. Representa:

- **Identidad operativa** ligada a la Initiative (nombre/propósito pueden vivir en Initiative cuando exista la entidad).
- **Intención operativa:** instrucciones, preferencias (`providerId` / `modelId` opacos).
- **Bindings:** recursos declarados (`FileLocation`, `GenericEndpoint`, …).
- **Conocimiento tipado:** Fact, Decision, Scratch — base de la faceta **NEMO**.
- **Historial de interacción:** conversaciones (agregado separado, particionado por `WorkspaceId`).
- **Historial de hechos:** Fact Events en el journal.

Metáfora: el Workspace es el **expediente vivo** de la Initiative, no la mesa de trabajo efímera ni un directorio Git.

### NEMO (característica, no entidad)

**NEMO** no introduce tablas ni agregados propios. Designa la disciplina y la superficie de producto que enfatizan:

- procedencia del conocimiento;
- camino de decisiones y alternativas descartadas;
- relaciones entre Observation, Decision, Experience y Documentation;
- la pregunta *cómo hemos llegado aquí*.

Las vistas UI «NEMO» navegan Knowledge / timeline del Workspace activo.

### Qué NO debe contener

| Excluido | Dónde vive |
|----------|------------|
| Estado de UI | Shell / Desktop |
| Connections vivas, sockets, procesos | WorkspaceRuntime + Adapters |
| Secretos en claro | Credential store del SO vía SecretReference |
| Buffers de streaming | Signal Events / workers |
| Contexto ensamblado para un prompt | Servicio de aplicación (vista) |
| Endpoints y claves de Provider | Configuración de aplicación/máquina |
| Inferencias no curadas como hechos Accepted | Solo Draft / Scratch |
| Cognitive Runtime como objeto persistente | Casos de uso / orquestación (futuro) |

### Responsabilidades

**Del Workspace (dominio persistente):** identidad operativa, definición, bindings, políticas declarativas mínimas, partición de knowledge/conversations/events.

**Del WorkspaceRuntime:** ciclo de vida de una ejecución, readiness, Connections de esa ejecución.

**De la aplicación:** casos de uso (activar, promover conocimiento, EnsureConnected, exportar); en el futuro, tramos del Cognitive Runtime y Orchestration.

**De la infraestructura:** store operacional, journal, connectors reales (fuera de 0.3), credential store.

---

## 2. Entidad raíz implementada y WorkspaceRuntime

### Workspace vs WorkspaceRuntime

| | Workspace | WorkspaceRuntime |
|---|-----------|------------------|
| Naturaleza | Persistente | Efímero |
| Identidad | `WorkspaceId` | `RuntimeId` (obligatorio) |
| Cardinalidad | 1 por Initiative (cuando exista) | N por Workspace |
| Contiene | Definición, bindings, lifecycle admin | Readiness, Connections de esa ejecución |

```text
Initiative 1 ──── 1 Workspace     (conceptual; Initiative aún no en código)
Workspace  1 ──── N WorkspaceRuntime
```

Abrir trabajo:

1. Resolver Initiative → Workspace (hoy: cargar Workspace directamente).
2. Crear `WorkspaceRuntime` con nuevo `RuntimeId`.
3. Evaluar configuración mínima → `Ready` o `Failed`.
4. Emitir Session Events de activación (no Fact Events, salvo política futura).

**Restricción de producto v1 (no del dominio):** un solo WorkspaceRuntime local activo por Workspace en UI. El Core soporta N en pruebas.

### Agregados y partición

| Concepto | Tratamiento | Justificación |
|----------|-------------|---------------|
| Workspace (+ bindings) | Agregado | Consistencia con la definición |
| Conversation (+ messages) | Agregado | Volumen alto; append-only |
| KnowledgeEntry | Entradas direccionables | Persistencia por entrada |
| Event Journal | Infraestructura append-only | No es agregado DDD |
| Initiative | Pendiente de fase | Contenedor 1:1 previsto |

Todos (hoy) comparten `WorkspaceId` como clave de partición.

---

## 3. Entidades del perímetro mínimo (Fase 0.3)

| Entidad | Fase 0.3 | Notas |
|---------|----------|-------|
| `Workspace` | Sí | Incluye bindings |
| `WorkspaceRuntime` | Sí | Con RuntimeId; no persistido |
| `Binding` | Sí | Embebido en Workspace |
| `Conversation` / `Message` | Sí | Agregado propio |
| `KnowledgeEntry` | Sí | Fact, Decision, Scratch |
| Fact Event / Envelope | Sí | Journal |
| `Initiative` | **No** | Decisión de fase pendiente |
| Cognitive Runtime (tipo) | **No** | Comportamiento futuro |
| `AuthorityPolicy` / `Identity` ricos | No | Fuera de 0.3 |
| Host, Milestone, Task, Snapshot | No | Futuro |

---

## 4. Recursos y Capabilities

### Vocabulario oficial (Core)

- **Binding** — declaración persistente en el Workspace.
- **Adapter** — código que habla un protocolo/tecnología.
- **Connection** — sesión viva en un WorkspaceRuntime.
- **Provider** — Adapter de modelos de IA a nivel de aplicación.
- **SecretReference** — referencia opaca; nunca secreto en el Workspace.

### Vocabulario foundation (complementario)

- **Capability** — habilidad abstracta (Observe, Remember, Analyze, …).
- **Resource** — implementación de una Capability (LLM, agente, API, repo, …).
- **Capability Graph** — red de posibilidades para Orchestration ([07_CAPABILITY_GRAPH.MD](foundation/07_CAPABILITY_GRAPH.MD)).

En el Core 0.3, Provider/Adapter son el puente práctico hacia Resources. El grafo completo no se implementa aún.

### Binding (estructura)

```text
Binding
├── id
├── kind: FileLocation | GenericEndpoint
├── role
├── displayName
├── declaration
├── required: boolean
├── secretRefs: SecretReference[]
└── metadata
```

### Activación perezosa

```text
Abrir Workspace → cargar → crear WorkspaceRuntime → Ready|Failed
EnsureConnected(bindingId) → Connection | error
```

---

## 5. Estado

### LifecycleStatus (Workspace, persistente)

```text
Draft → Active → Archived
```

### ReadinessStatus (WorkspaceRuntime, efímero)

```text
Inactive | Activating | Ready | Degraded | Failed
```

- **Ready:** el Workspace es operable en este WorkspaceRuntime. **No** implica Connections abiertas.
- **Degraded / Failed:** según Connections o definición inválida.

---

## 6. Memoria y NEMO

| Concepto | Qué es | Persistencia |
|----------|--------|--------------|
| **Conversation** | Transcripción humano↔IA | Sí |
| **KnowledgeEntry Fact** | Hecho curado | Sí |
| **KnowledgeEntry Decision** | Decisión estructurada | Sí |
| **KnowledgeEntry Scratch** | Memoria operativa durable | Sí |
| **Context** | Paquete ensamblado para una operación | No (salvo depuración futura) |
| **NEMO** | Faceta / disciplina sobre lo anterior | — (no tabla) |

### Scratch

Trabajo en curso, hipótesis, próximos pasos. **No puede Accepted** sin cambiar kind a Fact o Decision.

### KnowledgeEntry

- **Estados:** Draft, Accepted, Rejected, Superseded.
- **Procedencias:** Authored, Imported, PromotedFromConversation, DerivedFromTool, ImportedFromRepository.
- **Decision** requiere: `context`, `decision`, `alternatives`, `rationale`, `consequences`; opcionales `supersedes`, `externalReference`.

---

## 7. Eventos

| Destino | Uso | ¿Journal de dominio? |
|---------|-----|----------------------|
| **Fact Events** | Hechos del proyecto / Initiative | Sí |
| **Session Events** | Ciclo de vida WorkspaceRuntime / Connections | No por defecto |
| **Signal Events** | UI, streaming, IPC | Nunca por defecto |

Envelope de Fact Events: `eventId`, `workspaceId`, `runtimeId?`, `eventType`, `occurredAt`, `actor`, `correlationId?`, `causationId?`, `schemaVersion`, `payload`.

Cuando exista Initiative: `initiativeId` podrá añadirse al envelope sin romper `workspaceId` como partición operativa.

---

## 8. Persistencia

Una **única fuente operativa de verdad**, transaccional y recuperable. Candidato: SQLite. **No en Fase 0.3** (memoria).

Exportación documental (JSON / Markdown / JSONL) obligatoria bajo demanda. Sin dual-write permanente.

Contratos 0.3:

```text
IWorkspaceRepository
IConversationRepository
IKnowledgeRepository
IEventJournal
IResourceConnector
IWorkspaceExporter
```

Futuro plausible: `IInitiativeRepository` cuando se decida la fase.

---

## 9. Arquitectura del Core (perímetro)

```text
src/core/
├── domain/         # Workspace, WorkspaceRuntime, Conversation, Knowledge, events
├── application/    # create/activate, EnsureConnected, promote, export
└── contracts/      # repositorios, connector, journal, exporter
```

Infraestructura (SQLite, filesystem, UI, providers, MCP) **fuera** de `core/`.

---

## Diagrama

```text
                 ┌──────────────────────┐
                 │     Initiative       │  ← conceptual (aún no en Core 0.3)
                 └──────────┬───────────┘
                            │ 1:1
                 ┌──────────▼───────────┐
                 │      Workspace       │
                 │  (+ Bindings)        │
                 │  faceta NEMO         │
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
                 │ Adapter / Resource   │
                 └──────────────────────┘

  Cognitive Runtime / Orchestration / Capability Graph
  → casos de uso de aplicación (futuro), no tipos 0.3
```

---

## Puntos abiertos (deliberados)

1. **Fase en la que Initiative entra en el Core** (decisión pendiente).
2. Esquema SQLite y migraciones.
3. Layout de exportación.
4. Retención de Session Events.
5. Host / Runtime remoto.
6. Sync y conflictos entre Knowledge.
7. ContextSnapshot de auditoría.
8. `StartFullEnvironment`.
9. Scratch → WorkingNote.
10. Implementación del Cognitive Runtime y Capability Graph.

---

## Referencias

- [foundation/00_FOUNDATION.MD](foundation/00_FOUNDATION.MD) … [99_GLOSSARY.MD](foundation/99_GLOSSARY.MD)
- [ADR-0001](adr/0001-workspace-first-architecture.md) — anti-conversation-first
- [ADR-0003](adr/0003-core-domain-refinement.md) — perímetro Core
- [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md) — reconciliación e Initiative/NEMO
- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md)
- [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [ROADMAP.md](ROADMAP.md)
