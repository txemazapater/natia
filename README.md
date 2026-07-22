# NATIA

**NATIA** es un entorno de escritorio nativo, experimental y de código abierto para trabajo intelectual con inteligencia artificial.

NATIA no es un chatbot ni un IDE clásico. Es un **cognitive workspace**: personas, conocimiento y capacidades inteligentes colaboran alrededor de un propósito común.

Parte de tres ideas:

> La **Initiative** es la unidad de trabajo. El **Workspace** es su memoria viva.

> La conversación es una interfaz. La IA es una **capability**, no la arquitectura.

> **NEMO** nombra la faceta que preserva *cómo hemos llegado aquí*, no un producto aparte.

La mayoría de los clientes de IA de escritorio son aplicaciones web empaquetadas y centradas en chats aislados. NATIA parte del sistema operativo, construye una aplicación nativa rápida y sitúa modelos, agentes, herramientas y servicios como **Resources** reemplazables al servicio de Initiatives y Workspaces.

Una Initiative (y su Workspace) debe saber en qué punto está el trabajo, qué ha cambiado, qué capacidades hacen falta y cuál puede ser el siguiente paso valioso. El usuario no debería reconstruir el contexto cada vez que regresa.

## Dirección del proyecto

NATIA aspira a proporcionar:

- **NATIA Studio** — cliente de referencia nativo (Windows · Delphi · VCL), Initiative-centric;
- arranque rápido y bajo consumo en reposo;
- Initiatives con Workspace persistente (continuidad de conocimiento y decisiones);
- Continuidad NEMO: procedencia, camino y experiencia, no solo hechos sueltos;
- Capabilities orquestables y Resources intercambiables (Capability Graph);
- ejecución multiproceso explícita y supervisión;
- compatibilidad con APIs estilo OpenAI sin dependencia de un proveedor;
- modelos locales, remotos y autoalojados;
- herramientas, MCP y servicios locales o remotos bajo autoridad explícita;
- datos propiedad del usuario y exportables;
- arquitectura abierta, comprensible y extensible.

El concepto arquitectónico del entorno de interacción sigue siendo el **Desktop** ([04_DESKTOP.MD](docs/foundation/04_DESKTOP.MD)). **NATIA Studio** es el nombre del producto cliente que lo materializa.

Licencia **MIT**. Las herramientas propietarias no deben convertir la arquitectura en propietaria: el Core portable, protocolos, esquemas y código no visual deben permanecer accesibles y, cuando sea razonable, compatibles con Free Pascal.

## Estado actual

- **Fase 0.3** completada: [Core ejecutable en memoria](docs/PHASE-0.3-EXECUTABLE-CORE.md) (Delphi 11.3, DUnitX Win32/Win64).
- **NATIA Studio** (Sprint 0): embrión visual VCL en `src/apps/studio/Delphi/` (sin integraciones reales).
- **Foundation** vigente: [`docs/foundation/`](docs/foundation/).
- **Reconciliación** Core ↔ foundation: [ADR-0004](docs/adr/0004-foundation-reconciliation-and-nemo.md).

Vocabulario vinculante:

| Término | Significado breve |
|---------|-------------------|
| **Initiative** | Raíz del producto; cuerpo de trabajo intelectual |
| **Workspace** | Estado vivo / memoria operativa (1:1 con Initiative) |
| **NATIA Studio** | Cliente de referencia nativo (implementa el Desktop) |
| **WorkspaceRuntime** | Instancia de ejecución (`RuntimeId`, readiness) |
| **Cognitive Runtime** | Bucle Observe → … → Act (comportamiento, no agregado) |
| **NEMO** | Característica nombrada: continuidad explicativa del conocimiento |
| **Capability / Resource** | Qué se puede hacer / cómo se implementa |

El Core 0.3 aún modela Workspace sin entidad `Initiative` en código. **Cuándo entra Initiative en el Core es una decisión de fase pendiente** (no bloquea este vocabulario documental).

### Compilar y probar

```bat
tools\build-and-test-win32.bat
tools\build-and-test-win64.bat
src\apps\studio\Delphi\build-studio.bat
```

Notas: [PHASE-0.3-IMPLEMENTATION-NOTES.md](docs/PHASE-0.3-IMPLEMENTATION-NOTES.md).

## Documentación

- [Manifiesto](MANIFESTO.md)
- [Foundation](docs/foundation/00_FOUNDATION.MD) · [Model](docs/foundation/01_MODEL.MD) · [Ontology](docs/foundation/02_ONTOLOGY.MD) · [Glossary](docs/foundation/99_GLOSSARY.MD)
- [Visión](docs/VISION.md) · [Principios](docs/PRINCIPLES.md) · [Arquitectura](docs/ARCHITECTURE.md) · [Roadmap](docs/ROADMAP.md)
- [Modelo de dominio](docs/DOMAIN-MODEL.md) · [Revisión crítica](docs/DOMAIN-MODEL-REVIEW.md)
- [Fase 0.3](docs/PHASE-0.3-EXECUTABLE-CORE.md) · [Notas 0.3](docs/PHASE-0.3-IMPLEMENTATION-NOTES.md)
- [ADRs](docs/adr/README.md) · [ADR-0003 Core](docs/adr/0003-core-domain-refinement.md) · [ADR-0004 Reconciliación](docs/adr/0004-foundation-reconciliation-and-nemo.md)

## Principios fundamentales

- La Initiative es la raíz del trabajo; el Workspace es su memoria.
- Preservar la continuidad del pensamiento (NEMO).
- Nativo primero; rápido por defecto.
- La interfaz nunca debe esperar al modelo.
- Capabilities estables; Resources reemplazables.
- Preferir aislamiento por procesos frente al fallo compartido.
- Local-first, no solo local.
- Autoridad explícita; las extensiones no poseen el núcleo.
- Datos del usuario exportables; rendimiento medido desde el principio.

## Nombre

NATIA comenzó como **Native Integrated Agent**. El nombre puede superar esa expansión; la foundation y los ADR definen el significado.

---

> NATIA existe para aumentar el pensamiento humano y preservar la continuidad del conocimiento entre personas, tiempo e Initiatives.
