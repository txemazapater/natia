# ADR-0001: Arquitectura workspace-first

- Estado: Aceptado (parcialmente supersedido por [ADR-0004](0004-foundation-reconciliation-and-nemo.md))
- Fecha: 2026-07-20
- Nota 2026-07-22: la tesis anti-conversation-first se mantiene. La **raíz del producto** pasa a ser la **Initiative**; el Workspace sigue siendo la memoria operativa 1:1 de esa Initiative. Ver ADR-0004.

## Contexto

NATIA se describió inicialmente como un banco de trabajo de IA de escritorio nativo centrado en proveedores, conversaciones, herramientas y agentes.

Ese encuadre es insuficiente para proyectos y equipos de larga duración. Las conversaciones son vistas temporales sobre un cuerpo mucho mayor de estado del proyecto. Repositorios, documentación, decisiones arquitectónicas, roadmaps, herramientas, servicios, credenciales, permisos, historial de ejecución y discusiones humanas deben permanecer coherentes entre sesiones, personas y modelos de IA.

El problema práctico es la continuidad. Los usuarios dedican un esfuerzo significativo a reconstruir en qué punto está un proyecto, por qué se tomaron decisiones, qué servicios se requieren y qué ha cambiado desde su sesión anterior. El problema crece rápidamente a medida que se añaden más proyectos y más contribuidores.

## Decisión

NATIA usará una arquitectura workspace-first.

El Workspace, no la conversación, es la entidad principal del producto y la unidad central de persistencia, orquestación y experiencia de usuario.

Un Workspace poseerá o referenciará:

- identidad e instrucciones del proyecto;
- uno o más repositorios;
- documentación y Registros de Decisiones de Arquitectura;
- roadmap, hitos, tareas, riesgos y bloqueos;
- conversaciones y resúmenes;
- cambios históricos y actividad;
- proveedores de IA y preferencias de modelos;
- herramientas, extensiones y servidores MCP;
- conexiones a servicios locales y remotos;
- configuración de entorno y referencias a secretos;
- identidad activa, identidades delegadas y política de autoridad;
- estado de salud y readiness.

Abrir un Workspace se tratará como arrancar un entorno operativo. NATIA restaurará el estado relevante, verificará las capacidades requeridas y presentará la posición actual del proyecto antes de que el usuario tenga que reconstruirla manualmente.

La conversación seguirá siendo una interfaz de primera clase, pero será una superficie del Workspace entre otras.

## Consecuencias

### Positivas

- El conocimiento del proyecto sobrevive a conversaciones, modelos y contribuidores individuales.
- NATIA puede explicar en qué punto está un proyecto y qué ha cambiado.
- Las herramientas y servicios se convierten en dependencias explícitas del Workspace en lugar de capacidades transitorias del chat.
- Los permisos y las identidades activas pueden representarse y auditarse de forma coherente.
- Los equipos pueden compartir continuidad del proyecto y no solo archivos.
- La conciencia del roadmap y el razonamiento histórico se convierten en capacidades centrales.

### Costes y riesgos

- El estado del Workspace requiere un modelo de datos cuidadosamente versionado.
- La sincronización entre estado local, repositorios y servicios remotos será compleja.
- NATIA debe distinguir hechos de estado inferido del proyecto.
- La información histórica puede volverse ruidosa sin políticas de consolidación y retención.
- Credenciales, autoridad delegada y ejecución administrativa requieren límites de seguridad estrictos.
- La primera versión usable debe resistir convertirse en una plataforma de gestión de proyectos sobredimensionada.

## Dirección arquitectónica

Las capacidades de continuidad del Workspace se realizan como **casos de uso de aplicación** sobre el dominio, no como un motor monolítico dentro del agregado persistente. Ver [ADR-0003](0003-core-domain-refinement.md) y [DOMAIN-MODEL.md](../DOMAIN-MODEL.md).

Coordinación típica (repartida en application + infraestructura):

- ciclo de vida y readiness del Workspace / Runtime;
- consolidación de contexto y memoria;
- registro de recursos (bindings) y Connections en Runtime;
- contexto de identidad y permisos (fases posteriores);
- ingestión de actividad y detección de cambios;
- síntesis del estado del proyecto;
- conciencia del roadmap y las decisiones;
- exportación, backup y portabilidad.

Los subsistemas de proveedores, conversación, agentes y herramientas operan dentro de un contexto explícito de Workspace / Runtime.

## Alternativas rechazadas

### Aplicación conversation-first

Rechazada porque las conversaciones no representan adecuadamente el estado del proyecto y fomentan la reconstrucción repetida del contexto.

### Workspace basado solo en repositorio

Rechazada porque el conocimiento importante del proyecto también existe en servicios, conversaciones, decisiones, credenciales, estado de runtime y sistemas externos.

### Centro genérico de gestión de proyectos

Rechazado porque el propósito de NATIA es la continuidad operativa y la orquestación inteligente del trabajo, no reemplazar cada issue tracker o plataforma de planificación.

## Declaración orientativa

> NATIA existe para preservar la continuidad del pensamiento entre personas, tiempo y proyectos.
