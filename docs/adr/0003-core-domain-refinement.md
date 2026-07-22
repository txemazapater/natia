# ADR-0003: Refinamiento del dominio y perímetro mínimo del Core

- Estado: Accepted
- Fecha: 2026-07-20
- Reemplaza parcialmente: [ADR-0002](0002-workspace-domain-model.md)
- Origen: [DOMAIN-MODEL-REVIEW.md](../DOMAIN-MODEL-REVIEW.md)
- Nota 2026-07-22: el término bare *Runtime* queda desambiguado por [ADR-0004](0004-foundation-reconciliation-and-nemo.md). Este ADR describe solo **WorkspaceRuntime** (instancia de ejecución). El **Cognitive Runtime** es el bucle fundacional, no este tipo.

## Contexto

[ADR-0002](0002-workspace-domain-model.md) propuso el modelo de dominio Workspace-first. La [revisión crítica](../DOMAIN-MODEL-REVIEW.md) confirmó la tesis central, pero demostró que varias decisiones derivadas eran prematuras o peligrosas:

- cardinalidad Workspace–Runtime incorrectamente descrita como 1:1;
- Runtime sin identificador propio;
- readiness sobreespecificado;
- archivos JSON/Markdown como fuente operativa de verdad;
- demasiados tipos de recurso y activación eager;
- journal de dominio mezclado con señales y mensajes;
- ausencia de memoria operativa entre chat crudo y conocimiento curado;
- sobreingeniería de repositorios y carpetas del Core.

Se requiere un ADR que conserve lo válido de ADR-0002, corrija lo incorrecto y fije el perímetro de la Fase 0.3.

## Relación con ADR-0002

ADR-0002 pasa a estado **Superseded**.

No se borra ni se reescribe su historia: documenta el primer intento de formalización. ADR-0003 **acepta su tesis central** y **reemplaza sus decisiones operativas** donde conflictúan.

Tesis central conservada:

- el Workspace es la entidad primaria del producto;
- conversación ≠ conocimiento;
- declaración de recursos ≠ conexión viva;
- Runtime efímero separado del modelo persistente;
- no event sourcing completo en v1;
- el dominio precede a chat, proveedores y persistencia concreta.

## Decisión

### 1. Workspace y WorkspaceRuntime

- **`Workspace`**: identidad persistente y ámbito lógico del proyecto.
- **`WorkspaceRuntime`**: ejecución concreta de un Workspace. Siempre tiene **`RuntimeId`**.
- Cardinalidad conceptual:

```text
Workspace 1 ───── N WorkspaceRuntime
```

La primera versión del producto puede limitar a un Runtime local activo por Workspace. Eso es **restricción de producto**, no invariante de dominio. El código del Core no debe modelar un singleton implícito.

No se introduce entidad `Host` ahora. En el futuro un Runtime podrá asociarse a un host, nodo o instancia de aplicación.

### 2. Estados del Runtime (readiness)

Modelo mínimo:

```text
Inactive
Activating
Ready
Degraded
Failed
```

Excluidos de la primera implementación: `Suspended`, `Damaged`, `Loading`, `Stopping`, `Unloaded`.

- Si el Runtime no existe, no hay estado `Unloaded`.
- `Damaged` pertenece a errores de carga/persistencia, no al readiness.
- `Suspended` carece de semántica suficiente.

**`Ready` no significa que todos los recursos externos estén conectados.** Significa que NATIA puede operar con el Workspace (definición cargada, Runtime usable). Las conexiones se gestionan aparte.

### 3. Persistencia

Se **revoca** la decisión de ADR-0002 que hacía del árbol JSON/Markdown la fuente operativa de verdad.

Principio vinculante:

> NATIA tendrá una única fuente operativa de verdad, transaccional y recuperable.

SQLite es el candidato principal para esa fuente, pero **no se implementa todavía**.

JSON, Markdown y JSONL son formatos obligatorios de:

- exportación;
- backup;
- inspección;
- portabilidad;
- posible versionado.

No existirá dual-write permanente entre archivos y base de datos.

```text
Store operativo
    ├── consultas y transacciones
    ├── journal de Fact Events
    └── exportación documental bajo demanda
```

El layout concreto de archivos de exportación **no se fija** en este ADR.

### 4. Vocabulario de recursos

| Término | Significado |
|---------|-------------|
| **Binding** | Declaración persistente de que un Workspace necesita o prefiere un recurso |
| **Adapter** | Código capaz de hablar una tecnología o protocolo |
| **Connection** | Sesión viva creada por un Adapter durante un Runtime |
| **Provider** | Adapter especializado en modelos de IA, registrado a nivel de aplicación |
| **SecretReference** | Referencia opaca a una credencial fuera del Workspace |

No usar como sinónimos: Driver, Instance, Service (salvo necesidad demostrada).

`Credential` **no** es un tipo de recurso. Las credenciales solo existen vía `SecretReference`.

Tipos de binding para Fase 0.3:

```text
FileLocation
GenericEndpoint
```

Preferencia de modelo en el Workspace: `providerId` + `modelId` (strings opacos). El endpoint, secretos y configuración del Provider viven en la configuración de aplicación/máquina, no embebidos en el Workspace.

Los bindings son **colección dentro del agregado Workspace**. No existe `IResourceBindingRepository`.

### 5. Activación perezosa

```text
Abrir Workspace
    → Cargar definición
    → Crear WorkspaceRuntime (RuntimeId)
    → Evaluar configuración mínima
    → Ready | Failed
```

Las conexiones externas se crean bajo demanda:

```text
EnsureConnected(bindingId)
```

Un binding obligatorio puede bloquear una operación que lo necesite; **no** debe impedir necesariamente la apertura del Workspace.

Modo futuro documentado, no implementado: `StartFullEnvironment`.

### 6. Eventos — tres destinos

| Destino | Persistencia | Ejemplos |
|---------|--------------|----------|
| **Fact Events** | Journal de dominio; auditables; exportables; potencialmente sincronizables | WorkspaceCreated, BindingAdded, KnowledgeAccepted, ConversationCreated |
| **Session Events** | Log/telemetría de sesión; no historial semántico permanente por defecto | RuntimeActivationCompleted, ConnectionEstablished, ConnectionLost |
| **Signal Events** | UI / streaming / IPC; nunca journal por defecto | TokenReceived, ToolProgress, StreamingChunk, WorkerHeartbeat |

Se elimina `DomainEventRecorded`.

No se emite un Fact Event por cada mensaje de conversación.

### 7. Event Envelope (shape mínimo)

Para eventos persistibles (Fact Events):

```text
eventId
workspaceId
runtimeId?          # opcional
eventType
occurredAt
actor
correlationId?      # opcional
causationId?        # opcional
schemaVersion
payload
```

Sin sync, reintentos ni bus distribuido en este ADR.

### 8. Conversación, conocimiento y memoria operativa

```text
Conversation   → historial de interacción (crudo)
KnowledgeEntry → conocimiento curado / memoria tipada
Context        → vista ensamblada para una operación (no entidad primaria)
Scratch        → memoria operativa durable (trabajo en curso)
```

**Opción adoptada para Fase 0.3:** `KnowledgeEntry(kind = Scratch)`.

Scratch representa: trabajo en curso, resumen de sesión, hipótesis, próximos pasos, estado operativo durable.

**No puede pasar a `Accepted` sin cambiar antes su kind** a `Fact` o `Decision`.

Puede evolucionar a entidad `WorkingNote` independiente en el futuro.

### 9. KnowledgeEntry

Kinds iniciales: `Fact` | `Decision` | `Scratch`.

Estados: `Draft` | `Accepted` | `Rejected` | `Superseded`.

Procedencias: `Authored` | `Imported` | `PromotedFromConversation` | `DerivedFromTool` | `ImportedFromRepository`.

`Decision` exige estructura propia (sigue dentro de KnowledgeEntry):

```text
context
decision
alternatives
rationale
consequences
supersedes?
externalReference?
```

No se crea agregado `Decision` separado.

### 10. Agregados y contratos del Core (Fase 0.3)

- Workspace contiene bindings.
- Conversation es agregado independiente.
- KnowledgeEntry se direcciona de forma independiente (knowledge base del Workspace).
- Event Journal **no** es un agregado DDD; es infraestructura de registro.

Contratos:

```text
IWorkspaceRepository
IConversationRepository
IKnowledgeRepository
IEventJournal
IResourceConnector
IWorkspaceExporter
```

No existen: `IResourceBindingRepository`, `IWorkspaceCatalog`.

`IWorkspaceExporter` es un puerto; la primera implementación produce representación en memoria/string, **sin filesystem**.

### 11. Perímetro del Core

El Core contiene únicamente:

```text
domain
application
contracts
```

El Core **no** contiene: SQLite, filesystem, UI, proveedores concretos, MCP, Docker, Git, secretos resueltos, procesos externos, projections, workers, authority completa, identity rica.

### 12. ROADMAP

El orden de entrega se realinea: dominio → revisión → Core en memoria → shell → persistencia operacional → proveedor → conversaciones reales → recursos → MCP. Ver [ROADMAP.md](../ROADMAP.md) y [PHASE-0.3-EXECUTABLE-CORE.md](../PHASE-0.3-EXECUTABLE-CORE.md).

## Consequences

### Positivas

- Dos implementadores pueden construir el mismo Core en memoria sin reinterpretar el dominio.
- Se evita congelar dual-write y activation eager.
- El journal permanece útil a escala.
- Queda espacio para hosts remotos y N runtimes sin romper el modelo.

### Costes y riesgos

- SQLite sigue sin elegir esquema concreto (deliberado).
- Scratch como kind puede resultar insuficiente y exigir `WorkingNote` después.
- La restricción de producto «un Runtime activo» debe documentarse en la UI para no filtrarse al dominio.
- ADR-0001 aún menciona un «Workspace Engine» amplio; debe leerse a la luz de este ADR (casos de uso de aplicación, no objeto dios).

## Alternatives considered

### Aceptar ADR-0002 sin cambios

Rechazada. Congelaría persistencia documental como OLTP y readiness/kinds prematuros.

### «Accepted with amendments» sobre ADR-0002

Rechazada. El formato ADR del proyecto usa **Superseded**. Una enmienda dispersa dificulta saber qué sigue vigente. ADR-0003 es el documento operativo; ADR-0002 queda como historia.

### Introducir Host ahora

Rechazada. Sin caso de uso implementable; basta RuntimeId + cardinalidad N.

### WorkingNote como entidad separada en 0.3

Rechazada temporalmente. Aumenta superficie sin evidencia. Scratch basta; se documenta la evolución.

### Mantener archivos canónicos + SQLite índice

Rechazada. Dual-write e integridad débil (OBS-07/08 de la revisión).

## Decisiones deliberadamente abiertas

- Esquema SQLite y migraciones.
- Layout de exportación documental.
- Política de retención de Session Events.
- Entidad Host / ejecución en SAPIENS.
- Sync multiusuario y conflictos entre Knowledge.
- ContextSnapshot de auditoría para agentes.
- `StartFullEnvironment`.
- Separación futura Scratch → WorkingNote.
- IPC concreto entre procesos.

## References

- [DOMAIN-MODEL.md](../DOMAIN-MODEL.md)
- [DOMAIN-MODEL-REVIEW.md](../DOMAIN-MODEL-REVIEW.md)
- [PHASE-0.3-EXECUTABLE-CORE.md](../PHASE-0.3-EXECUTABLE-CORE.md)
- [ADR-0001](0001-workspace-first-architecture.md)
- [ADR-0002](0002-workspace-domain-model.md) (Superseded)
