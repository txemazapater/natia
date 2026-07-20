# NATIA — Roadmap

## Filosofía del roadmap

NATIA se desarrolla en pruebas arquitectónicas pequeñas. Cada fase deja el proyecto más claro, medible y fácil de extender.

La primera prioridad ya no es «demostrar chat cuanto antes», sino **demostrar el lenguaje de dominio y un Core desacoplado**. Sin eso, providers y conversaciones congelarían un modelo conversation-first incompatible con [ADR-0001](adr/0001-workspace-first-architecture.md) y [ADR-0003](adr/0003-core-domain-refinement.md).

## Estado de las fases

| Fase | Nombre | Estado |
|------|--------|--------|
| 0.1 | Modelo de dominio | Completada |
| 0.2 | Revisión crítica y consolidación arquitectónica | Completada (docs) |
| 0.3 | Core ejecutable en memoria | Siguiente |
| 0.4 | Shell nativo | Pendiente |
| 0.5 | Persistencia operacional y exportación | Pendiente |
| 0.6 | Primer proveedor de IA | Pendiente |
| 0.7 | Conversaciones reales en producto | Pendiente |
| 0.8 | Recursos y conectores reales | Pendiente |
| 0.9 | MCP y herramientas | Pendiente |
| 1.0 | Primera versión pública | Pendiente |

Detalle de la siguiente fase: [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).

---

## Fase 0.1 — Modelo de dominio

### Objetivo

Definir el lenguaje interno del producto antes de escribir código de UI o infraestructura.

### Entregables

- visión, principios, manifiesto;
- arquitectura inicial;
- ADR-0001 (Workspace-first);
- primer modelo de dominio y ADR-0002 (histórico).

### Criterios de salida

Existe un vocabulario compartido: Workspace, Runtime, Knowledge, Conversation, recursos, eventos.

**Estado:** completada.

---

## Fase 0.2 — Revisión crítica y consolidación arquitectónica

### Objetivo

Intentar romper el modelo, corregir decisiones prematuras y eliminar contradicciones documentales.

### Entregables

- [DOMAIN-MODEL-REVIEW.md](DOMAIN-MODEL-REVIEW.md);
- [ADR-0003](adr/0003-core-domain-refinement.md) (Accepted; reemplaza operativamente ADR-0002);
- DOMAIN-MODEL, ARCHITECTURE y ROADMAP alineados;
- alcance formal de la Fase 0.3.

### Criterios de salida

> Dos desarrolladores distintos podrían implementar el Core en memoria y producir modelos compatibles sin una reunión para interpretar la arquitectura.

**Estado:** completada con la aceptación de ADR-0003 y la documentación consolidada.

---

## Fase 0.3 — Core ejecutable en memoria

### Objetivo

Construir un Core ejecutable y verificable **completamente en memoria** que demuestre el lenguaje de dominio consolidado.

### Entregables

Ver [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).

Resumen:

- domain / application / contracts;
- repositorios y conectores in-memory;
- Workspace, Runtime (N, RuntimeId), bindings, Conversation, Knowledge (Fact/Decision/Scratch);
- Fact Events + envelope; Session/Signal fuera del journal;
- `IWorkspaceExporter` sin filesystem;
- suite de pruebas de aceptación.

### Restricciones

Sin GUI, SQLite, MCP, providers reales, Docker, Git, plugins, HTTP real.

### Criterios de salida

Todos los tests de aceptación de la Fase 0.3 en verde; ningún test acoplado a infraestructura prohibida.

---

## Fase 0.4 — Shell nativo

### Objetivo

Demostrar la experiencia de escritorio nativa sin contaminar el Core.

### Entregables

- ejecutable nativo Windows (Delphi/VCL);
- ventana principal y navegación mínima;
- almacenamiento de ajustes de aplicación (no del dominio del Workspace);
- logging estructurado;
- ciclo de vida de aplicación;
- vista de diagnósticos;
- mediciones de arranque y reposo.

El shell consume el Core (o un fachada) sin reimplementar reglas de dominio.

### Criterios de salida

Arranque rápido, cierre predecible, idle sin CPU innecesaria. El dominio sigue testeable sin GUI.

---

## Fase 0.5 — Persistencia operacional y exportación

### Objetivo

Sustituir la memoria por la fuente operativa de verdad y demostrar exportación documental.

### Entregables

- implementación del store operacional (candidato: SQLite);
- journal de Fact Events;
- recuperación tras apagado anormal;
- ubicación de datos configurable;
- `IWorkspaceExporter` hacia JSON/Markdown/JSONL en disco;
- backup/restore documentado;
- **sin** dual-write permanente.

### Criterios de salida

Un Workspace sobrevive al reinicio; export/import redondo sin pérdida de hechos esenciales; secretos nunca en el store en claro.

---

## Fase 0.6 — Primer proveedor de IA

### Objetivo

Conectar NATIA a un endpoint compatible con OpenAI sin acoplar el Workspace al vendor.

### Entregables

- registro de Providers a nivel de aplicación;
- referencia segura a API key (`SecretReference`);
- prueba de conexión, listado de modelos;
- chat básico + streaming + cancelación;
- errores normalizados;
- diagnósticos con redacción de secretos.

### Objetivos iniciales de interoperabilidad

Ollama, LM Studio, endpoints autoalojados; opcionalmente OpenAI.

### Criterios de salida

Configurar endpoint, elegir modelo, enviar prompt, ver stream y cancelar sin congelar la UI.

---

## Fase 0.7 — Conversaciones reales en producto

### Objetivo

Hacer útiles las conversaciones del dominio en el producto diario (UI + persistencia ya existentes).

### Entregables

- creación/renombrado en shell;
- historial de mensajes con carga perezosa;
- metadatos provider/model por conversación;
- renderizado Markdown;
- copia y export de conversación;
- promoción a Knowledge desde la UI.

### Criterios de salida

Conversaciones usables a diario, exportables, sin cuenta remota obligatoria. El journal **no** crece un Fact Event por mensaje.

---

## Fase 0.8 — Recursos y conectores reales

### Objetivo

Sustituir conectores in-memory por Adapters reales bajo activation perezosa.

### Entregables

- `FileLocation` real (ámbitos de carpeta);
- `GenericEndpoint` / HTTP básico según necesidad;
- `EnsureConnected` con fallos reales → Degraded/Failed;
- ampliación controlada de kinds solo con evidencia;
- auditoría mínima de conexiones (Session Events).

### Criterios de salida

Abrir Workspace no arranca el mundo; conectar un recurso es explícito; fallos no tiran el proceso UI.

---

## Fase 0.9 — MCP y herramientas

### Objetivo

Consumir ecosistemas de herramientas abiertos sin hacer de MCP la arquitectura interna.

### Entregables

- binding/configuración de servidor MCP;
- transporte stdio;
- supervisión de ciclo de vida;
- descubrimiento de tools (catálogo de Connection, no bindings estáticos por tool);
- permisos y aprobación;
- una herramienta de referencia aislada.

### Criterios de salida

Al menos un MCP externo usable sin comprometer el proceso principal.

---

## Fase 1.0 — Primera versión pública

### Objetivo

Banco de trabajo de IA nativo estable para uso diario.

### Cualidades requeridas

- arranque medible;
- Workspace-first usable;
- store + export;
- provider local y remoto;
- conversaciones y knowledge;
- tools/MCP supervisados;
- agentes controlados básicos (si la evidencia lo justifica antes);
- documentación de seguridad, backup y migración;
- instalador / portable.

---

## Direcciones post-1.0

Sujeto a evidencia: RAG local, terminal/Git profundos, workers remotos / SAPIENS, colaboración, sync, packs de Workspace, clientes alternativos (Lazarus), marketplace solo tras protocolo de extensión estable.

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
