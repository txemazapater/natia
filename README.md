# NATIA

**NATIA** es un workspace operativo de IA de escritorio nativo, experimental y de código abierto.

NATIA parte de dos ideas simples:

> Un agente de IA debe comportarse como una aplicación de escritorio real.

> El Workspace es el producto. La conversación es una de sus interfaces.

La mayoría de los clientes de IA de escritorio actuales son aplicaciones web empaquetadas para el escritorio y centradas en conversaciones aisladas. NATIA toma el enfoque opuesto: partir del sistema operativo, construir una aplicación nativa rápida y fiable, y colocar modelos, agentes, herramientas, servicios y memoria del proyecto dentro de un Workspace persistente.

Un Workspace de NATIA debe saber en qué punto está un proyecto, qué ha cambiado, qué capacidades requiere y cuál puede ser el siguiente paso más valioso. Los usuarios no deberían tener que reconstruir el contexto cada vez que regresan.

## Dirección del proyecto

NATIA aspira a proporcionar:

- una interfaz nativa de Windows, responsiva;
- arranque rápido y bajo consumo de recursos en reposo;
- Workspaces persistentes, conscientes del proyecto;
- continuidad entre conversaciones, personas, modelos y el tiempo;
- ejecución multiproceso explícita y supervisión;
- compatibilidad con APIs estilo OpenAI sin dependencia de un proveedor;
- soporte para modelos locales, remotos y autoalojados;
- herramientas conectadas, servidores MCP y servicios locales o remotos;
- ejecución segura e inspectable bajo identidades y permisos explícitos;
- conciencia del roadmap, las decisiones y el estado del proyecto;
- un modelo de extensiones fuera de proceso;
- datos propiedad del usuario y exportables;
- una arquitectura abierta que pueda entenderse, reutilizarse y extenderse.

Se espera que el primer cliente de referencia use **Delphi y VCL** para construir una excelente aplicación nativa de Windows. NATIA está licenciado bajo la **MIT License**. Las herramientas de desarrollo propietarias no deben convertirse en excusa para una arquitectura propietaria: el núcleo portable, los protocolos, los esquemas y los componentes no visuales deben permanecer accesibles y compatibles con Free Pascal cuando sea razonable.

## Estado actual

NATIA ha completado la **[Fase 0.3 — Core ejecutable en memoria](docs/PHASE-0.3-EXECUTABLE-CORE.md)**.

El Core Object Pascal (Delphi 11.3) compila y se valida con DUnitX en Win32 y Win64, sin GUI, SQLite, red ni proveedores.

La siguiente fase prevista es el **shell nativo** (Fase 0.4), aún no iniciada.

### Compilar y probar el Core

Requisito: Delphi 11.3 (Studio 22.0).

```bat
tools\build-and-test-win32.bat
tools\build-and-test-win64.bat
```

Notas técnicas: [PHASE-0.3-IMPLEMENTATION-NOTES.md](docs/PHASE-0.3-IMPLEMENTATION-NOTES.md).

## Documentación

- [Manifiesto de NATIA](MANIFESTO.md)
- [Visión](docs/VISION.md)
- [Principios de ingeniería](docs/PRINCIPLES.md)
- [Arquitectura](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Modelo de dominio del Core](docs/DOMAIN-MODEL.md)
- [Revisión crítica del modelo](docs/DOMAIN-MODEL-REVIEW.md)
- [Fase 0.3 — Core ejecutable](docs/PHASE-0.3-EXECUTABLE-CORE.md)
- [Notas de implementación Fase 0.3](docs/PHASE-0.3-IMPLEMENTATION-NOTES.md)
- [Registros de decisiones de arquitectura](docs/adr/README.md)
- [ADR-0001: Arquitectura workspace-first](docs/adr/0001-workspace-first-architecture.md)
- [ADR-0002: Modelo de dominio (histórico, Superseded)](docs/adr/0002-workspace-domain-model.md)
- [ADR-0003: Refinamiento del dominio (vigente)](docs/adr/0003-core-domain-refinement.md)

## Principios fundamentales

- El Workspace es el producto.
- Preservar la continuidad del pensamiento.
- Nativo primero.
- Rápido por defecto.
- La interfaz nunca debe esperar al modelo.
- Preferir el aislamiento por procesos frente al fallo compartido.
- Los proveedores son intercambiables.
- Local-first, no solo local.
- Las herramientas operan con autoridad explícita.
- Las extensiones no deben poseer el núcleo.
- Los datos del usuario permanecen exportables.
- El rendimiento se mide desde el principio.

## Nombre

NATIA comenzó como **Native Integrated Agent**.

El nombre puede superar la expansión original a medida que el proyecto evolucione. NATIA es la identidad del producto; la arquitectura y los principios documentados definen lo que significa.

---

> NATIA existe para preservar la continuidad del pensamiento entre personas, tiempo y proyectos.
