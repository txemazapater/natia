# Registros de Decisiones de Arquitectura

NATIA usa Registros de Decisiones de Arquitectura (ADRs) para preservar el razonamiento detrás de elecciones técnicas importantes.

Debe crearse un ADR cuando una decisión:

- afecte a varios componentes;
- introduzca o rechace una dependencia importante;
- establezca un protocolo o contrato público;
- cambie el modelo de seguridad o aislamiento de procesos;
- cree una obligación de compatibilidad a largo plazo;
- sería difícil de entender más tarde solo a partir del código.

## Nomenclatura

Usar un número secuencial y un título conciso:

```text
0001-use-delphi-vcl-for-the-reference-windows-client.md
0002-use-sqlite-for-local-structured-state.md
```

## Valores de estado

- Proposed (Propuesto)
- Accepted (Aceptado)
- Superseded (Reemplazado)
- Rejected (Rechazado)
- Deprecated (Obsoleto)

## Plantilla

```markdown
# ADR-NNNN: Título de la decisión

- Status: Proposed
- Date: YYYY-MM-DD

## Context

¿Qué problema o restricción requiere una decisión?

## Decision

¿Qué se ha decidido?

## Consequences

¿Qué se vuelve más fácil, más difícil o queda permanentemente restringido?

## Alternatives considered

¿Qué alternativas realistas se evaluaron y por qué no se seleccionaron?
```

## Principio

Los ADR documentan decisiones, no discusiones. Deben ser concisos, explícitos y actualizarse cuando una decisión sea reemplazada.
