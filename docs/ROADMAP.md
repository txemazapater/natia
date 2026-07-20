# NATIA — Roadmap

## Filosofía del roadmap

NATIA se desarrollará en pequeñas pruebas arquitectónicas. Cada fase debe dejar el proyecto usable, medible y más fácil de extender.

El roadmap evita deliberadamente empezar con agentes autónomos, marketplaces complejos de plugins o un IDE completo. La primera prioridad es demostrar que una aplicación de IA de escritorio nativa puede ser rápida, estable y agradable de usar.

## Fase 0 — Fundación

### Objetivo

Convertir la idea en un proyecto con restricciones explícitas y una base de desarrollo reproducible.

### Entregables

- visión y principios;
- arquitectura inicial;
- selección de licencia;
- guías de contribución;
- convenciones de codificación;
- proceso inicial de Registros de Decisiones de Arquitectura;
- esqueleto del proyecto Delphi;
- instrucciones de compilación;
- comprobaciones automatizadas básicas cuando sea práctico;
- plan de medición de rendimiento.

### Criterios de salida

Un nuevo contribuidor puede entender qué es NATIA, compilar la aplicación vacía y saber cómo se registran las decisiones arquitectónicas.

## Fase 0.1 — Shell nativo

### Objetivo

Demostrar la experiencia de escritorio antes de añadir complejidad de IA.

### Entregables

- ejecutable nativo de Windows;
- ventana principal y esqueleto de navegación;
- almacenamiento de ajustes;
- registro estructurado;
- gestión del ciclo de vida de la aplicación;
- vista de diagnósticos;
- mediciones de arranque y recursos en reposo;
- instalación limpia y ejecución portable de desarrollo.

### Criterios de salida

La aplicación arranca rápido, se cierra de forma predecible y permanece en reposo sin actividad innecesaria de CPU.

## Fase 0.2 — Primer proveedor

### Objetivo

Conectar NATIA a un endpoint genérico compatible con OpenAI.

### Entregables

- configuración de proveedor;
- referencia segura a clave API;
- prueba de conexión;
- listado de modelos;
- petición de chat básica;
- salida en streaming;
- errores normalizados;
- cancelación inmediata;
- diagnósticos de petición y respuesta con redacción de secretos.

### Objetivos iniciales

- Ollama;
- LM Studio;
- endpoints autoalojados compatibles con OpenAI;
- opcionalmente OpenAI mismo para pruebas de interoperabilidad.

### Criterios de salida

Un usuario puede configurar un endpoint, seleccionar un modelo, enviar un prompt, ver la respuesta en streaming y cancelarla sin congelar la interfaz.

## Fase 0.3 — Conversaciones y persistencia

### Objetivo

Hacer NATIA útil como cliente diario fiable.

### Entregables

- persistencia SQLite;
- creación y renombrado de conversaciones;
- historial de mensajes;
- metadatos de proveedor/modelo por conversación;
- estrategia de renderizado Markdown;
- copia y exportación;
- recuperación tras apagado anormal;
- ubicación de datos configurable.

### Criterios de salida

Las conversaciones sobreviven al reinicio, pueden exportarse y no dependen de una cuenta remota.

## Fase 0.4 — Supervisión de tareas

### Objetivo

Establecer el modelo de ejecución para el trabajo en segundo plano.

### Entregables

- registro de tareas;
- estados de tarea y eventos de progreso;
- tokens de cancelación;
- timeouts;
- lanzamiento y supervisión de procesos worker;
- heartbeat o informe de salud;
- reinicio de worker tras fallo;
- vista de actividad de tareas.

### Criterios de salida

Un worker bloqueado o caído deliberadamente no congela ni termina NATIA y puede recuperarse de forma visible.

## Fase 0.5 — Primera herramienta

### Objetivo

Demostrar interacción segura modelo-herramienta.

### Entregables

- manifiesto y esquema de herramienta;
- registro de herramientas;
- herramienta de referencia de solo lectura;
- flujo de aprobación del usuario;
- ejecución en un proceso aislado;
- entrada, salida y tiempo de ejecución acotados;
- registro de auditoría;
- resultado de herramienta devuelto al modelo.

### Herramienta de referencia sugerida

Un lector de filesystem restringido a una carpeta aprobada por el usuario.

### Criterios de salida

El modelo puede solicitar una herramienta declarada, el usuario puede inspeccionarla y aprobarla, y la ejecución permanece aislada y auditable.

## Fase 0.6 — Workspaces

### Objetivo

Ir más allá de chats aislados hacia contextos de trabajo persistentes.

### Entregables

- creación de workspace;
- instrucciones del workspace;
- carpetas permitidas;
- modelo/proveedor preferido;
- herramientas habilitadas;
- definición de workspace no secreta exportable;
- conversaciones e historial por workspace.

### Criterios de salida

Un usuario puede mantener entornos distintos para desarrollo, administración de sistemas, documentación u otra actividad recurrente.

## Fase 0.7 — Integración MCP

### Objetivo

Permitir que NATIA consuma ecosistemas de herramientas abiertos existentes sin convertir MCP en la arquitectura interna.

### Entregables

- configuración de servidor MCP;
- transporte stdio;
- supervisión del ciclo de vida del servidor;
- descubrimiento de herramientas;
- presentación de capacidades;
- mapeo de permisos;
- registros y gestión de fallos;
- transporte remoto opcional tras estabilizar el modelo local.

### Criterios de salida

Al menos un servidor MCP externo puede iniciarse, inspeccionarse y usarse sin comprometer el proceso principal.

## Fase 0.8 — Bucle de agente

### Objetivo

Introducir ejecución controlada en múltiples pasos.

### Entregables

- estado explícito de sesión de agente;
- límites máximos de iteración;
- presupuestos de tokens y tiempo;
- bucle de llamadas a herramientas;
- política de aprobación humana;
- semántica de parar, pausar y reanudar;
- resumen de razonamiento o traza de acciones visible sin exponer internals ocultos del modelo;
- informe final de ejecución.

### Criterios de salida

Un agente puede completar una tarea acotada de varios pasos mientras el usuario conserva el control y puede entender cada acción externa.

## Fase 0.9 — SDK de extensiones

### Objetivo

Hacer NATIA extensible sin hacer frágil el proceso principal.

### Entregables

- especificación del manifiesto de extensión;
- protocolo de extensión versionado;
- ejemplo de extensión de proveedor;
- ejemplo de extensión de herramienta;
- contrato de ciclo de vida de procesos;
- declaraciones de capacidades y permisos;
- documentación para desarrolladores;
- política de compatibilidad.

### Criterios de salida

Un tercero puede construir y ejecutar una extensión pequeña sin modificar el árbol de código fuente de NATIA ni cargar código arbitrario en el proceso de UI.

## Fase 1.0 — Primera versión pública

### Objetivo

Entregar un banco de trabajo de IA nativo estable, adecuado para uso diario real.

### Cualidades requeridas

- arranque rápido y medible;
- flujo de conversación estable;
- soporte de proveedores locales y remotos;
- persistencia recuperable;
- herramientas y workers supervisados;
- workspaces;
- soporte MCP;
- agentes controlados básicos;
- ruta de extensión documentada;
- instalador y paquete portable;
- documentación de migración y respaldo;
- documentación de seguridad y privacidad.

## Direcciones post-1.0

Trabajo futuro posible, sujeto a evidencia y demanda de la comunidad:

- contextos más ricos de documentos e imágenes;
- índices semánticos locales y RAG;
- flujos de trabajo de terminal y desarrollo;
- integración con Git;
- tareas programadas y en segundo plano;
- workers NATIA remotos;
- ediciones especializadas o paquetes de workspace;
- experimentos con Lazarus o clientes alternativos;
- mejoras de accesibilidad;
- política empresarial y despliegue;
- descubrimiento de extensiones y paquetes firmados;
- colaboración y sincronización opcional.

## Funcionalidades deliberadamente aplazadas

Lo siguiente no es prioridad inicial:

- entrenar o afinar modelos;
- un runtime de modelos propio;
- operación autónoma irrestricta;
- funcionalidad de IDE embebida basada en navegador;
- requisito de cuenta en la nube propietaria;
- marketplace de extensiones antes de que el protocolo de extensión sea estable;
- paridad completa de UI multiplataforma;
- reemplazar estándares establecidos sin una necesidad demostrada.

## Definición de progreso

Una fase no está completa porque exista código. Está completa cuando:

- la funcionalidad se comporta de forma predecible;
- los modos de fallo son visibles;
- el uso de recursos está medido;
- la documentación coincide con la realidad;
- los datos del usuario pueden recuperarse;
- la arquitectura permanece más simple que antes.
