# NATIA — Arquitectura inicial

## Estado

Dirección arquitectónica vigente tras:

- [ADR-0001](adr/0001-workspace-first-architecture.md) — anti-conversation-first (Accepted; raíz del producto refinada por 0004)
- [ADR-0003](adr/0003-core-domain-refinement.md) — perímetro del Core ejecutable
- [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md) — Initiative, Runtime desambiguado, NEMO
- [`docs/foundation/`](foundation/00_FOUNDATION.MD) — filosofía, modelo, ontología, Desktop, Orchestration, Capability Graph

No es una especificación de implementación completa. Las decisiones vinculantes viven en `docs/adr/`. El dominio detallado está en [DOMAIN-MODEL.md](DOMAIN-MODEL.md).

## Objetivos arquitectónicos

NATIA debe proporcionar:

- un Desktop nativo Initiative-centric e inmediatamente responsivo;
- un Core desacoplado de UI, store concreto, proveedores y herramientas;
- continuidad de conocimiento (faceta **NEMO**) en el Workspace de cada Initiative;
- Capabilities orquestables y Resources reemplazables;
- acceso no bloqueante a modelos locales y remotos (fases posteriores);
- supervisión explícita del trabajo en segundo plano (fases posteriores);
- aislamiento de extensiones y operaciones de riesgo;
- una única fuente operativa de verdad, con exportación documental obligatoria;
- un camino estable desde el Core en memoria hasta el cognitive workspace completo.

## Forma propuesta del sistema

```text
+------------------------------------------------------------+
| NATIA Desktop (Shell)                                      |
|  UI nativa — Initiatives, Workspace, NEMO, conversaciones  |
+-------------------------------+----------------------------+
                                |
                                | comandos / eventos tipados
                                v
+------------------------------------------------------------+
| NATIA Core                                                 |
|  domain · application · contracts                          |
|  Workspace (+ NEMO facet) · WorkspaceRuntime               |
|  Conversation · Knowledge · Fact Events                    |
|  Initiative — pendiente de fase en código                  |
+----------+------------------+-------------------+-----------+
           |                  |                   |
           v                  v                   v
+----------------+  +------------------+  +-------------------+
| Infraestructura|  | Resources        |  | Workers / hosts   |
| store operativo|  | Providers/Adapters| | tools, MCP, …     |
| export         |  | (IA y otros)     |  |                   |
+----------------+  +------------------+  +-------------------+

  Cognitive Runtime + Orchestration + Capability Graph
  → comportamiento de application (evolutivo), no monolito en domain
```

## 1. Desktop y NATIA Studio

El **Desktop** es el concepto arquitectónico del entorno colaborativo donde persona y NATIA avanzan una **Initiative** ([04_DESKTOP.MD](foundation/04_DESKTOP.MD)).

**NATIA Studio** es el cliente de referencia nativo que materializa ese Desktop (Windows · Delphi · VCL · `src/apps/studio/Delphi/`). El Sprint 0 es su embrión visual.

Responsabilidades del cliente:

- arranque y apagado de la aplicación;
- navegación Initiative-centric (objetivo de experiencia; Sprint 0 valida layout tipo IDE);
- superficies: Home, Chat, NEMO (vista de continuidad de conocimiento), Tools, etc.;
- presentación de streaming y diagnósticos;
- aprobaciones del usuario;
- estado de tareas y workers (cuando existan).

Studio **no** ejecuta inferencia, indexación ni herramientas en el hilo de UI.

### Plataforma inicial

Cliente de referencia: **NATIA Studio** (Windows, Delphi y VCL). Compatibilidad multiplataforma primero en protocolos y Core, no en UI.

## 2. Core

El Core coordina el dominio y los casos de uso **sin** depender de controles visuales ni de infraestructura concreta.

### Qué contiene el Core (perímetro 0.3)

```text
domain/
application/
contracts/
```

Responsabilidades ([ADR-0003](adr/0003-core-domain-refinement.md)):

- ciclo de vida de Workspace y **WorkspaceRuntime**;
- bindings embebidos y EnsureConnected vía contratos;
- Conversation y Message;
- KnowledgeEntry (Fact, Decision, Scratch) — soporte de la faceta NEMO;
- Fact Events y Event Envelope;
- puertos de repositorio, journal, connector y exporter.

### Qué no contiene (aún)

- entidad `Initiative` (decisión de fase pendiente; [ADR-0004](adr/0004-foundation-reconciliation-and-nemo.md));
- tipo «Cognitive Runtime» como agregado;
- Capability Graph / Orchestration completos;
- SQLite u otro store concreto;
- UI, providers concretos, MCP, Docker, Git, secretos resueltos.

El Core debe probarse por completo con repositorios y conectores **en memoria**.

Las responsabilidades de continuidad (ADR-0001) y el Cognitive Runtime (foundation) se realizan como **application use cases** / orquestación, no como un motor monolítico dentro del agregado Workspace.

## 3. Providers y Resources

Un **Provider** es un Adapter registrado a nivel de **aplicación** para modelos de IA (un tipo de **Resource**).

El Workspace solo almacena preferencias opacas (`providerId`, `modelId`). Endpoints, secretos y configuración machine-specific viven fuera del Workspace.

Foundation: Capabilities definen *qué*; Resources implementan *cómo* y son reemplazables ([07_CAPABILITY_GRAPH.MD](foundation/07_CAPABILITY_GRAPH.MD)).

## 4. Tareas, hilos y procesos

- **Tareas de UI** — hilo principal, cortas.
- **Tareas en segundo plano** — hilos worker acotados.
- **Procesos worker** — herramientas, MCP, indexación, extensiones; supervisados y reiniciables.

## 5. Comunicación entre procesos

IPC aún no seleccionado. El protocolo interno deberá soportar request ids, eventos asíncronos, streaming, cancelación, heartbeats, errores estructurados, negociación de versión.

**Signal Events** = streaming/UI; no entran en el journal de dominio.

## 6. Herramientas y agentes

- **Herramienta / Agent** = Resources que implementan Capabilities (Execute, Analyze, …).
- Separados del Knowledge del Workspace.
- Fuera del perímetro 0.3.

## 7. Extensiones

Preferencia: fuera de proceso. Fuera de Fase 0.3. Crecimiento vía Capabilities nuevas en el grafo, no vía monolito UI.

## 8. Persistencia

Principio ([ADR-0003](adr/0003-core-domain-refinement.md)):

> Una única fuente operativa de verdad, transaccional y recuperable.

- Candidato operacional: **SQLite**.
- Exportación: JSON / Markdown / JSONL bajo demanda.
- **Sin dual-write** permanente.
- Journal de **Fact Events** en el store operacional.
- Secretos: solo `SecretReference` en el dominio.

Fase 0.3 = memoria. Fase 0.5 = store + export real.

## 9. Initiative y Workspace

| Concepto | Rol arquitectónico |
|----------|-------------------|
| **Initiative** | Raíz del producto; unidad de trabajo intelectual |
| **Workspace** | Memoria operativa 1:1; partición de Knowledge, Conversations, Fact Events |
| **NEMO** | Característica / superficie sobre Knowledge (no bounded context dueño) |
| **WorkspaceRuntime** | Ejecución efímera N por Workspace |

Detalle: [DOMAIN-MODEL.md](DOMAIN-MODEL.md), [05_WORKSPACE.MD](foundation/05_WORKSPACE.MD).

## 10. Modelo de seguridad

La salida del modelo es entrada no confiable. Defensa futura: mínimo privilegio, ámbitos explícitos, aprobaciones, redacción de secretos, auditoría.

Primera línea: autoridad explícita e inspectable. No en Fase 0.3.

## 11. Estructura de código fuente (provisional)

```text
/
  README.md
  LICENSE
  docs/
    foundation/
    adr/
  src/
    core/
      domain/
      application/
      contracts/
    apps/
      studio/Delphi/    # NATIA Studio — Sprint 0 embrión visual
    infrastructure/     # store, export real — después de 0.3
    providers/          # después
  tests/
    core/
```

## 12. Pruebas arquitectónicas por fase

| Fase | Demostración |
|------|----------------|
| 0.3 | Core en memoria; dominio Workspace; tests de aceptación |
| 0.4 | NATIA Studio; Sprint 0 = embrión visual (hecho); integración Core pendiente |
| TBD | Introducción de `Initiative` en el Core (fase a decidir) |
| 0.5 | Store operacional + export |
| 0.6+ | Provider, conversaciones reales, conectores, MCP |

La primera prueba ejecutable del **dominio** fue la Fase 0.3. La foundation y ADR-0004 actualizan el vocabulario **sin invalidar** esa prueba.
