# NATIA — Arquitectura inicial

## Estado

Este documento describe la dirección arquitectónica inicial. Es intencionalmente consciente de la tecnología, pero aún no es una especificación de implementación. Las decisiones que se vuelvan vinculantes deben registrarse después como Registros de Decisiones de Arquitectura en `docs/adr/`.

## Objetivos arquitectónicos

NATIA debe proporcionar:

- un shell de escritorio nativo e inmediatamente responsivo;
- acceso no bloqueante a modelos de IA locales y remotos;
- supervisión explícita del trabajo en segundo plano;
- aislamiento de extensiones y operaciones de riesgo;
- independencia de proveedores;
- persistencia local transparente y recuperable;
- un camino estable desde una primera versión pequeña hasta un banco de trabajo de agentes completo.

## Forma propuesta del sistema

```text
+------------------------------------------------------------+
| NATIA Desktop                                              |
|                                                            |
|  UI nativa                                                 |
|  - workspaces                                              |
|  - conversaciones                                          |
|  - selección de modelo y proveedor                         |
|  - actividad, aprobaciones y diagnósticos                  |
+-------------------------------+----------------------------+
                                |
                                | comandos/eventos internos tipados
                                v
+------------------------------------------------------------+
| NATIA Core                                                 |
|                                                            |
|  session manager       registro de proveedores             |
|  coordinador de agentes política de permisos               |
|  supervisor de tareas  persistencia                        |
|  bus de eventos        diagnósticos                        |
+----------+------------------+-------------------+-----------+
           |                  |                   |
           v                  v                   v
+----------------+  +------------------+  +-------------------+
| Model workers  |  | Tool workers     |  | Extension hosts   |
|                |  |                  |  |                   |
| OpenAI API     |  | filesystem       |  | servidores MCP    |
| Ollama         |  | shell/proceso    |  | plugins externos  |
| LM Studio      |  | Git              |  | apps especializadas|
| autoalojado    |  | HTTP/base de datos| |                   |
+----------------+  +------------------+  +-------------------+
```

## 1. Shell de escritorio

El shell de escritorio posee el ciclo de vida visible de la aplicación y la experiencia de usuario nativa.

Responsabilidades:

- arranque y apagado de la aplicación;
- ventanas, navegación y controles nativos;
- comportamiento de teclado y accesibilidad;
- presentación de conversaciones y salida en streaming;
- selección de workspace;
- aprobaciones del usuario;
- estado de tareas y workers;
- diagnósticos orientados al usuario.

El shell no debe ejecutar inferencia del modelo, indexación ni herramientas sin límite en su hilo de UI.

### Plataforma inicial

El primer cliente de referencia debe orientarse a Windows usando Delphi y VCL. Esta es una decisión de producto deliberada: el primer objetivo es construir una excelente aplicación nativa de Windows en lugar de un shell multiplataforma comprometido.

La compatibilidad multiplataforma debe perseguirse a nivel de protocolo y bibliotecas del núcleo antes de prometer múltiples clientes gráficos.

## 2. Core

El núcleo coordina el estado de la aplicación sin depender directamente de controles visuales.

Responsabilidades candidatas:

- registro de proveedores y modelos;
- ciclo de vida de conversaciones y workspaces;
- construcción de peticiones;
- normalización de eventos en streaming;
- coordinación del bucle de agente;
- cancelación de tareas y política de timeouts;
- evaluación de permisos de herramientas;
- supervisión de workers;
- orquestación de persistencia;
- registro estructurado.

El núcleo debe usar interfaces y estructuras de datos simples que puedan probarse sin iniciar la GUI.

## 3. Proveedores

Un proveedor es un adaptador entre NATIA y un servicio de modelos.

Un contrato mínimo de proveedor debería cubrir eventualmente:

- prueba de conexión;
- descubrimiento de modelos;
- descripción de capacidades;
- creación de chat o respuesta;
- streaming de tokens/eventos;
- cancelación;
- embeddings cuando estén soportados;
- intercambio de llamadas a herramientas;
- informe normalizado de errores.

Proveedores de ejemplo:

- endpoint genérico compatible con OpenAI;
- OpenAI;
- Ollama;
- LM Studio;
- SAPIENS u otra pasarela autoalojada;
- adaptadores específicos de proveedor añadidos después.

NATIA no debe reducir todos los proveedores al mínimo común denominador. Debe coexistir una línea base compartida con capacidades opcionales descubribles.

## 4. Tareas, hilos y procesos

NATIA debe distinguir claramente tres conceptos.

### Tareas de UI

Operaciones pequeñas que actualizan el estado de presentación. Permanecen en el hilo principal y deben completarse rápido.

### Tareas en segundo plano

Operaciones acotadas adecuadas para hilos worker, como parsear una respuesta, leer configuración o transformar datos.

### Procesos worker

Operaciones de larga duración, no confiables, intensivas en memoria o propensas a fallos, incluyendo:

- ejecución de herramientas;
- indexación de repositorios;
- procesamiento de documentos;
- sesiones de shell;
- extensiones de terceros;
- servidores MCP;
- puentes especializados a modelos locales.

El proceso principal actúa como supervisor. Los workers deben exponer señales de salud, ciclo de vida y cancelación. Un worker fallido debe poder reiniciarse sin reiniciar la aplicación.

## 5. Comunicación entre procesos

Aún no se ha seleccionado un mecanismo IPC final.

Candidatos para la implementación de referencia en Windows:

- named pipes;
- sockets TCP locales;
- entrada/salida estándar para herramientas ejecutables simples;
- HTTP o WebSocket para servicios alojados de forma independiente;
- MCP cuando su semántica encaje con la integración.

El protocolo interno elegido debe soportar:

- identificadores de petición;
- eventos asíncronos;
- streaming;
- cancelación;
- heartbeats;
- errores estructurados;
- negociación de versión;
- tamaños de mensaje acotados.

No se requiere automáticamente un protocolo binario. La simplicidad y la inspectabilidad son importantes durante las primeras fases.

## 6. Herramientas y agentes

Una herramienta es una capacidad declarada con un esquema, requisitos de permisos y una implementación de ejecución.

Un agente es un coordinador que puede combinar interacción con el modelo, herramientas, estado y política para perseguir una tarea.

Estos conceptos deben permanecer separados. Una herramienta debe poder invocarse sin requerir un bucle de agente completamente autónomo, y un agente no debe recibir acceso irrestricto al sistema solo porque un modelo lo haya solicitado.

Cada herramienta debe declarar al menos:

- identificador y versión;
- propósito legible por humanos;
- esquema de entrada y salida;
- clasificación lectura/escritura/destructiva;
- permisos requeridos;
- política de timeout;
- host de ejecución;
- representación de auditoría.

## 7. Extensiones

El límite preferido de extensión es fuera de proceso.

Una extensión puede proporcionar:

- herramientas;
- adaptadores de proveedores;
- importadores y exportadores;
- fuentes de contexto;
- workers especializados;
- contribuciones de UI mediante una superficie de extensión restringida.

Los plugins nativos en DLL cargados en el proceso principal no deben ser el mecanismo por defecto porque comparten memoria, privilegios y estado de fallo con la aplicación.

Un paquete de extensión futuro puede incluir:

```text
extension/
  manifest.json
  bin/
  schemas/
  resources/
  README.md
```

El formato de paquete y descubrimiento permanece sin decidir.

## 8. Persistencia

SQLite es el candidato principal para el estado local estructurado.

Datos potencialmente almacenados:

- proveedores y configuración no secreta;
- caché de metadatos de modelos;
- workspaces;
- conversaciones y mensajes;
- registros de ejecución de herramientas;
- estado de tareas;
- registro de extensiones;
- ajustes de aplicación.

Los secretos no deben almacenarse en texto plano en la base de datos. En Windows, debe considerarse el administrador de credenciales o almacenamiento respaldado por DPAPI.

Los datos importantes del usuario deben ser exportables en formatos documentados como JSON, Markdown o JSON Lines.

## 9. Workspaces

Un workspace agrupa el contexto requerido para un tipo de trabajo.

Puede contener:

- instrucciones;
- proveedores y modelos preferidos;
- carpetas permitidas;
- herramientas habilitadas;
- configuración de extensiones;
- servidores MCP;
- historial de conversaciones;
- política de aprobación;
- variables de entorno o referencias a secretos.

Los workspaces deben ser portables cuando sea posible, mientras que las rutas específicas de la máquina y los secretos permanezcan claramente separados.

## 10. Modelo de seguridad

NATIA asume que la salida del modelo es entrada no confiable.

El diseño de seguridad debe incluir:

- ejecución con mínimo privilegio;
- ámbitos explícitos de carpetas y recursos;
- puertas de aprobación para acciones destructivas;
- separación entre capacidades de lectura y escritura;
- redacción de secretos;
- registros de auditoría;
- tiempo de ejecución y salida acotados;
- controles de terminación de procesos;
- indicación clara de transmisión de datos remotos.

Un sandbox futuro puede mejorar el aislamiento, pero la primera línea de defensa es un modelo de autoridad pequeño, explícito e inspectable.

## 11. Propuesta de estructura de código fuente

```text
/
  README.md
  LICENSE
  CONTRIBUTING.md
  docs/
    VISION.md
    PRINCIPLES.md
    ARCHITECTURE.md
    ROADMAP.md
    adr/
  src/
    core/
    protocols/
    providers/
    persistence/
    platform/
      windows/
    ui/
      vcl/
    workers/
  tests/
  tools/
```

Este layout es provisional. El núcleo portable debe evitar dependencias visuales y aislar el código específico de plataforma.

## 12. Primera prueba arquitectónica

El primer ejecutable debe demostrar la arquitectura más que el número de funcionalidades.

Debe demostrar:

1. arranque nativo;
2. configuración de proveedor;
3. descubrimiento de modelos;
4. salida de conversación en streaming;
5. cancelación inmediata;
6. comportamiento de UI no bloqueante;
7. persistencia local;
8. una herramienta externa aislada;
9. fallo y recuperación de worker;
10. uso de recursos medible.

Si estos cimientos son correctos, se pueden añadir agentes, proveedores y herramientas adicionales sin convertir NATIA en un monolito.
