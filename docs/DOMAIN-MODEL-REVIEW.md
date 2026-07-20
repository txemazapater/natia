# NATIA — Revisión crítica del modelo de dominio (Fase 0.2)

- **Estado:** Histórico (Fase 0.2 cerrada)
- **Fecha:** 2026-07-20
- **Alcance:** Revisión de DOMAIN-MODEL y ADR-0002. Sin implementación.
- **Seguimiento:** Las correcciones vinculantes están en [ADR-0003](adr/0003-core-domain-refinement.md). El modelo vigente es [DOMAIN-MODEL.md](DOMAIN-MODEL.md).
- **Postura original:** ADR-0002 permanecía Proposed; este documento intentó demostrar dónde era incorrecto, incompleto o prematuro.

---

## Veredicto ejecutivo

La dirección general de ADR-0002 es **correcta**: Workspace como producto, conversación ≠ conocimiento, declaración de recursos ≠ conexión viva, y rechazo del event sourcing completo.

Sin embargo, **ADR-0002 no debe aceptarse tal cual**.

El modelo mezcla decisiones sólidas con sobreespecificación prematura, deja sin resolver varios casos que el propio manifiesto promete, e invierte la decisión de persistencia de forma peligrosa para la integridad.

**Conclusión (en el momento de la revisión):** el modelo es suficientemente sólido para comenzar un Core ejecutable **en memoria**, siempre que se apliquen primero las correcciones de la sección «Deben resolverse antes de implementar».

**Resolución:** esas correcciones quedaron formalizadas en [ADR-0003](adr/0003-core-domain-refinement.md) (Accepted). ADR-0002 está **Superseded**. La Fase 0.3 está definida en [PHASE-0.3-EXECUTABLE-CORE.md](PHASE-0.3-EXECUTABLE-CORE.md).

---

## 1. Workspace y WorkspaceRuntime

### OBS-01 — Falta un tercer concepto: Host / ApplicationInstance

| | |
|---|---|
| **Problema** | El modelo solo distingue Workspace (persistente) y WorkspaceRuntime (efímero en «esta instancia NATIA»). No modela la instancia anfitriona: proceso de escritorio local, worker remoto, nodo SAPIENS, segunda copia de NATIA en otra máquina. |
| **Impacto** | Imposible razonar sobre ejecución distribuida, remota o multi-instancia sin reinventar identidad más adelante. |
| **Riesgo** | Alto a medio plazo. Bajo a corto plazo si se asume un solo proceso local. |
| **Alternativas** | (A) Introducir `HostId` / `ApplicationInstanceId` ahora como identificador opaco. (B) Posponer el concepto y documentar explícitamente la hipótesis «un solo host local». (C) Convertir Runtime en entidad con `runtimeId` + `hostId` desde el día uno. |
| **Recomendación** | **(B) + parte de (C):** no crear entidad Host ahora, pero **sí** dar a cada Runtime un `RuntimeId` y documentar la hipótesis de un solo host. Prohibir asumir `Workspace ↔ Runtime` 1:1 en código. |

### OBS-02 — La relación 1:1 Workspace–Runtime es falsa

| | |
|---|---|
| **Problema** | La tabla de entidades afirma «1:1 con Workspace cargado». Eso es una restricción de producto local, no una verdad de dominio. Dos NATIA abriendo el mismo Workspace, o un desktop + un worker remoto, requieren N runtimes. |
| **Impacto** | Código y eventos diseñados como singleton global por Workspace. |
| **Riesgo** | Alto si se codifica como singleton. |
| **Alternativas** | (A) Permitir N runtimes por Workspace desde el diseño. (B) Forzar exclusividad con lock de archivo y documentarlo como limitación v1. |
| **Recomendación** | **Ambas:** modelo mental N:1; implementación v1 con exclusividad local opcional (lock). Nunca un singleton implícito en el dominio. |

### OBS-03 — Runtime sin identificador propio

| | |
|---|---|
| **Problema** | `WorkspaceRuntime` no tiene identidad. Los eventos de activación, conexiones y fallos no pueden correlacionarse ni auditarse por sesión operativa. |
| **Impacto** | Diagnósticos débiles; cancelación y recuperación ambiguas; sync futura ciega. |
| **Riesgo** | Medio. Corregible temprano a bajo coste. |
| **Alternativas** | Añadir `RuntimeId` (UUID) al crear el runtime. |
| **Recomendación** | **Resolver antes de implementar.** Coste casi nulo. |

### OBS-04 — Suspended contradice «efímero»

| | |
|---|---|
| **Problema** | `Suspended` dice «estado preservado», pero Runtime «no se persiste». ¿Qué se preserva? ¿Conexiones? ¿Solo intención de reactivar? |
| **Impacto** | Implementaciones divergentes entre equipos. |
| **Riesgo** | Medio. |
| **Alternativas** | (A) Eliminar Suspended en v1 (solo Stop). (B) Definir Suspended = runtime vivo con conexiones pausadas/desconectadas, sin persistir. (C) Persistencia mínima de «última sesión» (hint), distinta del Runtime. |
| **Recomendación** | **(A) para v1.** Suspended puede volver cuando haya un caso de uso real (cerrar portátil, reanudar agentes). |

### OBS-05 — Damaged está en el eje equivocado

| | |
|---|---|
| **Problema** | `Damaged` aparece en `ReadinessStatus` (operativo), pero describe corrupción o inconsistencia de datos persistidos. |
| **Impacto** | Mezcla salud de datos con salud de ejecución. |
| **Riesgo** | Bajo–medio. |
| **Alternativas** | (A) `IntegrityStatus` en Workspace/persistencia. (B) Error de carga que impide crear Runtime. |
| **Recomendación** | **(B):** si la carga falla por corrupción, no hay Runtime Ready/Damaged; hay fallo de repositorio. Quitar Damaged de Readiness. |

### OBS-06 — Demasiados estados de readiness

| | |
|---|---|
| **Problema** | Diez valores de `ReadinessStatus` antes de existir un solo conector real. |
| **Impacto** | Máquina de estados costosa de probar; violenta el principio 14 (sin plataforma accidental). |
| **Riesgo** | Medio (complejidad). |
| **Alternativas** | Reducir a: `Inactive | Activating | Ready | Degraded | Failed`. |
| **Recomendación** | **Simplificar antes de implementar.** Loading/Stopping/Stopped/Unloaded/Suspended/Damaged sobran o se colapsan. |

---

## 2. Persistencia

### OBS-07 — Invertir «archivos canónicos / SQLite derivado» es un error probable

| | |
|---|---|
| **Problema** | ADR-0002 fija el árbol JSON/Markdown como fuente de verdad y SQLite como índice. Eso prioriza inspectabilidad sobre integridad transaccional. Un Workspace con N archivos no tiene commit atómico multi-archivo nativo. Crash a mitad de escritura → estado parcialmente inconsistente. Dos escritores → corrupción. |
| **Impacto** | Violación directa del objetivo «recuperable» de ARCHITECTURE y del principio de datos del usuario. |
| **Riesgo** | **Alto.** |
| **Alternativas** | Ver tabla comparativa abajo. |
| **Recomendación** | **No aceptar la decisión 6 de ADR-0002.** Preferir: **SQLite (u otro store operacional) como fuente operativa + exportación documental como artefacto derivado versionado.** La inspectabilidad se satisface con export/import, no con hacer del filesystem el OLTP. |

### Comparativa de persistencia

| Opción | Integridad | Recuperación | Versionado | Rendimiento | Sync futura | Inspección | Simplicidad |
|--------|------------|--------------|------------|-------------|-------------|------------|-------------|
| Solo JSON/MD en disco | Débil (multi-archivo) | Frágil sin fsync/atomic replace disciplinado | Bueno con Git | Malo a escala (muchos ficheros) | Conflictos de merge posibles pero ruidosos | Excelente | Engañosamente simple |
| Solo SQLite | Fuerte (transacciones) | Buena con WAL + backup | Schema migrations | Excelente para consultas | Más difícil (binario) | Mala sin herramientas | Simple para app |
| SQLite + exportación JSON/MD | Fuerte operativa + portable | Excelente | Export versionable | Excelente | Export/sync de artefactos | Excelente vía export | Media |
| SQLite + Event Journal | Fuerte + auditable | Muy buena | Eventos versionables | Buena; journal crece | Buena base para sync | Media | Media–alta |
| JSONL para mensajes/eventos | Media (append) | Buena si append-only estricto | Natural | Buena escritura; mala query | Buena para stream | Buena | Simple |
| Markdown para knowledge | N/A (formato de contenido) | Depende del store | Excelente humano | N/A | Conflictos de merge legibles | Excelente | Simple como formato, no como DB |
| LiteFS | Fuerte + réplica | Orientado a multi-nodo | — | Bueno | Diseñado para sync SQLite | Baja | **Sobreingeniería** para desktop local |
| DuckDB | Analítica | No es OLTP | — | Excelente analítica | — | Media | **Mala opción** como store primario |

**Recomendación de diseño (no implementación aún):**

1. **Operacional:** un store transaccional (SQLite es el candidato natural en Windows/desktop).
2. **Exportable:** paquetes documentales (JSON + Markdown + JSONL) generados bajo demanda y en backup.
3. **Journal:** append-only de eventos de dominio *dentro* del store o como JSONL gestionado por el mismo límite transaccional (outbox).
4. **Contenido humano:** Markdown puede seguir siendo el *formato de exportación/edición* de Knowledge, sin ser el motor de consistencia.

Esto **no contradice** el principio 11 («evitar bases opacas como única representación»): la base no es la única representación; la exportación es obligatoria y documentada.

### OBS-08 — Dual-write canónico + índice es peor que una sola fuente

| | |
|---|---|
| **Problema** | Si archivos son canónicos y SQLite es índice, hay dos representaciones que deben mantenerse sincronizadas. El drift es inevitable. |
| **Impacto** | Bugs de «la UI muestra X, el export muestra Y». |
| **Riesgo** | Alto. |
| **Alternativas** | Una fuente operativa + proyecciones derivadas regenerables. |
| **Recomendación** | Una sola fuente de verdad operativa. Todo lo demás se reconstruye o se exporta. |

### OBS-09 — El árbol de archivos propuesto sobreespecifica el Core

| | |
|---|---|
| **Problema** | DOMAIN-MODEL fija `workspace.json`, `bindings/`, `knowledge/*.md`, `messages.jsonl` antes de existir repositorios. |
| **Impacto** | Los equipos implementarán filesystem adapters innecesarios en Fase 0.3. |
| **Riesgo** | Medio. |
| **Alternativas** | Contratos de repositorio + implementación in-memory primero; el formato en disco es ADR posterior. |
| **Recomendación** | **Posponer el layout en disco.** Fase 0.3 solo `InMemory*Repository`. |

---

## 3. Eventos

### OBS-10 — Clasificación de tres capas es correcta en intención, confusa en práctica

| | |
|---|---|
| **Problema** | Domain / Runtime / Integration está bien conceptualmente, pero el documento mezcla ejemplos: `PersistenceCommitted` no es integración de negocio; `MessageAppended` puede inundar el journal de dominio; `ResourceConnectionLost` es runtime pero el usuario lo percibe como hecho del proyecto. |
| **Impacto** | Cada equipo meterá cosas distintas en el journal persistido. |
| **Riesgo** | Alto para sync y auditoría. |
| **Alternativas** | Clasificar por **destino de persistencia**, no solo por nombre: (1) **Fact events** — persistidos, exportables, sincronizables. (2) **Session events** — vida del Runtime, opcionalmente log local, no sync. (3) **Signal events** — streaming/UI/IPC, no journal de dominio. |
| **Recomendación** | Adoptar la clasificación por destino. Mantener Domain/Runtime como vocabulario interno si ayuda, pero el criterio de diseño es **qué se persiste**. |

### OBS-11 — `DomainEventRecorded` sobra

| | |
|---|---|
| **Problema** | Evento meta que registra que se registró un evento. |
| **Impacto** | Ruido. |
| **Riesgo** | Bajo. |
| **Recomendación** | Eliminar. |

### OBS-12 — Append de mensajes no debe ser evento de dominio de primera clase en el journal principal

| | |
|---|---|
| **Problema** | `MessageAppended` a escala de chat convierte el journal en un segundo almacén de conversaciones. |
| **Impacto** | Doble escritura, volumen enorme, replay inútil. |
| **Riesgo** | Alto. |
| **Alternativas** | (A) Mensajes solo en agregado Conversation. (B) Evento de conversación de grano grueso (`ConversationUpdated`). (C) Stream separado de telemetría. |
| **Recomendación** | **(A).** El journal de dominio registra creación/archivo de conversación y promociones a conocimiento, no cada token/mensaje. |

### OBS-13 — Falta un sobre de evento mínimo

| | |
|---|---|
| **Problema** | No hay contrato de `EventEnvelope`: `eventId`, `workspaceId`, `runtimeId?`, `occurredAt`, `actor`, `causationId`, `correlationId`, `schemaVersion`. |
| **Impacto** | Imposible correlación, sync, deduplicación. |
| **Riesgo** | Alto a medio plazo; bajo coste ahora. |
| **Recomendación** | Definir envelope mínimo **antes** de implementar el bus. Sin implementarlo todo: solo el shape. |

### OBS-14 — Workers, MCP, plugins e IA expondrán la mezcla

| | |
|---|---|
| **Problema** | Cuando existan workers/MCP, habrá avalancha de signal events (`ToolProgress`, `McpLog`, `TokenDelta`). Si comparten el mismo bus/journal que `WorkspaceCreated`, el sistema se vuelve inobservable por exceso. |
| **Impacto** | Diagnósticos inútiles; persistencia hinchada. |
| **Riesgo** | Alto. |
| **Recomendación** | Bus interno único **en proceso** está bien; **sinks** distintos (journal vs log vs UI stream). Documentarlo ya. |

---

## 4. Recursos

### OBS-15 — ResourceBinding mezcla declaración, tipología y catálogo de la plataforma

| | |
|---|---|
| **Problema** | Once `ResourceKind` el día uno (Git, Docker, Terminal, Process, Credential, MCP, Tool…). Incluye cosas que son (a) dependencias del proyecto, (b) capacidades de la plataforma, (c) secretos. |
| **Impacto** | Activation intenta «conectar todo»; contradice *fast by default* y *lazy loading*. |
| **Riesgo** | Alto (complejidad + arranque lento). |
| **Alternativas** | Separar mentalmente: **Binding** (el Workspace necesita X), **Connector/Adapter** (cómo hablar con X), **Connection** (sesión viva), **Provider** (registro global de modelos, no necesariamente binding). |
| **Recomendación** | En v1 solo 2–3 kinds: `FileLocation`, `ModelProvider` (o incluso provider global fuera del binding), y un `GenericService` opcional. El resto se añade con evidencia. |

### OBS-16 — Credential como ResourceKind duplica `secretRefs`

| | |
|---|---|
| **Problema** | Las credenciales aparecen como kind y como referencias en cada binding. |
| **Impacto** | Dos modelos de secretos. |
| **Riesgo** | Medio (seguridad). |
| **Recomendación** | Credenciales **solo** como `SecretReference` + store del SO. Nunca recurso activable. |

### OBS-17 — Provider registry global vs ModelProvider binding

| | |
|---|---|
| **Problema** | ARCHITECTURE define un registro de proveedores de aplicación. DOMAIN-MODEL pone `ModelProvider` como binding del Workspace. Ambos pueden ser válidos, pero la relación no está definida: ¿el Workspace referencia un provider global, o embebe endpoint? |
| **Impacto** | Duplicación de configuración; portabilidad rota (endpoint local de una máquina). |
| **Riesgo** | Medio. |
| **Alternativas** | (A) Providers globales de app + binding solo elige `providerId` + model. (B) Todo provider es binding. |
| **Recomendación** | **(A).** Preferencias de modelo en Workspace; endpoints y secretos en configuración de máquina/app. Separa portabilidad de machine-specific. |

### OBS-18 — Tool y McpServer como bindings prematuros

| | |
|---|---|
| **Problema** | Las herramientas MCP se descubren en runtime; declararlas como bindings estáticos pelea con el descubrimiento dinámico. |
| **Impacto** | Modelo rígido incompatible con MCP real. |
| **Riesgo** | Medio. |
| **Recomendación** | Binding = servidor MCP (proceso/comando). Tools = catálogo descubierto en Connection, no entidades persistidas del Workspace (salvo allowlist/deny). |

### OBS-19 — Falta distinguir recurso / instancia / conexión / adaptador

| | |
|---|---|
| **Problema** | El documento nombra Binding, Connector, Connection, pero no fija el vocabulario frente a Provider/Adapter/Driver. Los equipos inventarán sinónimos. |
| **Impacto** | Babel interno. |
| **Riesgo** | Medio. |
| **Recomendación** | Glosario mínimo obligatorio: **Binding** (declaración), **Adapter** (código que sabe hablar un protocolo), **Connection** (sesión viva), **Provider** (adapter de modelos registrado en la app). No usar Driver/Instance salvo necesidad demostrada. |

### OBS-20 — Activation conecta todos los required bindings

| | |
|---|---|
| **Problema** | El flujo de activación conecta cada binding requerido al abrir. Eso puede arrancar Docker, MCP, DBs solo por «abrir el proyecto». |
| **Impacto** | Arranque lento; fallos en cascada; mala UX. |
| **Riesgo** | Alto respecto a principios 2 y 15. |
| **Recomendación** | Activation = cargar definición + calcular *requirements* + readiness **declarativo**. Conectar bajo demanda (primera conversación, primera tool, acción explícita «Start environment»). Opcionalmente un modo «full start». |

---

## 5. Conocimiento y memoria

### OBS-21 — El modelo falla cuando el conocimiento no nace del chat

| | |
|---|---|
| **Problema** | La regla estrella es Conversación → (promoción) → Conocimiento. Pero los casos reales de NATIA incluyen: ADR ya existente en el repo; decisión tomada en una reunión e introducida a mano; hecho descubierto por una tool (`git log`, test fallido); importación masiva de docs. |
| **Impacto** | El flujo de promoción parece el camino feliz único; otros orígenes quedan de segunda clase. |
| **Riesgo** | Medio–alto para el propósito del manifiesto. |
| **Recomendación** | Mantener procedencias múltiples como ciudadanos de primera: `authored`, `imported`, `promoted-from-conversation`, `derived-from-tool`, `imported-from-repository`. La UI no debe centrarse solo en promoción desde chat. |

### OBS-22 — Falta el concepto de «notas de trabajo» / memoria operativa

| | |
|---|---|
| **Problema** | Entre mensaje crudo y Knowledge aceptado no hay capa intermedia durable: resúmenes de sesión, scratchpad del agente, «lo que estábamos haciendo». El Context es desechable; la Conversation es demasiado cruda; Knowledge exige curación. |
| **Impacto** | O se abusa de Conversation como memoria, o se contamina Knowledge con borradores. |
| **Riesgo** | **Alto** para continuidad del pensamiento. |
| **Alternativas** | (A) `WorkingNote` / `Scratchpad` por Workspace o por Runtime. (B) Knowledge en estado Draft usado como scratchpad. (C) Conversation summarization persistida como tipo distinto. |
| **Recomendación** | Introducir **`WorkingNote`** (o reutilizar Draft de Knowledge **con tipo `Scratch` no promocionable a Accepted sin cambio de tipo**). Debe resolverse conceptualmente antes del Core de memoria; puede implementarse mínimo en 0.3. |

### OBS-23 — Context no persistido rompe reproducibilidad y auditoría

| | |
|---|---|
| **Problema** | «El contexto no se persiste salvo depuración» choca con autoridad explícita y observabilidad: ¿qué vio el modelo cuando llamó a una tool destructiva? |
| **Impacto** | Imposible auditar decisiones del agente. |
| **Riesgo** | Alto en fases de agentes; bajo en chat simple. |
| **Recomendación** | Distinguir: Context de UI (efímero) vs **ContextSnapshot** opcional ligado a una ejecución/turn (persistible, redactado, retenido con política). No es entidad de día uno completa, pero el modelo no debe prohibirlo. |

### OBS-24 — Decision como mera variante de KnowledgeEntry es frágil

| | |
|---|---|
| **Problema** | ADR-0001 trata las decisiones arquitectónicas como pieza central de continuidad. Diluirlas en un tipo genérico pierde invariantes: alternativas consideradas, estado superseded, enlace a ADR files del repo. |
| **Impacto** | Las decisiones se vuelven «notas con etiqueta». |
| **Riesgo** | Medio. |
| **Alternativas** | (A) Mantener tipo Discriminated en Knowledge con schema estricto para Decision. (B) Agregado `Decision` separado. |
| **Recomendación** | **(A)** con schema obligatorio para Decision. No hace falta agregado separado aún. |

### OBS-25 — No hay modelo de conflicto entre conocimientos

| | |
|---|---|
| **Problema** | Dos `Accepted` pueden contradecirse. Solo existe Superseded lineal. |
| **Impacto** | El Workspace mentirá con seguridad. |
| **Riesgo** | Medio (crece con multiusuario). |
| **Recomendación** | Posponer implementación; documentar que Accepted no implica consistencia global. Futuro: `ConflictsWith`. |

### OBS-26 — DocumentReference vive en dos sitios

| | |
|---|---|
| **Problema** | DOMAIN-MODEL lo admite como binding o knowledge. |
| **Impacto** | Ambigüedad de implementación. |
| **Riesgo** | Bajo–medio. |
| **Recomendación** | Documentación externa = Binding `FileLocation`/`DocumentRoot`. Un documento *curado* o índice = Knowledge con referencia. No ambos para el mismo hecho. |

---

## 6. Agregados

### OBS-27 — ResourceBinding como agregado + repositorio propio es sobreingeniería temprana

| | |
|---|---|
| **Problema** | Un Workspace típico tendrá decenas de bindings, no millones. Separar agregado y `IResourceBindingRepository` complica transacciones (cambiar definición + binding). |
| **Impacto** | Más interfaces, más inconsistencias temporales. |
| **Riesgo** | Medio (complejidad). |
| **Recomendación** | **Bindings como colección dentro del agregado Workspace** en v1. Extraer agregado solo si el volumen o el ciclo de vida lo exigen. |

### OBS-28 — KnowledgeEntry como raíz de agregado por cada hecho escala mal conceptualmente

| | |
|---|---|
| **Problema** | Miles de raíces diminutas. Correcto para persistencia independiente, confuso como modelo mental. |
| **Impacto** | Repositorio correcto; lenguaje de equipo incorrecto («cargar el agregado»). |
| **Riesgo** | Bajo. |
| **Recomendación** | Hablar de **Knowledge base del Workspace** con entradas direccionables. Consistencia por entrada está bien. |

### OBS-29 — Conversation sí debe ser agregado

| | |
|---|---|
| **Problema** | Ninguno grave. Append-only de mensajes justifica límite propio. |
| **Impacto** | — |
| **Riesgo** | Bajo si se evita cargar todo el historial al activar Workspace. |
| **Recomendación** | Mantener. Carga perezosa de mensajes. |

### OBS-30 — EventRecord no es un agregado DDD

| | |
|---|---|
| **Problema** | Llamar agregado al journal confunde. Es un log append-only. |
| **Impacto** | Expectativas erróneas de invariantes. |
| **Riesgo** | Bajo. |
| **Recomendación** | Renombrar en documentación: **Event Journal**, no agregado. |

### OBS-31 — Tamaños máximos no acotados

| | |
|---|---|
| **Problema** | Sin límites orientativos: mensajes/conversación, knowledge entries, tamaño de journal. |
| **Impacto** | Sorpresas de memoria en desktop. |
| **Riesgo** | Medio. |
| **Recomendación** | Definir presupuestos blandos en principios/tests (p.ej. activar Workspace no carga conversaciones). Implementar límites duros más tarde. |

---

## 7. Evolución futura

| Escenario | ¿El diseño actual lo impide? | Observación |
|-----------|------------------------------|-------------|
| Múltiples proveedores IA | No | Si se adopta OBS-17 (providers globales). |
| Varios modelos simultáneos | Parcial | Conversation no modela turnos multi-modelo; no bloquea, pero habrá que extender Message metadata. |
| Agentes | Parcial | Sin `AgentSession`, se abusará de Conversation. Reservar el concepto; no implementar. |
| Ejecución distribuida | Sí, si se congela 1:1 | Corregir con OBS-01/02/03. |
| Colaboración multiusuario | Parcial | Falta Actor en eventos y políticas de conflicto (OBS-13, OBS-25). No impedir si envelope incluye actor. |
| Sincronización | Parcial | Decisión de persistencia documental pura la dificulta; SQLite operativo + journal la facilita. |
| Offline | Parcial | Readiness debe permitir Ready local con bindings remotos Deferred (no Failed global). |
| SAPIENS | Parcial | Requiere Runtime remoto + HostId. |
| Workspaces compartidos | Hoy cerrado | «No compartir bindings» es OK como v1, no como ley eterna. |

**Ningún escenario futuro exige congelar ahora su modelo completo.** Varios exigen **no tomar decisiones que los cierren**.

---

## 8. Complejidad y sobreingeniería

### OBS-32 — El Core propuesto parece un framework antes que un producto

| | |
|---|---|
| **Problema** | Carpetas `projections/`, `MemoryConsolidationService`, AuthorityPolicy, IdentityContext, 6 repositorios, 11 resource kinds, 10 readiness states — todo antes del primer test verde. |
| **Impacto** | Violación del principio 14 y de la filosofía del ROADMAP (pruebas arquitectónicas pequeñas). |
| **Riesgo** | **Alto.** |
| **Recomendación** | Recortar el perímetro de Fase 0.3 a lo mínimo ejecutable (ver plan abajo). |

### OBS-33 — IWorkspaceCatalog + IWorkspaceRepository

| | |
|---|---|
| **Problema** | Redundantes en v1. |
| **Recomendación** | Un solo `IWorkspaceRepository` con listado. |

### OBS-34 — ADR-0001 sigue pidiendo un «Workspace Engine» omnisciente

| | |
|---|---|
| **Problema** | Siete responsabilidades de motor vs agregado delgado. La tensión no se resolvió en la documentación canónica; solo en DOMAIN-MODEL. |
| **Impacto** | Un equipo puede implementar el Engine como dios. |
| **Riesgo** | Medio. |
| **Recomendación** | Enmendar ADR-0001 o aceptar ADR-0002 con texto que **reemplace** la sección Engine por casos de uso de aplicación. |

---

## Errores de ADR-0002 (intento de refutación)

| Decisión ADR-0002 | ¿Incorrecta? | Motivo |
|-------------------|--------------|--------|
| 1. Workspace + Runtime | Parcialmente | Correcta la separación; incorrecta la implicación 1:1 y la falta de RuntimeId. |
| 2. Agregados múltiples | Parcialmente | Conversation/Journal sí; Binding como agregado no. |
| 3. Binding vs Connection | Correcta | Pero kinds y activation prematuros. |
| 4. Conversación ≠ conocimiento | Correcta | Incompleta (working notes, orígenes no-chat, context snapshot). |
| 5. Dos ejes de estado | Correcta | Readiness sobreespecificado; Damaged mal ubicado. |
| 6. Archivos canónicos / SQLite índice | **Incorrecta como decisión vinculante** | Invierte integridad vs inspectabilidad. |
| 7. Journal + repos, no ES completo | Correcta | Pero hay que filtrar qué entra al journal. |
| 8. Reordenar ROADMAP | Correcta | Sigue sin aplicarse en ROADMAP.md. |

**No se ha demostrado que la tesis central sea falsa.** Se ha demostrado que varias decisiones derivadas son prematuras o peligrosas.

---

## Clasificación de observaciones

### Deben resolverse antes de implementar

1. **OBS-07 / OBS-08** — Revertir o suspender «archivos como fuente de verdad»; adoptar store operacional + export (decisión documentada, aunque la implementación SQLite se posponga).
2. **OBS-03** — `RuntimeId` obligatorio.
3. **OBS-02** — Documentar N runtimes; prohibir singleton de dominio.
4. **OBS-06 / OBS-05 / OBS-04** — Simplificar readiness; quitar Damaged/Suspended de v1.
5. **OBS-10 / OBS-12 / OBS-13** — Envelope mínimo; journal solo para fact events; mensajes fuera del journal.
6. **OBS-15 / OBS-16 / OBS-20** — Recortar ResourceKinds; secretos solo por referencia; activation lazy.
7. **OBS-17** — Providers de app vs preferencias de Workspace.
8. **OBS-27 / OBS-30 / OBS-33** — Bindings dentro de Workspace; journal ≠ agregado; un repositorio de catálogo.
9. **OBS-32** — Perímetro mínimo del Core (abajo).
10. **Actualizar ROADMAP** — Alinear numeración de fases con el trabajo real (dominio → core ejecutable → shell…).

### Pueden resolverse durante la implementación

- OBS-09 (layout en disco) — no implementar aún.
- OBS-11 (eliminar DomainEventRecorded).
- OBS-18 (MCP discovery) — cuando toque MCP.
- OBS-19 (glosario) — en código y docs cortos.
- OBS-21 (procedencias) — enum extensible desde el primer KnowledgeEntry.
- OBS-22 (WorkingNote) — tipo mínimo Draft/Scratch.
- OBS-24 (schema Decision).
- OBS-26 (DocumentReference).
- OBS-29 / OBS-31 (carga perezosa y presupuestos en tests).
- OBS-34 (enmienda ADR-0001).

### Pueden posponerse para versiones futuras

- OBS-01 entidad Host completa.
- OBS-14 sinks de telemetría avanzados.
- OBS-23 ContextSnapshot completo.
- OBS-25 conflictos entre knowledge.
- Multiusuario, sync, LiteFS, SAPIENS, workspaces compartidos, AgentSession rico.
- Suspended como estado de producto.

---

## ¿Es suficientemente sólido para comenzar?

**Sí, con condiciones.**

No aceptar ADR-0002 sin un **ADR-0002b / enmienda** que incorpore al menos:

- store operacional como verdad + export documental;
- RuntimeId + cardinalidad N;
- readiness reducido;
- bindings embebidos;
- journal filtrado + envelope;
- activation lazy;
- perímetro v1 reducido.

Con eso, el modelo aguanta diez años de evolución *sin* implementar el futuro ahora.

---

## Propuesta: Fase 0.3 — Core ejecutable en memoria

### Objetivo

Implementar un **Core ejecutable y testeable** que demuestre el lenguaje de dominio corregido, **sin**:

- GUI / VCL / FMX
- SQLite (todavía)
- MCP, proveedores IA reales, Docker, Git, plugins
- filesystem canónico

Todo el comportamiento se demuestra con **pruebas unitarias** y dobles en memoria.

### Alcance funcional mínimo

1. **Workspace**
   - Crear, renombrar, archivar.
   - `LifecycleStatus`: Draft | Active | Archived.
   - Definición: nombre, instrucciones, preferencias de modelo (`providerId` + `modelId` como strings opacos).
   - Colección de **bindings** embebida (solo `FileLocation` y quizá `GenericEndpoint` de prueba).

2. **WorkspaceRuntime**
   - `RuntimeId`.
   - Activate / Stop (sin Suspend).
   - `ReadinessStatus`: Inactive | Activating | Ready | Degraded | Failed.
   - Conectores **in-memory** que simulan éxito/fallo/degradación.
   - Conexión **lazy** por binding (API explícita `EnsureConnected(bindingId)`), no connect-all.

3. **Conversation + Message**
   - Crear conversación bajo Workspace.
   - Append mensaje.
   - No emitir `MessageAppended` al journal de dominio.

4. **KnowledgeEntry**
   - Crear (authored / promoted).
   - Estados: Draft | Accepted | Rejected | Superseded.
   - Tipo Discriminated mínimo: `Fact` | `Decision` | `Scratch`.
   - Promoción desde mensaje (referencia a conversationId/messageId).

5. **Event Journal**
   - Envelope mínimo.
   - Solo fact events: Workspace*, Binding*, Knowledge*, ConversationCreated/Archived, Runtime activation completed/failed (¿session event? — **log de sesión separado o flag `persist=false`**).
   - Implementación in-memory append-only + suscripción simple en proceso.

6. **Contratos**
   - `IWorkspaceRepository`
   - `IConversationRepository`
   - `IKnowledgeRepository`
   - `IEventJournal`
   - `IResourceConnector` (in-memory)
   - Sin `IResourceBindingRepository` separado.
   - Sin `IWorkspaceCatalog` separado.

### Estructura de código sugerida (mínima)

```text
src/core/
  domain/          # Workspace (+bindings), Conversation, KnowledgeEntry, events
  application/     # CreateWorkspace, ActivateWorkspace, AppendMessage, PromoteKnowledge, ...
  contracts/       # interfaces anteriores
tests/core/        # pruebas que ejercitan el Core de extremo a extremo en memoria
```

Evitar `projections/`, `MemoryConsolidationService`, AuthorityPolicy completa, IdentityContext rico.

### Casos de prueba que definen el éxito de la fase

1. Crear Workspace → aparece en listado → sobrevive en el repositorio in-memory tras «reiniciar» el proceso de app simulado (nuevo runtime de aplicación con mismo repo).
2. Activate falla si un binding marcado required y conectado bajo demanda falla; estado Failed o Degraded según política.
3. Dos runtimes distintos pueden existir en memoria para el mismo WorkspaceId (test de cardinalidad; el producto UI puede seguir abriendo uno).
4. Append de 10_000 mensajes no genera 10_000 eventos de dominio.
5. Promoción de un mensaje crea Knowledge Draft con procedencia; Accept lo hace consultable como conocimiento del Workspace.
6. Export **puerto** `IWorkspaceExporter` con implementación in-memory/string (no disco) demuestra que el modelo es exportable sin fijar SQLite ni filesystem.
7. Ningún test referencia VCL, SQLite, HTTP real ni MCP.

### Entregables

- Código del Core + tests verdes.
- Enmienda a ADR-0002 (o ADR-0003) con las correcciones aceptadas.
- Actualización breve de DOMAIN-MODEL (changelog de decisiones).
- ROADMAP realineado.

### Criterios de salida

- Un contribuidor puede ejecutar la suite de tests del Core sin IDE visual.
- El lenguaje de dominio usado en código coincide con el documento enmendado.
- Queda un puerto claro para una futura persistencia SQLite **sin** cambiar el dominio.

### Fuera de alcance explícito

- Shell nativo (puede avanzar en paralelo en otro equipo, contra interfaces falsas).
- Persistencia real.
- Streaming de modelos.
- Políticas de autoridad reales.
- Consolidación automática de memoria.

---

## Próximos pasos recomendados al equipo

1. Revisar este documento por equipos geográficos (async).
2. Votar qué observaciones «antes de implementar» se aceptan.
3. Publicar enmienda de ADR-0002.
4. Solo entonces abrir la Fase 0.3 de implementación.

---

## Relación con el ROADMAP publicado

El ROADMAP en repo aún define Fase 0.2 como «Primer proveedor» y 0.3 como «Conversaciones y persistencia». Ese orden **sigue contradiciendo** ADR-0001.

Propuesta de renumeración documental (sin ejecutarla aquí salvo acuerdo):

| Fase | Contenido |
|------|-----------|
| 0.1 | Modelo de dominio (hecho) |
| 0.2 | Revisión crítica (este documento) |
| 0.3 | Core ejecutable in-memory |
| 0.4 | Shell nativo |
| 0.5 | Persistencia operacional + export |
| 0.6 | Primer proveedor |
| … | … |

Hasta que el ROADMAP se actualice, este archivo es la fuente de verdad del significado de «Fase 0.2 / 0.3» para el trabajo de dominio.
