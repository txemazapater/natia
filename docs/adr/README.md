# Architecture Decision Records

NATIA uses Architecture Decision Records (ADRs) to preserve the reasoning behind important technical choices.

An ADR should be created when a decision:

- affects several components;
- introduces or rejects a major dependency;
- establishes a protocol or public contract;
- changes the security or process-isolation model;
- creates a long-term compatibility obligation;
- would be difficult to understand later from the code alone.

## Naming

Use a sequential number and a concise title:

```text
0001-use-delphi-vcl-for-the-reference-windows-client.md
0002-use-sqlite-for-local-structured-state.md
```

## Status values

- Proposed
- Accepted
- Superseded
- Rejected
- Deprecated

## Template

```markdown
# ADR-NNNN: Decision title

- Status: Proposed
- Date: YYYY-MM-DD

## Context

What problem or constraint requires a decision?

## Decision

What has been decided?

## Consequences

What becomes easier, harder or permanently constrained?

## Alternatives considered

Which realistic alternatives were evaluated and why were they not selected?
```

## Principle

ADRs document decisions, not discussions. They should be concise, explicit and updated when a decision is superseded.
