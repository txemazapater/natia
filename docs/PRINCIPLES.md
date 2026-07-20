# NATIA — Principios de ingeniería

Estos principios son restricciones arquitectónicas, no lenguaje de marketing. Cuando existan dos opciones de implementación, normalmente debe ganar la opción que mejor preserve estos principios.

## 1. Nativo primero

NATIA es una aplicación de escritorio, no una aplicación web distribuida como ejecutable de escritorio.

La implementación principal debe usar las capacidades nativas del sistema operativo y controles nativos cuando aporten un beneficio significativo. Se puede usar contenido web embebido para necesidades de presentación aisladas, pero no debe convertirse en el runtime de la aplicación.

## 2. Rápido por defecto

El tiempo de arranque, la latencia de interacción y el consumo de recursos en reposo son características del producto.

NATIA debe evitar inicializaciones innecesarias, escaneos en segundo plano y carga anticipada. Los componentes costosos deben cargarse solo cuando se necesiten y deben ser medibles.

## 3. La interfaz nunca debe esperar al modelo

La inferencia del modelo, el acceso a red, las operaciones de filesystem, la indexación y la ejecución de herramientas no deben bloquear el hilo de la interfaz de usuario.

Toda operación de larga duración debe soportar, cuando sea técnicamente posible:

- informe de progreso;
- cancelación;
- gestión de timeouts;
- informe estructurado de fallos;
- limpieza segura.

## 4. Preferir el aislamiento por procesos frente al fallo compartido

Los componentes no confiables, experimentales o propensos a fallos deben ejecutarse fuera del proceso principal.

Un plugin roto, una herramienta bloqueada o una conexión de modelo agotada no deben congelar ni terminar el shell de escritorio. Los workers deben ser supervisados, reiniciables y reemplazables.

## 5. Los proveedores son intercambiables

NATIA no debe asumir que un proveedor, endpoint o familia de modelos es permanente.

Las integraciones de proveedores deben implementarse detrás de contratos internos estables. Las APIs compatibles con OpenAI son un objetivo principal de interoperabilidad, mientras que las capacidades específicas de cada proveedor pueden exponerse mediante extensiones opcionales.

## 6. Local-first, no solo local

NATIA debe funcionar de forma natural con modelos locales, servicios autoalojados e infraestructura privada. Los proveedores en la nube siguen siendo opciones válidas, pero no deben ser necesarios para que la aplicación principal funcione.

La configuración del usuario, el historial y los metadatos del workspace deben permanecer disponibles localmente salvo que el usuario elija explícitamente lo contrario.

## 7. Autoridad explícita

Los agentes y las herramientas deben operar con permisos claramente definidos.

NATIA debe hacer visible:

- qué herramienta se está invocando;
- a qué recurso accederá;
- qué datos saldrán de la máquina;
- si una operación es de solo lectura o destructiva;
- si se requiere aprobación humana.

La comodidad no debe depender de privilegios invisibles.

## 8. Las extensiones no deben poseer el núcleo

El modelo de extensiones debe ser amplio pero controlado. Las extensiones deben comunicarse mediante protocolos documentados y normalmente deben ejecutarse fuera de proceso.

La aplicación principal debe seguir siendo usable sin extensiones de terceros, y una extensión debe poder eliminarse sin corromper el workspace.

## 9. La configuración debe ser comprensible

La configuración debe ser lo bastante simple para inspeccionarla, exportarla, respaldarla y repararla.

Los secretos deben usar las facilidades de credenciales del sistema operativo cuando estén disponibles. La configuración no secreta debe favorecer formatos documentados y portables.

## 10. La observabilidad es parte de la corrección

NATIA debe proporcionar registros estructurados para llamadas al modelo, ejecución de herramientas, ciclo de vida de workers y fallos.

El usuario debe poder entender qué ocurrió sin adjuntar un depurador. La información sensible debe redactarse por defecto.

## 11. Los datos pertenecen al usuario

Las conversaciones, prompts, workspaces e historial de ejecución deben ser exportables en formatos documentados.

NATIA debe evitar bases de datos opacas como única representación de información valiosa del usuario. El almacenamiento interno puede optimizarse, pero la exportación y la recuperación deben seguir siendo posibles.

## 12. El código abierto debe ser práctico

La disponibilidad del código fuente por sí sola no basta. El proyecto debe ser compilable, comprensible y extensible por personas fuera del equipo original.

La arquitectura debe mantener el núcleo reutilizable tan portable como sea razonablemente posible. Delphi puede proporcionar la experiencia principal de Windows, mientras que la compatibilidad con Free Pascal debe preservarse en componentes no visuales y orientados a protocolos cuando el coste sea aceptable.

## 13. Medir antes de optimizar, pero medir desde el principio

Los objetivos de rendimiento deben estar respaldados por mediciones repetibles:

- tiempo de arranque en frío y en caliente;
- uso de memoria en reposo;
- uso de memoria activo;
- uso de CPU en reposo;
- latencia de respuesta de la UI;
- tiempo de arranque y apagado de workers;
- tamaño de instalación.

NATIA debe compararse no solo con sus versiones anteriores, sino con los clientes de escritorio que pretende mejorar.

## 14. Sin plataforma accidental

NATIA puede crecer hasta convertirse en un ecosistema, pero toda abstracción debe resolver un problema demostrado.

El proyecto no debe inventar un protocolo, sistema de plugins, gestor de paquetes o lenguaje de scripting nuevo cuando ya exista un estándar abierto y adecuado.

## 15. El software de escritorio debe sentirse inmediato

La prueba final es experiencial:

- la ventana se abre rápido;
- escribir nunca se retrasa;
- la cancelación es inmediata;
- el progreso es visible;
- los errores son comprensibles;
- cerrar la aplicación se comporta de forma predecible.

NATIA debe sentirse como una herramienta de escritorio bien hecha antes de sentirse como un producto de IA.
