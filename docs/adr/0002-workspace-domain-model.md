# ADR-0002: Workspace domain model

- Status: Proposed
- Date: 2026-07-20

## Context

[ADR-0001](0001-workspace-first-architecture.md) establece que el Workspace es la entidad primaria de NATIA, pero no define el modelo de dominio concreto: agregados, ciclo de vida, persistencia ni límites entre conocimiento, conversación y estado operativo.

El [ROADMAP](../ROADMAP.md) actual introduce Workspaces en la Fase 0.6, después de conversaciones persistidas (Fase 0.3), lo que contradice la intención workspace-first y arriesga un modelo de datos centrado en el chat.

Se requiere un diseño de dominio antes de escribir código del Core.

## Decision

### 1. Dos entidades de ciclo de vida: Workspace y WorkspaceRuntime

- **`Workspace`** es el agregado persistente: identidad, configuración, bindings declarativos, conocimiento, conversaciones y partición del journal de eventos.
- **`WorkspaceRuntime`** es el contexto efímero de ejecución: activación, readiness, conexiones vivas y supervisión. No se persiste.

Abrir un proyecto = cargar `Workspace` + crear `WorkspaceRuntime` + ejecutar activación.

### 2. Raíz lógica única, agregados múltiples

`WorkspaceId` particiona todos los datos. Los agregados `ResourceBinding`, `KnowledgeEntry`, `Conversation` y `EventRecord` tienen consistencia acotada e independiente para permitir crecimiento sin cargar el Workspace entero en memoria.

### 3. Recursos: declaración vs conexión

El dominio modela `ResourceBinding` (declaración tipada por `ResourceKind`). Las conexiones vivas son responsabilidad de infraestructura y runtime.

### 4. Memoria: conversación ≠ conocimiento

- `Conversation` almacena interacción cruda.
- `KnowledgeEntry` almacena hechos curados (incluidas `Decision`).
- La promoción de conversación a conocimiento es explícita y auditada.
- `Context` es una vista ensamblada, no una entidad persistente.

### 5. Estado en dos ejes

- `LifecycleStatus` (administrativo, en Workspace): Draft, Active, Archived, Deleted.
- `ReadinessStatus` (operativo, en WorkspaceRuntime): Unloaded, Activating, Ready, Degraded, Suspended, Stopped, Failed, Damaged.

### 6. Persistencia canónica exportable

La fuente de verdad es un árbol de archivos JSON/Markdown por Workspace. SQLite, cuando se introduzca, será un índice derivado reconstruible.

### 7. Eventos: journal + repositorios, no event sourcing completo

Registro append-only de eventos de dominio para auditoría y proyecciones. Estado actual en repositorios convencionales.

### 8. Reordenar el ROADMAP

El esqueleto de dominio y persistencia del Workspace debe preceder a la primera conversación persistida. La UI nativa puede avanzar en paralelo, pero el modelo de datos no debe asumir `Conversation` como raíz.

## Consequences

### Positive

- El Core tiene un lenguaje estable para crecer diez años sin reescritura fundamental.
- Conversaciones, proveedores y herramientas se integran como dependencias del Workspace.
- Exportabilidad y local-first quedan modelados desde el origen.
- Tests del dominio sin GUI, SQLite, MCP ni proveedores.

### Costs and risks

- Más diseño upfront antes de la primera demo «útil» de chat.
- Disciplina requerida para no promover conversaciones a conocimiento automáticamente.
- Dos conceptos de estado exigen documentación clara para contribuidores.
- El journal de eventos necesitará política de retención.

## Alternatives considered

### Conversation as aggregate root

Rejected. Encaja con clientes de chat pero fuerza reconstrucción de contexto y refactorización cuando el Workspace crece.

### Single monolithic Workspace aggregate

Rejected. No escala con volumen de mensajes y eventos; viola principios de rendimiento.

### Full event sourcing

Rejected for v1. Coste de complejidad y replay alto para conversaciones; puede aplicarse parcialmente al journal más adelante.

### WorkspaceService as domain entity

Rejected. Los servicios son runtime/infraestructura; el dominio declara bindings.

### Keep ROADMAP order (workspaces at 0.6)

Rejected. Contradice ADR-0001 y acumula deuda de modelo de datos.

## References

- [DOMAIN-MODEL.md](../DOMAIN-MODEL.md) — diseño completo
- [ADR-0001](0001-workspace-first-architecture.md)
