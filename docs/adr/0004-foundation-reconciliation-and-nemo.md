# ADR-0004: Reconciliación foundation ↔ dominio Core, y naturaleza de NEMO

- Estado: Accepted
- Fecha: 2026-07-22
- Afecta: [ADR-0001](0001-workspace-first-architecture.md), [ADR-0003](0003-core-domain-refinement.md)
- Origen: `docs/foundation/` (00–07, 99) y el borrador histórico `01-NEMO.md` (eliminado)

## Contexto

Entre las fases 0.1–0.3, NATIA consolidó un Core **Workspace-first** ([ADR-0001](0001-workspace-first-architecture.md), [ADR-0003](0003-core-domain-refinement.md)):

- el Workspace es la entidad primaria del producto;
- conversación ≠ conocimiento;
- `WorkspaceRuntime` es efímero y tiene `RuntimeId`;
- Knowledge (`Fact` / `Decision` / `Scratch`) vive en el Workspace.

El 2026-07-22 se publicó un nuevo cuerpo fundacional en `docs/foundation/` que **eleva el modelo**:

- la unidad central de trabajo es la **Initiative**;
- el **Workspace** es el estado vivo / memoria operativa de una Initiative;
- el **Runtime** fundacional es un **bucle cognitivo** (Observe → … → Act), no una instancia de proceso;
- Capabilities vs Resources; Capability Graph; Orchestration;
- el Desktop es un espacio cognitivo Initiative-centric, no un gestor de ficheros.

Sin reconciliación explícita conviven dos lenguajes incompatibles:

1. «Workspace es la raíz» vs «Initiative es la raíz».
2. «Runtime» = ejecución del Core vs «Runtime» = cognición continua.
3. NEMO aparecía en UI (Sprint 0) y en un manifiesto corto (`01-NEMO.md`), pero **no** en el glosario fundacional nuevo.

Se necesita una decisión vinculante que preserve lo válido del Core ya implementado y alinee el vocabulario con la foundation.

## Decisión

### 1. Jerarquía conceptual vigente

```text
Person → Intention → Initiative → Workspace → Context / Knowledge / …
```

| Concepto | Rol |
|----------|-----|
| **Initiative** | Unidad central de trabajo intelectual. Raíz del modelo de producto. |
| **Workspace** | Estado vivo y memoria operativa de **exactamente una** Initiative. |
| **Conversation** | Superficie / evidencia, no raíz. |
| **Capability** | Capacidad abstracta (qué). |
| **Resource** | Implementación reemplazable (cómo). |

**Cardinalidad:** `Initiative 1 ──── 1 Workspace`.

ADR-0001 permanece **Accepted** en su tesis anti-chat («la conversación no es el producto»), pero queda **parcialmente supersedido** en un punto: la entidad primaria del producto pasa de *Workspace* a *Initiative*. El Workspace sigue siendo la unidad central de **persistencia operativa y continuidad**, subordinada a la Initiative.

### 2. Desambiguación de «Runtime»

Queda prohibido usar la palabra *Runtime* sin calificador en documentos de arquitectura.

| Término oficial | Significado | Origen |
|-----------------|-------------|--------|
| **Cognitive Runtime** | Bucle de comportamiento: observar, entender, contextualizar, razonar, planificar, actuar, aprender. No es una clase de dominio persistente. | `03_RUNTIME.MD` |
| **WorkspaceRuntime** | Instancia de ejecución de un Workspace (`RuntimeId`, readiness Inactive/Activating/Ready/Degraded/Failed). | ADR-0003 / Core |

En código Object Pascal:

- mantener `WorkspaceRuntime` / `RuntimeId` como están;
- **no** introducir un tipo llamado simplemente `Runtime` para el bucle cognitivo;
- el Cognitive Runtime se implementará más adelante como servicios/casos de uso de aplicación (orquestación), no como agregado paralelo al Workspace.

ADR-0003 sigue vigente para `WorkspaceRuntime`, bindings, Knowledge kinds, journal de Fact Events y perímetro del Core en memoria.

### 3. Qué se conserva del Core (Fase 0.3)

Sin reescritura inmediata del código:

- repositorios y contratos de Workspace, Conversation, Knowledge;
- separación Conversation ≠ Knowledge;
- Binding / Adapter / Connection / Provider / SecretReference;
- Fact Events + envelope; Session/Signal fuera del journal;
- exporter conceptual.

**Deuda aceptada:** el Core aún no modela `Initiative`. La siguiente evolución de dominio (no bloqueante para validación visual) debe introducir Initiative como contenedor 1:1 del Workspace, sin romper tests existentes más de lo necesario.

### 4. Naturaleza de NEMO

**NEMO se mantiene. No como entidad de dominio ni como producto separado. Como característica nombrada.**

Definición vinculante:

> **NEMO** es el nombre de la *característica* del Workspace (y por tanto de su Initiative) que preserva, explica y hace reutilizable la **evolución** del conocimiento: no solo *qué sabemos*, sino *cómo hemos llegado hasta aquí*.

Por tanto:

| NEMO **no** es | NEMO **sí** es |
|----------------|----------------|
| Una aplicación | Una propiedad / faceta del Workspace |
| Un servicio autónomo | Una superficie de producto (vista, exploración, timeline) |
| Una base de datos | El énfasis en camino, procedencia y experiencia |
| Un agregado raíz junto a Initiative | Marca de la Capability de memoria explicativa (`Remember` + relaciones + timeline) |
| Dueño del conocimiento | Vista y disciplina sobre Knowledge / Experience / Decision / Observation |

Consecuencias de modelado:

1. **No** existe entidad de dominio `Nemo` / `TNemo` como raíz.
2. El conocimiento sigue perteneciendo al **Workspace** (foundation + ADR-0003).
3. Las vistas UI etiquetadas «NEMO» (Sprint 0 y posteriores) son **navegadores de la faceta NEMO** del Workspace de la Initiative activa, no un silo.
4. En el Capability Graph, NEMO etiqueta el conjunto de capacidades centradas en memoria relacional y explicación (p. ej. Remember, Explain, relacionar Decision↔Observation), no un Resource concreto.
5. El borrador `docs/foundation/01-NEMO.md` queda **retirado** como documento fundacional; su tesis («NEMO es una propiedad») se **absorbe aquí** y en el glosario.

### 5. Actualización del glosario

Se añade al vocabulario oficial (debe reflejarse en `99_GLOSSARY.MD` en un cambio documental posterior o inmediato acompañante):

**NEMO** — Named characteristic of a Workspace: explanatory continuity of knowledge (“how we got here”), not a standalone system entity.

### 6. Desktop e Initiative

`04_DESKTOP.MD` prevalece como intención de experiencia: el Desktop es Initiative-centric.

El mockup Sprint 0 (shell tipo IDE) se considera **experimento visual válido**, no la forma final del modelo de navegación. Futuras iteraciones de UI deben hacer de la Initiative el eje primario; módulos como Chat, NEMO, Tools son superficies sobre esa Initiative / Workspace.

### 7. Orden de autoridad documental

Cuando haya conflicto:

1. `docs/foundation/` (filosofía y conceptos) + **este ADR** (decisiones de reconciliación)
2. ADR-0003 (perímetro y tipos del Core ejecutable)
3. ADR-0001 (anti-conversation-first), leído a través de ADR-0004
4. `DOMAIN-MODEL.md` / `ARCHITECTURE.md` / `ROADMAP.md` / `README.md` — **deben actualizarse** para alinear vocabulario; hasta entonces no contradicen este ADR si divergen: prevalece ADR-0004

## Consecuencias

### Positivas

- Un solo lenguaje para Initiative, Workspace y los dos «Runtime».
- El Core 0.3 no se tira: se enmarca bajo Initiative.
- NEMO conserva identidad de producto sin romper la ontología (Knowledge ∈ Workspace).
- El Capability Graph puede crecer sin inventar un microproducto NEMO.

### Costes y riesgos

- Deuda: código y DOMAIN-MODEL aún dicen Workspace-first sin Initiative.
- Riesgo de que la UI siga enseñando NEMO como “app” si no se disciplina el copy.
- Hay que actualizar README, ROADMAP (Sprint 0 / shell) y glosario para no mentir sobre el estado.

### Trabajo de seguimiento (no bloquea este ADR)

1. Añadir `Initiative` al DOMAIN-MODEL y, en una fase de Core posterior, al código.
2. Actualizar `99_GLOSSARY.MD` con NEMO y los dos Runtime.
3. Revisar ROADMAP / README (shell Sprint 0 ya existe).
4. En UI: subtítulos del estilo «NEMO · memoria del Workspace», nunca «NEMO · producto independiente».

## Alternativas consideradas

### A. Eliminar NEMO por completo

Rechazada. La tesis «cómo hemos llegado aquí» es diferenciadora y ya tiene tracción en UI y narrativa. Borrar el nombre pierde señal sin ganar claridad ontológica: bastaba con reclasificarlo.

### B. NEMO como agregado / bounded context dueño del Knowledge

Rechazada. Contradice foundation («Knowledge belongs to the Workspace») y duplicaría la raíz junto a Initiative.

### C. Mantener Workspace como entidad primaria del producto (solo renombrar Initiative = Project)

Rechazada. La foundation introduce Initiative precisamente para no atar el trabajo intelectual a repos o carpetas. Conservar Workspace-as-root invalidaría `01_MODEL.MD` / `05_WORKSPACE.MD`.

### D. Fusionar Cognitive Runtime y WorkspaceRuntime en un solo tipo

Rechazada. Mezclaría ciclo de vida de proceso/readiness con cognición continua; es exactamente la confusión que este ADR elimina.

## Referencias

- [00_FOUNDATION.MD](../foundation/00_FOUNDATION.MD)
- [01_MODEL.MD](../foundation/01_MODEL.MD)
- [02_ONTOLOGY.MD](../foundation/02_ONTOLOGY.MD)
- [03_RUNTIME.MD](../foundation/03_RUNTIME.MD)
- [04_DESKTOP.MD](../foundation/04_DESKTOP.MD)
- [05_WORKSPACE.MD](../foundation/05_WORKSPACE.MD)
- [06_ORCHESTRATION.MD](../foundation/06_ORCHESTRATION.MD)
- [07_CAPABILITY_GRAPH.MD](../foundation/07_CAPABILITY_GRAPH.MD)
- [99_GLOSSARY.MD](../foundation/99_GLOSSARY.MD)
- [ADR-0001](0001-workspace-first-architecture.md)
- [ADR-0003](0003-core-domain-refinement.md)
