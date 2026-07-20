# NATIA — Arquitectura inicial

## Estado

Este documento describe la dirección arquitectónica vigente tras [ADR-0001](adr/0001-workspace-first-architecture.md) y [ADR-0003](adr/0003-core-domain-refinement.md).

No es aún una especificación de implementación completa. Las decisiones vinculantes viven en `docs/adr/`. El modelo de dominio detallado está en [DOMAIN-MODEL.md](DOMAIN-MODEL.md). El alcance inmediato del Core está en [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).

## Objetivos arquitectónicos

NATIA debe proporcionar:

- un shell de escritorio nativo e inmediatamente responsivo;
- un Core desacoplado de UI, store concreto, proveedores y herramientas;
- acceso no bloqueante a modelos locales y remotos (fases posteriores);
- supervisión explícita del trabajo en segundo plano (fases posteriores);
- aislamiento de extensiones y operaciones de riesgo;
- independencia de proveedores;
- una única fuente operativa de verdad, transaccional y recuperable, con exportación documental obligatoria;
- un camino estable desde el Core en memoria hasta un banco de trabajo completo.

## Forma propuesta del sistema

```text
+------------------------------------------------------------+
| NATIA Desktop (Shell)                                      |
|  UI nativa — workspaces, conversaciones, diagnósticos      |
+-------------------------------+----------------------------+
                                |
                                | comandos / eventos tipados
                                v
+------------------------------------------------------------+
| NATIA Core                                                 |
|  domain · application · contracts                          |
|  Workspace, Runtime, Conversation, Knowledge, Fact Events  |
+----------+------------------+-------------------+-----------+
           |                  |                   |
           v                  v                   v
+----------------+  +------------------+  +-------------------+
| Infraestructura|  | Providers        |  | Workers / hosts   |
| store operativo|  | (adapters IA)    |  | tools, MCP, …     |
| export         |  |                  |  |                   |
+----------------+  +------------------+  +-------------------+
```

## 1. Desktop shell

El shell posee el ciclo de vida visible y la experiencia nativa.

Responsabilidades:

- arranque y apagado de la aplicación;
- ventanas, navegación y controles nativos;
- presentación de conversaciones y streaming;
- selección de Workspace;
- aprobaciones del usuario;
- estado de tareas y workers (cuando existan);
- diagnósticos orientados al usuario.

El shell **no** ejecuta inferencia, indexación ni herramientas en el hilo de UI.

### Plataforma inicial

Cliente de referencia: Windows, Delphi y VCL. Compatibilidad multiplataforma primero en protocolos y Core, no en UI.

## 2. Core

El Core coordina el dominio y los casos de uso **sin** depender de controles visuales ni de infraestructura concreta.

### Qué contiene el Core

```text
domain/
application/
contracts/
```

Responsabilidades del perímetro actual ([ADR-0003](adr/0003-core-domain-refinement.md)):

- ciclo de vida de Workspace y WorkspaceRuntime;
- bindings embebidos y EnsureConnected vía contratos;
- Conversation y Message;
- KnowledgeEntry (Fact, Decision, Scratch);
- Fact Events y Event Envelope;
- puertos de repositorio, journal, connector y exporter.

### Qué no contiene el Core

- SQLite ni cualquier store concreto;
- filesystem;
- UI (VCL/FMX);
- proveedores de IA concretos;
- MCP;
- Docker;
- Git;
- secretos resueltos;
- procesos externos;
- carpetas prematuras: `projections/`, `services/` genérico, `workers/`, `authority/`, `identity/` ricos.

El Core debe probarse por completo con repositorios y conectores **en memoria**.

Los conceptos «session manager», «agent coordinator», «task supervisor» de borradores anteriores se reinterpretan como casos de uso o módulos futuros **fuera** del perímetro 0.3, nunca como un objeto dios «Workspace Engine». Las responsabilidades de continuidad descritas en ADR-0001 se realizan como **application use cases** sobre el dominio, no como un motor monolítico dentro del agregado Workspace.

## 3. Providers

Un **Provider** es un Adapter registrado a nivel de **aplicación** para modelos de IA.

El Workspace solo almacena preferencias opacas (`providerId`, `modelId`). Endpoints, secretos y configuración machine-specific viven fuera del Workspace.

Contrato futuro (no Fase 0.3): prueba de conexión, descubrimiento de modelos, chat/streaming, cancelación, tool-calls, errores normalizados.

## 4. Tareas, hilos y procesos

Distinción vigente para fases posteriores al Core en memoria:

- **Tareas de UI** — hilo principal, cortas.
- **Tareas en segundo plano** — hilos worker acotados.
- **Procesos worker** — herramientas, MCP, indexación, extensiones; supervisados y reiniciables.

## 5. Comunicación entre procesos

IPC aún no seleccionado (named pipes, TCP local, stdio, HTTP/WebSocket, MCP cuando encaje).

El protocolo interno deberá soportar: request ids, eventos asíncronos, streaming, cancelación, heartbeats, errores estructurados, negociación de versión, tamaños acotados.

En el Core, los **Signal Events** son el lenguaje de streaming/UI; no entran en el journal de dominio.

## 6. Herramientas y agentes

Herramienta = capacidad declarada con esquema y permisos. Agente = coordinador de modelo + herramientas + política.

Separados. Fuera del perímetro de la Fase 0.3.

## 7. Extensiones

Preferencia: fuera de proceso. Fuera de Fase 0.3.

## 8. Persistencia

Principio ([ADR-0003](adr/0003-core-domain-refinement.md)):

> Una única fuente operativa de verdad, transaccional y recuperable.

- Candidato operacional futuro: **SQLite**.
- Exportación obligatoria: JSON / Markdown / JSONL bajo demanda.
- **Sin dual-write** permanente archivos ↔ base.
- Journal de **Fact Events** en el store operacional (o outbox ligado a él).
- Secretos: credential store del SO / DPAPI; solo `SecretReference` en el dominio.

La Fase 0.3 usa únicamente repositorios en memoria. La Fase 0.5 introducirá el store operacional y el export real.

## 9. Workspaces

El Workspace es la entidad primaria del producto ([ADR-0001](adr/0001-workspace-first-architecture.md)).

Posee o referencia: identidad, instrucciones, bindings, preferencias de modelo, knowledge, conversaciones (particionadas), Fact Events.

La ejecución concreta es un **WorkspaceRuntime** (1:N, con `RuntimeId`). Activation perezosa: abrir ≠ conectar todos los recursos. Detalle: [DOMAIN-MODEL.md](DOMAIN-MODEL.md).

## 10. Modelo de seguridad

La salida del modelo es entrada no confiable. Líneas de defensa futuras: mínimo privilegio, ámbitos explícitos, aprobaciones, redacción de secretos, auditoría, límites de tiempo/salida.

Primera línea: autoridad explícita e inspectable. No se implementa el motor completo en Fase 0.3.

## 11. Estructura de código fuente (provisional)

```text
/
  README.md
  LICENSE
  docs/
  src/
    core/
      domain/
      application/
      contracts/
    infrastructure/     # store, export real — después de 0.3
    providers/          # después
    platform/windows/
    ui/vcl/             # shell — Fase 0.4
    workers/            # después
  tests/
    core/               # Fase 0.3: suite en memoria
```

## 12. Pruebas arquitectónicas por fase

| Fase | Demostración |
|------|----------------|
| 0.3 | Core en memoria; dominio consolidado; tests de aceptación |
| 0.4 | Shell nativo sin acoplar dominio a VCL |
| 0.5 | Store operacional + export |
| 0.6+ | Provider, conversaciones reales, conectores, MCP |

La primera prueba ejecutable del **dominio** es la Fase 0.3, no el conteo de features de UI.
