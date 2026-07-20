# NATIA — Notas de implementación Fase 0.3

- **Fecha:** 2026-07-20
- **Compilador de referencia:** Delphi 11.3 (Studio 22.0), `dcc32` / `dcc64`
- **Pruebas:** DUnitX (fuente en `%BDS%\source\DunitX`)

## Estructura creada

```text
src/core/
  domain/
  application/
  contracts/
  inmemory/
  Natia.Core.dpr
tests/core/
  Natia.Core.Tests.dpr
  Natia.Tests.*.pas
tools/
  build-and-test-win32.bat
  build-and-test-win64.bat
artifacts/          # salida de compilación (no fuente de verdad)
```

## Comandos de compilación y pruebas

Desde la raíz del repositorio (Windows, Delphi 11.3 instalado):

```bat
tools\build-and-test-win32.bat
tools\build-and-test-win64.bat
```

Equivalente manual (Win32):

```bat
call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
dcc32 -B -Eartifacts\win32 -N0artifacts\win32\dcu -Usrc\core\domain;src\core\contracts;src\core\application;src\core\inmemory src\core\Natia.Core.dpr
dcc32 -B -Eartifacts\win32 -N0artifacts\win32\dcu -U"%BDS%\source\DunitX;src\core\domain;src\core\contracts;src\core\application;src\core\inmemory;tests\core" -NSSystem;Xml;Xml.Win;System.Win;Data;Datasnap;Web;Soap;Winapi;DUnitX tests\core\Natia.Core.Tests.dpr
artifacts\win32\Natia.Core.Tests.exe
```

## Decisiones menores (no ADR)

1. **Factories de Knowledge:** `CreateFact` / `CreateScratch` / `CreateDecision` son class functions (evita warning W1029 de constructores con la misma firma).
2. **Propiedad de entidades en repos:** el repositorio in-memory posee las entidades (`OwnsValues`). Los casos de uso no liberan Workspaces/Conversations/Knowledge recuperados del repo. Los `WorkspaceRuntime` los posee el llamador.
3. **Export policy:** texto en memoria con definición, bindings, knowledge completo (resumen) y metadatos de conversación (sin volcar todos los mensajes).
4. **Failed en EnsureConnected:** un fallo de conexión degrada el Runtime; no fuerza `Failed` (política mínima).
5. **`.dproj`:** la compilación de referencia es vía `.dpr` + `dcc32`/`dcc64`. Los scripts en `tools/` son la vía documentada; se pueden abrir los `.dpr` en el IDE.

## Desviaciones respecto al plan

- No se añadió un proyecto de consola de demo aparte (las pruebas cubren el comportamiento).
- `ISessionEventSink` se añadió como contrato mínimo de prueba/observación (no es logging avanzado).

## Riesgos / deuda deliberada

- Sin `.dproj` MSBuild completo (IDE puede generarlos al abrir los `.dpr`).
- Guardia de dependencias lee `src/core/**/*.pas` desde disco (solo en el proyecto de tests).
- Runtime no se almacena en repositorio (correcto para 0.3; el producto deberá decidir tracking de runtimes activos más adelante).

## Resultado de verificación

| Plataforma | Core | Tests | Suite |
|------------|------|-------|-------|
| Win32 | OK | OK | 21 passed |
| Win64 | OK | OK | 21 passed |

Sin desviaciones respecto a ADR-0003.
