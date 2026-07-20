# NATIA — Modelo de dominio del Core (Fase 0.1)

- **Estado:** Propuesto
- **Fecha:** 2026-07-20
- **Alcance:** Diseño conceptual. Sin implementación.

---

## Resumen ejecutivo

NATIA no es un cliente de chat. Es un **Workspace persistente** que conserva la continuidad de un proyecto a lo largo del tiempo. Las conversaciones, las herramientas, los proveedores de IA y los servicios externos son **vistas y dependencias** sobre ese Workspace, no su sustituto.

Este documento define el lenguaje interno del Core: entidades fundamentales, límites de responsabilidad, eventos, persistencia y estructura de módulos. Está alineado con [ADR-0001](adr/0001-workspace-first-architecture.md) y cuestiona explícitamente varios puntos del [ROADMAP](ROADMAP.md) y de [ARCHITECTURE](ARCHITECTURE.md) donde la intención arquitectónica y el orden de entrega divergen.

**Decisión central:** el Workspace es la raíz lógica del dominio, pero no un monolito en memoria. Se divide en un agregado persistente (`Workspace`) y un contexto de ejecución efímero (`WorkspaceRuntime`) coordinado por una capa de aplicación.

---

## Contradicciones detectadas en la documentación actual

### 1. Workspace-first vs orden del ROADMAP

| Fuente | Afirmación |
|--------|------------|
| ADR-0001, MANIFESTO, visión del usuario | El Workspace es la entidad primaria. Abrir un proyecto es *arrancar* un entorno operativo. |
| ROADMAP Fase 0.3 | Conversaciones y persistencia SQLite antes que Workspaces. |
| ROADMAP Fase 0.6 | Workspaces aparecen tarde, como evolución de chats aislados. |

**Riesgo:** implementar el modelo de datos alrededor de `Conversation` como raíz y refactorizar seis meses después.

**Propuesta:** reordenar el ROADMAP (ver [ADR-0002](adr/0002-workspace-domain-model.md)). El esqueleto de dominio y persistencia del Workspace debe existir antes de la primera conversación persistida. La UI puede seguir siendo mínima.

### 2. «Session manager» sin definición

[ARCHITECTURE.md](ARCHITECTURE.md) menciona un `session manager` en el Core sin distinguir:

- sesión de aplicación (instancia NATIA abierta);
- sesión de Workspace (periodo en que un Workspace está cargado);
- sesión de conversación o de agente.

**Riesgo:** mezclar estado de UI, estado operativo y estado persistente bajo el mismo nombre.

**Propuesta:** eliminar el término ambiguo. Usar `ApplicationShell`, `WorkspaceRuntime` y `Conversation` con responsabilidades explícitas.

### 3. Workspace como contenedor vs Workspace como motor

ADR-0001 introduce un «Workspace Engine» con siete responsabilidades (consolidación de memoria, síntesis de estado, ingestión de actividad…). [ARCHITECTURE.md](ARCHITECTURE.md) describe el Workspace como un grupo de configuración (instrucciones, carpetas, herramientas…).

**Riesgo:** convertir `Workspace` en un objeto dios que hace de PM tool, IDE, RAG engine y chat host.

**Propuesta:** el dominio modela **qué es** y **qué posee** un proyecto. La síntesis de estado, consolidación de memoria y orquestación de arranque pertenecen a servicios de aplicación que operan *sobre* el dominio, no dentro del agregado persistente.

### 4. Colisión de nombres «Fase 0.1»

El ROADMAP define Fase 0.1 como *Native shell*. Esta fase de diseño (dominio del Core) es distinta.

**Propuesta:** renombrar en el ROADMAP a «Fase 0.1 — Native shell» → «Fase 0.1a» o renumerar: Fase 0.1 = Dominio del Core, Fase 0.2 = Native shell.

### 5. SQLite como única representación

[PRINCIPLES.md](PRINCIPLES.md) exige exportabilidad y advierte contra bases opacas como única representación. [ARCHITECTURE.md](ARCHITECTURE.md) propone SQLite como candidato principal sin definir el modelo canónico exportable.

**Propuesta:** el modelo canónico es documental (JSON/Markdown en disco). SQLite es un índice derivado, no la fuente de verdad semántica.

---

## 1. ¿Qué es realmente un Workspace?

### Qué representa

Un **Workspace** es el **contenedor persistente de continuidad** de un proyecto o línea de trabajo recurrente. Representa:

- **Identidad del proyecto:** nombre, propósito, etiquetas, estado administrativo (activo, archivado).
- **Intención operativa:** instrucciones, preferencias, políticas de aprobación (referencias, no ejecución).
- **Vinculaciones declarativas:** qué recursos externos necesita el proyecto (repos, carpetas, proveedores, MCP, credenciales por referencia).
- **Conocimiento curado:** decisiones, hechos consolidados, referencias a documentación.
- **Historial de interacción:** conversaciones como artefactos consultables.
- **Registro de actividad:** qué ocurrió, cuándo y con qué autoridad (eventos append-only).

Metáfora: un Workspace es el **expediente vivo del proyecto**, no la mesa de trabajo donde se está trabajando ahora mismo.

### Qué NO debe contener

| Excluido | Motivo | Dónde vive |
|----------|--------|------------|
| Hilos de UI, selección de panel, scroll | Presentación | Shell (UI) |
| Conexiones vivas (sockets, pipes, procesos) | Efímero, no serializable | `WorkspaceRuntime` + infraestructura |
| Secretos en texto plano | Seguridad | Credential store del SO |
| Buffers de streaming del modelo | Transitorio | Workers / runtime |
| Contexto ensamblado para un prompt | Derivado, recalculable | Servicio de contexto (aplicación) |
| Estado de salud en tiempo real de cada servicio | Volátil | `WorkspaceRuntime` + eventos |
| Código fuente, documentos externos | Fuente externa | Referenciados, no embebidos por defecto |
| Inferencias del modelo sobre el estado del proyecto | No verificadas | Prohibido como hecho; solo como borrador de conocimiento |

### Responsabilidades del Workspace (dominio)

- Garantizar identidad estable y portabilidad de la definición no secreta.
- Mantener vinculaciones declarativas a recursos.
- Almacenar conocimiento curado y conversaciones como artefactos propios.
- Registrar eventos de dominio de forma append-only.
- Exponer políticas y preferencias que otros componentes deben respetar.

### Responsabilidades que pertenecen a otros componentes

| Componente | Responsabilidad |
|------------|-----------------|
| `WorkspaceRuntime` | Arranque, parada, suspensión; conexión real a recursos; supervisión de workers |
| Shell (UI) | Presentación, aprobaciones interactivas, navegación |
| Provider adapters | Comunicación con modelos |
| Tool / extension hosts | Ejecución aislada |
| Servicios de aplicación | Consolidación de memoria, síntesis de «dónde está el proyecto», ensamblado de contexto |
| Infraestructura | SQLite, filesystem, IPC, credential store |

---

## 2. Entidad raíz

### Pregunta: ¿qué objeto representa un proyecto abierto en NATIA?

Hay **dos nociones** que no deben confundirse:

1. **`Workspace`** (persistente): el proyecto como entidad de negocio, existe aunque NATIA esté cerrado.
2. **`WorkspaceRuntime`** (efímero): el proyecto *en ejecución* dentro de una instancia de NATIA.

Cuando el usuario «abre un proyecto», la aplicación:

1. Carga el `Workspace` desde persistencia.
2. Crea un `WorkspaceRuntime` asociado.
3. Ejecuta el protocolo de activación (verificar recursos, restaurar contexto operativo).
4. Emite eventos de ciclo de vida.

`WorkspaceRuntime` es lo que el usuario experimenta como «proyecto abierto». `Workspace` es lo que sobrevive al cierre.

### ¿Una raíz o varias?

**Una raíz lógica, varios agregados con consistencia acotada.**

| Agregado | Raíz | Justificación |
|----------|------|---------------|
| Catálogo de Workspaces | `Workspace` | Identidad, configuración, vínculos declarativos |
| Conocimiento | `KnowledgeEntry` | Ciclo de vida propio (borrador → revisado → obsoleto); volumen independiente |
| Conversaciones | `Conversation` | Puede crecer mucho; historial de mensajes con escritura append-only |
| Diario de eventos | `DomainEvent` (registro) | Stream append-only; consumidores asíncronos |
| Recursos vinculados | `ResourceBinding` | Declaración; la conexión viva es runtime |

Todos comparten `WorkspaceId` como clave de partición. La consistencia transaccional fuerte se exige dentro de cada agregado. Entre agregados: consistencia eventual vía eventos.

**Por qué no un único agregado gigante:** cargar un Workspace no debería cargar 50 000 mensajes ni todo el diario de eventos. El ROADMAP y los principios de rendimiento lo impiden.

---

## 3. Entidades desde el primer día

Leyenda: ✅ introducir ya · ⚠️ introducir como concepto, implementación mínima · ❌ posponer

| Entidad propuesta | Veredicto | Justificación |
|-------------------|-----------|---------------|
| `Workspace` | ✅ | Raíz del catálogo. Sin ella no hay producto. |
| `WorkspaceDefinition` | ✅ (como valor dentro de `Workspace`) | Separar identidad de configuración exportable. No necesita clase propia al inicio. |
| `WorkspaceRuntime` | ✅ | Imprescindible para modelar arranque/parada sin contaminar persistencia. |
| `ResourceBinding` | ✅ | Declaración de dependencias. Core del workspace-first. |
| `ResourceKind` + descriptores tipados | ✅ | Sin conexión real todavía. |
| `KnowledgeEntry` | ✅ | Diferencia conocimiento de conversación desde el día uno. |
| `Conversation` | ✅ | Primera vista de interacción, pero subordinada al Workspace. |
| `Message` | ✅ | Parte del agregado Conversation. |
| `DomainEvent` / `EventRecord` | ✅ | Base del sistema basado en eventos. |
| `AuthorityPolicy` | ⚠️ | Concepto necesario; implementación mínima (lista de reglas declarativas). |
| `IdentityContext` | ⚠️ | Solo referencia a identidad activa; sin ejecución privilegiada aún. |
| `WorkspaceReadiness` | ✅ (como valor en Runtime) | Estado operativo; no persistir como verdad única. |
| `WorkspaceService` | ❌ como entidad | Es infraestructura/runtime. El dominio tiene `ResourceBinding`. |
| `WorkspaceCapability` | ⚠️ como derivado | Capacidad = evaluación de bindings + estado runtime. No persistir. |
| `WorkspacePermission` | ⚠️ | Parte de `AuthorityPolicy`. |
| `WorkspaceHistory` | ❌ como entidad | Es la proyección del registro de eventos. |
| `WorkspaceConfiguration` | ✅ (dentro de `Workspace`) | Preferencias exportables. |
| `Decision` | ✅ (como tipo de `KnowledgeEntry`) | ADR, elección con rationale y fecha. |
| `DocumentReference` | ✅ (como tipo de binding o knowledge) | Puntero a doc externo, no copia. |
| `Milestone` / `Task` | ❌ | Riesgo de convertir NATIA en PM tool. Posponer hasta evidencia. |
| `WorkspaceSnapshot` | ❌ | Backup/versionado; fase posterior. |

### Entidades eliminadas de la lista original

- **`WorkspaceState`** → dividido en `LifecycleStatus` (admin, en Workspace) y `ReadinessStatus` (operativo, en Runtime).
- **`WorkspaceService`** → no es dominio; es conector de infraestructura.
- **`WorkspaceHistory`** → proyección, no entidad raíz.
- **`WorkspaceCapability`** → vista materializada, no fuente de verdad.

---

## 4. Recursos

### Principio

El dominio conoce **qué** necesita el Workspace (`ResourceBinding`). La infraestructura sabe **cómo** conectarlo (`ResourceConnector`). El runtime mantiene **si** está conectado (`ResourceConnection`).

### Interfaz común (contrato, no clase monolítica)

Todo recurso declarado comparte:

```
ResourceBinding
├── id
├── workspaceId
├── kind: ResourceKind
├── role: ResourceRole          // ej. "primary-repo", "docs", "inference"
├── displayName
├── declaration: ResourceDeclaration   // payload tipado por kind
├── required: boolean
├── secretRefs: SecretReference[]      // solo referencias
└── metadata
```

`ResourceKind` inicial:

| Kind | Declaración contiene | Ejemplo de rol |
|------|---------------------|----------------|
| `GitRepository` | remote/local path, branch preferida | primary-repo |
| `FileLocation` | path, scope (read/read-write) | workspace-files |
| `Database` | connection template, read-only flag | analytics-db |
| `ContainerService` | image/compose ref, ports | local-stack |
| `ModelProvider` | endpoint, protocol, default model | inference |
| `McpServer` | transport, command, config ref | tools |
| `Tool` | tool id, manifest ref | builtin |
| `Credential` | credential store key | api-key |
| `Process` | command template, supervision policy | indexer |
| `Terminal` | shell profile, cwd ref | dev-terminal |
| `HttpService` | base URL, health check path | external-api |

### ¿Especialización?

Sí, mediante **declaraciones tipadas** (`ResourceDeclaration` por kind), no mediante herencia profunda. El binding es uniforme; el payload es específico.

Ventajas: registro único, validación por kind, UI genérica para listar dependencias, conectores intercambiables.

### Lo que el Workspace NO hace con recursos

- No mantiene conexiones abiertas.
- No ejecuta health checks (los hace el runtime y emite eventos).
- No almacena secretos resueltos.

---

## 5. Estado

### Dos ejes ortogonales

Mezclar ambos en un único enum genera ambigüedad.

#### A. `LifecycleStatus` (administrativo, persistente en Workspace)

| Estado | Significado |
|--------|-------------|
| `Draft` | Creado, definición incompleta |
| `Active` | En uso normal |
| `Archived` | Cerrado, no se activa por defecto |
| `Deleted` | Borrado lógico pendiente de purga |

#### B. `ReadinessStatus` (operativo, solo en WorkspaceRuntime)

| Estado | Significado |
|--------|-------------|
| `Unloaded` | No cargado en memoria |
| `Loading` | Cargando definición |
| `Activating` | Arrancando dependencias |
| `Ready` | Todas las dependencias requeridas satisfechas |
| `Degraded` | Operativo con dependencias opcionales caídas |
| `Suspended` | Pausado por el usuario; estado preservado |
| `Stopping` | Apagado en curso |
| `Stopped` | Apagado limpio |
| `Failed` | Activación fallida; requiere intervención |
| `Damaged` | Inconsistencia de datos detectada |

### Mapeo con los estados propuestos por el usuario

| Propuesta usuario | Ubicación |
|-------------------|-----------|
| creado | `LifecycleStatus.Draft` |
| inicializado | `LifecycleStatus.Active` + definición completa |
| arrancando | `ReadinessStatus.Activating` |
| operativo | `ReadinessStatus.Ready` |
| parcialmente operativo | `ReadinessStatus.Degraded` |
| suspendido | `ReadinessStatus.Suspended` |
| detenido | `ReadinessStatus.Stopped` |
| dañado | `ReadinessStatus.Damaged` o corrupción en persistencia |

### Estados adicionales justificados

- `Loading`, `Stopping`: transiciones explícitas evitan condiciones de carrera en UI.
- `Failed` vs `Damaged`: fallo de activación recuperable vs corrupción de datos.

### Estados que sobran como persistidos

No persistir `Ready`/`Degraded` como verdad. Al reabrir NATIA, el runtime recalcula readiness durante la activación.

---

## 6. Memoria

### Definiciones

| Concepto | Qué es | Persistencia | Calidad |
|----------|--------|--------------|---------|
| **Conversación** | Transcripción de interacción humano↔IA | Sí, agregado `Conversation` | Cruda, temporal, puede contener errores |
| **Conocimiento** | Hecho o síntesis **curada** perteneciente al proyecto | Sí, `KnowledgeEntry` | Revisable, tipada, con procedencia |
| **Documentación** | Artefacto externo o archivo del repo | Referencia (`DocumentReference`) | Fuente autoritativa externa |
| **Decisión** | Elección con contexto, alternativas y rationale | Sí, `KnowledgeEntry` tipo `Decision` | Autoritativa una vez aceptada |
| **Contexto** | Paquete **ensamblado** para una operación (prompt, tool call) | No como entidad primaria | Derivado, desechable |
| **Memoria** | Término paraguas / capacidad del sistema | N/A | Designa el *objetivo*, no una tabla |

### Reglas para no mezclarlos

1. **Unidireccionalidad:** Conversación → (promoción explícita) → Conocimiento. Nunca al revés como fuente de verdad.
2. **Procedencia obligatoria:** Todo `KnowledgeEntry` registra origen (`authored`, `imported`, `promoted-from-conversation`, `extracted-from-event`).
3. **Estados de curación:** `Draft` → `Accepted` → `Superseded` | `Rejected`.
4. **El contexto es una vista:** lo construye un servicio de aplicación leyendo Knowledge + Documentation refs + fragmentos seleccionados de Conversation. No se persiste salvo para depuración.
5. **Decisiones ≠ mensajes:** un ADR es KnowledgeEntry, no un mensaje largo en un chat.
6. **Documentación externa:** NATIA referencia, no reemplaza el repo de docs.

### Consolidación de memoria

La consolidación (resumir conversaciones, proponer knowledge) es un **proceso** (`MemoryConsolidationService`), no una entidad. Sus resultados son `KnowledgeEntry` en estado `Draft` pendientes de aceptación humana.

---

## 7. Eventos

### Tipos de eventos

| Capa | Propósito | Ejemplos |
|------|-----------|----------|
| **Domain events** | Hechos ocurridos en el dominio | `WorkspaceCreated`, `KnowledgeEntryAccepted` |
| **Runtime events** | Estado operativo | `ResourceConnectionEstablished`, `ResourceHealthChanged` |
| **Integration events** | Cruce de límites (workers, UI) | `ModelResponseChunkReceived`, `ToolExecutionCompleted` |

### Eventos de dominio — día uno

```
WorkspaceCreated
WorkspaceArchived
WorkspaceDefinitionChanged
ResourceBindingAdded
ResourceBindingRemoved
ResourceBindingChanged
KnowledgeEntryCreated
KnowledgeEntryAccepted
KnowledgeEntrySuperseded
ConversationCreated
ConversationArchived
DecisionRecorded
DomainEventRecorded          // meta: algo se registró en el diario
```

### Eventos de runtime — día uno

```
WorkspaceRuntimeCreated
WorkspaceActivationStarted
WorkspaceActivationCompleted
WorkspaceActivationFailed
WorkspaceSuspended
WorkspaceStopped
ResourceConnectionStarted
ResourceConnectionReady
ResourceConnectionLost
ResourceHealthDegraded
```

### Eventos de integración — día uno (mínimo)

```
PersistenceCommitted
PersistenceFailed
```

### Alternativa considerada: solo event sourcing

**Rechazada para la v1.** El volumen de conversaciones y mensajes hace costoso el replay completo. En su lugar:

- **Registro de eventos de dominio** append-only para auditoría y proyecciones.
- **Estado actual** en repositorios convencionales (documentos JSON + índice SQLite futuro).

Event sourcing parcial puede aplicarse después al diario de actividad si se demuestra necesidad.

### Nombres descartados

- `WorkspaceOpened` → preferir `WorkspaceActivationStarted` (apertura ≠ operativo).
- `WorkspaceStarted` → ambiguo; usar `WorkspaceActivationCompleted` cuando readiness = Ready.
- `ADRAdded` → generalizar a `DecisionRecorded` (ADR es un tipo de decisión).

---

## 8. Persistencia

### Fuente de verdad canónica

Estructura en disco exportable (principio 11 de PRINCIPLES):

```
<workspace-root>/
  workspace.json              # identidad + configuración + lifecycle
  bindings/
    <binding-id>.json
  knowledge/
    <entry-id>.md             # o .json con frontmatter
  conversations/
    <conversation-id>/
      meta.json
      messages.jsonl
  events/
    YYYY-MM-DD.jsonl
```

SQLite (futuro) = **índice derivado** para búsqueda y consultas. Debe poder reconstruirse desde los archivos canónicos.

### Repositorios (interfaces)

| Repositorio | Agregado | Operaciones |
|-------------|----------|-------------|
| `IWorkspaceRepository` | Workspace | CRUD, list, archive |
| `IResourceBindingRepository` | ResourceBinding | CRUD por workspace |
| `IKnowledgeRepository` | KnowledgeEntry | CRUD, query por tipo/estado |
| `IConversationRepository` | Conversation | CRUD, append message |
| `IEventJournal` | EventRecord | Append, read range, subscribe |
| `IWorkspaceCatalog` | — | Índice de todos los workspaces (puede ser mismo repo) |

### Qué persiste

- Definición del Workspace y bindings.
- Knowledge entries y decisiones.
- Conversaciones y mensajes.
- Registro de eventos de dominio.
- Políticas de autoridad (sin secretos).
- Último `ReadinessStatus` conocido **solo como hint opcional** en `workspace.json`, recalculado al activar.

### Qué NUNCA persiste

- Conexiones vivas, sockets, handles de proceso.
- Secretos en claro.
- Contexto ensamblado para prompts.
- Buffers de streaming.
- Estado de UI.
- Inferencias no promovidas a Knowledge.
- Credenciales resueltas.

### Unidad de consistencia

- Escritura atómica por agregado (un archivo o transacción SQLite por operación).
- Eventos: append al journal después de commit del agregado (outbox pattern futuro).

---

## 9. Arquitectura del Core

### Estructura propuesta

```text
src/core/
├── domain/
│   ├── workspace/           # Workspace, LifecycleStatus, WorkspaceDefinition
│   ├── resources/           # ResourceBinding, ResourceKind, declarations
│   ├── knowledge/           # KnowledgeEntry, Decision, curation status
│   ├── conversations/       # Conversation, Message
│   └── events/              # DomainEvent types, EventRecord
│
├── application/
│   ├── workspace/           # CreateWorkspace, ArchiveWorkspace, ...
│   ├── activation/          # ActivateWorkspace, SuspendWorkspace, StopWorkspace
│   ├── resources/           # RegisterBinding, EvaluateRequirements
│   ├── knowledge/           # PromoteToKnowledge, AcceptKnowledge, ...
│   ├── conversations/       # StartConversation, AppendMessage, ...
│   └── projections/         # Read models: ActivityFeed, WorkspaceSummary
│
├── contracts/
│   ├── repositories/        # interfaces de persistencia
│   ├── connectors/          # IResourceConnector (infra implementará)
│   ├── events/              # IEventPublisher, IEventJournal
│   └── dto/                 # tipos de transporte interno (sin UI)
│
└── shared/
    ├── ids/                 # WorkspaceId, strongly-typed identifiers
    ├── results/             # Result<T, Error> — operaciones explícitas
    └── time/                # IClock (testabilidad)
```

### Qué NO va en `core/`

| Módulo | Ubicación futura | Motivo |
|--------|------------------|--------|
| SQLite, filesystem | `src/infrastructure/persistence/` | Detalle de implementación |
| Provider adapters | `src/providers/` | Ya previsto en ARCHITECTURE |
| Workers, IPC | `src/workers/` | Proceso aislado |
| UI VCL | `src/ui/vcl/` | Shell nativo |
| Protocolos externos | `src/protocols/` | OpenAI, MCP |

### Justificación (no es Clean/Hexagonal de manual)

- **`domain/`** — lenguaje del negocio puro. Sin IO, sin threads, sin UI. Testeable en memoria.
- **`application/`** — casos de uso que orquestan dominio + contratos. Aquí vive la activación del Workspace y la consolidación de memoria.
- **`contracts/`** — puertos. El dominio no conoce SQLite ni pipes.
- **Sin carpeta `infrastructure/` dentro de core** — el core es portable; la infraestructura es otro módulo del repo.
- **Sin carpeta `services/` genérica** — evita cajón de sastre. Los servicios tienen nombre según caso de uso (`activation/`, `projections/`).
- **`projections/`** — lecturas derivadas (resumen del proyecto, feed de actividad) sin contaminar agregados.

### Flujo de activación

```text
Usuario selecciona Workspace
        │
        ▼
ActivateWorkspace (application)
        │
        ├─► Cargar Workspace + Bindings (repositories)
        ├─► Crear WorkspaceRuntime
        ├─► Emitir WorkspaceActivationStarted
        ├─► Para cada binding requerido: connector.Connect (infra)
        ├─► Actualizar ReadinessStatus
        └─► Emitir WorkspaceActivationCompleted | Failed
```

---

## Modelo de entidades — referencia

### Workspace

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Identidad y continuidad persistente del proyecto |
| Ciclo de vida | Draft → Active → Archived → Deleted |
| Relaciones | 1:N bindings, knowledge, conversations; particiona event journal |
| Propietario | Dominio / usuario |
| Persistencia | `workspace.json` |
| Eventos | Created, DefinitionChanged, Archived |

### WorkspaceRuntime

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Ejecución y readiness del Workspace en esta instancia NATIA |
| Ciclo de vida | Unloaded → Loading → Activating → Ready/Degraded → Stopped |
| Relaciones | 1:1 con Workspace cargado; 1:N ResourceConnection |
| Propietario | Capa de aplicación (no persistido) |
| Persistencia | Ninguna |
| Eventos | Activation*, Suspended, Stopped, Resource* |

### ResourceBinding

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Declarar dependencia externa del proyecto |
| Ciclo de vida | Creado → Modificado → Eliminado |
| Relaciones | N:1 Workspace |
| Propietario | Dominio |
| Persistencia | `bindings/<id>.json` |
| Eventos | Added, Changed, Removed |

### KnowledgeEntry

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Hecho curado del proyecto |
| Ciclo de vida | Draft → Accepted → Superseded/Rejected |
| Relaciones | N:1 Workspace; opcionalmente ref a Conversation/Message |
| Propietario | Dominio (contenido del usuario) |
| Persistencia | `knowledge/<id>.md` |
| Eventos | Created, Accepted, Superseded |

### Conversation

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Historial de interacción |
| Ciclo de vida | Active → Archived |
| Relaciones | N:1 Workspace; 1:N Message |
| Propietario | Dominio |
| Persistencia | `conversations/<id>/` |
| Eventos | Created, Archived, MessageAppended |

### EventRecord

| Aspecto | Detalle |
|---------|---------|
| Responsabilidad | Registro inmutable de hechos |
| Ciclo de vida | Append-only |
| Relaciones | N:1 Workspace |
| Propietario | Infraestructura (journal) |
| Persistencia | `events/*.jsonl` |
| Eventos | — (es el log) |

---

## Diagrama de relaciones

```text
                    ┌─────────────────────┐
                    │     Workspace       │
                    │  (persistente)      │
                    └──────────┬──────────┘
           ┌───────────────────┼───────────────────┐
           │                   │                   │
           ▼                   ▼                   ▼
   ┌───────────────┐  ┌───────────────┐  ┌───────────────┐
   │ResourceBinding│  │KnowledgeEntry │  │ Conversation  │
   └───────┬───────┘  └───────────────┘  └───────┬───────┘
           │                                    │
           │ (en activación)                    ▼
           ▼                             ┌───────────────┐
   ┌───────────────┐                     │    Message    │
   │  Connector    │                     └───────────────┘
   │  (infra)      │
   └───────┬───────┘
           ▼
   ┌───────────────┐       ┌───────────────┐
   │  Connection   │◄──────│WorkspaceRuntime│
   │  (efímero)    │       │  (efímero)     │
   └───────────────┘       └───────────────┘
```

---

## Riesgos

| Riesgo | Mitigación |
|--------|------------|
| Workspace dios | Separar persistente vs runtime; proyecciones fuera del agregado |
| Sobre-modelado de PM | Posponer milestones/tasks; usar KnowledgeEntry |
| Conversación como memoria implícita | Promoción explícita a Knowledge |
| Orden ROADMAP incorrecto | ADR-0002; dominio antes que chat persistido |
| Exportabilidad vs rendimiento | Canónico en archivos; SQLite derivado |
| Readiness obsoleto al reabrir | Recalcular siempre en activación |
| Event journal infinito | Retención, compactación, archivado por fecha |

---

## Puntos abiertos

1. **¿Un Workspace puede compartir bindings con otro?** Por ahora: no. Simplifica permisos.
2. **¿Conversaciones entre workspaces?** No. Exportar/importar si necesario.
3. **Formato exacto de `workspace.json`** — definir schema v1 en fase 0.2.
4. **Sincronización multi-máquina / multi-usuario** — fuera de alcance; el diseño no lo impide (event journal + export).
5. **Nivel de detalle de `AuthorityPolicy` en v1** — probablemente lista de reglas declarativas sin motor complejo.
6. **IPC interno** — sigue abierto según ARCHITECTURE; no afecta al dominio.

---

## Cambios recomendados a la documentación existente

| Documento | Cambio |
|-----------|--------|
| `docs/ROADMAP.md` | Mover Workspaces antes de conversaciones; añadir Fase 0.1 Dominio |
| `docs/ARCHITECTURE.md` | Sustituir «session manager»; ampliar sección Workspaces con este modelo |
| `docs/ARCHITECTURE.md` | Aclarar SQLite como índice, no fuente de verdad |
| `README.md` | Enlazar a `docs/DOMAIN-MODEL.md` |

---

## ADR propuesto

Ver [ADR-0002: Workspace domain model](adr/0002-workspace-domain-model.md).

---

## Siguiente paso (Fase 0.2 — no esta fase)

Definir JSON Schema v1 para `workspace.json`, `ResourceBinding` y `KnowledgeEntry`. Implementar repositorios en memoria y tests de casos de uso sin GUI ni proveedores.
