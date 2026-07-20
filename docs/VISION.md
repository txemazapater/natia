# NATIA — Visión

## Propósito

NATIA es un entorno de escritorio nativo de código abierto para trabajar con modelos de inteligencia artificial, agentes y herramientas.

Existe porque la mayoría de los clientes de IA de escritorio actuales no son verdaderas aplicaciones de escritorio. Son aplicaciones web empaquetadas para el escritorio, que suelen arrastrar un runtime de navegador, un runtime de JavaScript y varias capas de abstracción antes de que el usuario pueda interactuar con el sistema operativo.

NATIA toma el enfoque opuesto:

> Partir del sistema operativo e integrar la IA después.

El objetivo no es crear otra ventana de chat. El objetivo es construir una aplicación nativa rápida, duradera y extensible que pueda permanecer abierta todo el día, gestionar tareas de larga duración, coordinar múltiples procesos e interactuar de forma segura con la máquina local.

## El problema

Los clientes de IA de escritorio modernos sufren con frecuencia las mismas limitaciones:

- arranque lento;
- alto consumo de memoria en reposo;
- runtimes de navegador duplicados;
- integración débil con el sistema operativo;
- ejecución en segundo plano frágil;
- aislamiento de procesos limitado;
- dependencia de un proveedor;
- modelos de extensión monolíticos;
- interfaces diseñadas en torno al chat en lugar del trabajo.

Estas concesiones pueden ser razonables para un desarrollo de producto rápido, pero no deberían definir la forma final del software de IA de escritorio.

## La propuesta

NATIA será un banco de trabajo de IA nativo con:

- arranque inmediato y bajo consumo de recursos en reposo;
- interfaz de usuario nativa y responsiva;
- ejecución multiproceso explícita;
- respuestas del modelo en streaming sin bloquear la interfaz;
- soporte para modelos locales, remotos y autoalojados;
- compatibilidad de primera clase con APIs estilo OpenAI;
- herramientas y agentes reemplazables e inspectables;
- acceso seguro a las capacidades del sistema operativo;
- workspaces y conversaciones persistentes;
- un modelo de extensiones que no comprometa el proceso principal;
- código fuente completo disponible y desarrollo orientado a la comunidad.

## Qué es NATIA

NATIA está pensado para convertirse en:

- un cliente de escritorio para múltiples proveedores de IA;
- un host para agentes locales y remotos;
- un banco de trabajo para herramientas, prompts, contextos y flujos de trabajo;
- un supervisor de tareas de IA en segundo plano;
- una implementación de referencia de software de IA nativo eficiente;
- una base reutilizable para asistentes de escritorio especializados.

## Qué no es NATIA

NATIA no está pensado para ser:

- otro envoltorio de navegador;
- un reemplazo de Electron construido con las mismas suposiciones arquitectónicas;
- un cliente de un solo proveedor;
- una plataforma de entrenamiento de modelos;
- un sistema autónomo con acceso irrestricto al ordenador;
- una colección de prompts ocultos presentada como producto;
- un protocolo propietario nuevo creado solo para encerrar a los usuarios en la aplicación.

## Nativo significa más que compilado

Para NATIA, el software nativo significa:

- usar el sistema operativo de forma deliberada;
- tratar procesos, hilos, archivos, sockets y servicios como recursos de primera clase;
- integrarse con el escritorio sin embeber un navegador completo;
- respetar las convenciones de la plataforma;
- permanecer responsivo bajo carga;
- fallar en componentes aislados en lugar de congelarse por completo;
- proporcionar instalación, ejecución y eliminación predecibles.

Un binario compilado no basta. El comportamiento nativo es el objetivo real.

## Abierto por diseño

NATIA debe seguir siendo útil sin depender de una sola empresa, nube o familia de modelos.

El proyecto favorecerá:

- protocolos abiertos;
- interfaces documentadas;
- proveedores reemplazables;
- datos de usuario exportables;
- configuración legible por humanos cuando sea práctico;
- registros de ejecución transparentes;
- mecanismos de extensión permisivos;
- compatibilidad con modelos abiertos e infraestructura autoalojada.

Las APIs compatibles con OpenAI se tratan como una convención de interoperabilidad, no como una dependencia de OpenAI.

## Ambición a largo plazo

NATIA debería demostrar que el software de IA de escritorio moderno puede ser:

- más ligero;
- más rápido;
- más seguro;
- más transparente;
- más extensible;
- más respetuoso con el sistema operativo;
- y más agradable de usar que la generación actual de clientes web empaquetados.

El proyecto tendrá éxito cuando los usuarios dejen de pensar en NATIA como un cliente de chat de IA y empiecen a tratarlo como una herramienta de escritorio normal y fiable.

---

> La IA nativa merece software nativo.
