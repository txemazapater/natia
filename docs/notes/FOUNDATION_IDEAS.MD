# FOUNDATION IDEAS

**Status:** Working Notes  
**Last updated:** 2026-07-22

---

# Purpose

This document preserves ideas, hypotheses and unresolved questions that emerged while defining the NATIA foundation.

It is not an authoritative architectural document.

Nothing written here becomes part of the NATIA model until it is validated and incorporated into the Foundation, an ADR, the Product Vision or the Roadmap.

---

# 1. Consolidated Decisions

These ideas have already been incorporated into the current conceptual model or accepted through ADR-0004.

## Initiative as Product Root

NATIA is organized around Initiatives rather than repositories, folders, conversations or software projects.

An Initiative represents a coherent body of intellectual work pursued over time.

The Initiative is the root of the product model.

---

## Intention and Initiative Are Different

An Intention belongs to a Person.

It expresses motivation:

> Why does this matter?

An Initiative belongs to the NATIA model.

It represents organized work:

> What meaningful body of work are we pursuing?

One Intention may originate several Initiatives.

Different people may participate in the same Initiative with different personal intentions.

---

## One Initiative, One Workspace

Every Initiative owns exactly one Workspace.

The Workspace is its living operational memory and current state of understanding.

The Initiative provides identity and purpose.

The Workspace provides continuity.

---

## Conversation Is Not the Product

A conversation is an interaction surface and a source of evidence.

It is not the root of knowledge.

Knowledge belongs to the Workspace.

---

## Cognitive Runtime and WorkspaceRuntime Are Different

The term Runtime must always be qualified.

- Cognitive Runtime describes NATIA's continuous cognitive behaviour.
- WorkspaceRuntime describes a technical execution instance of a Workspace.

---

## NEMO Is a Workspace Characteristic

NEMO is not an application, service, database or domain root.

NEMO names the explanatory continuity of knowledge:

> Not only what we know, but how we got here.

It may be represented through dedicated Desktop views, timelines and exploration tools.

---

## Orchestration Is a Process

Orchestration coordinates capabilities.

It is not itself intelligence.

It does not own reasoning, memory or knowledge.

---

## Capabilities and Resources Are Separate

Capabilities describe what NATIA can achieve.

Resources describe how those capabilities are implemented.

Resources are replaceable.

Capabilities remain conceptually stable.

---

# 2. Core Product Hypotheses

These ideas are promising but still require validation.

## NATIA as an Operational Model of an Engineer's Mind

NATIA may be understood as an operational approximation of how an engineer works:

- maintaining several active lines of thought;
- relating present work to previous experience;
- preserving rejected alternatives;
- moving between analysis and execution;
- selecting tools according to the problem;
- recovering context after interruptions;
- transforming observations into decisions;
- learning from results.

This is a product hypothesis, not a claim that NATIA reproduces human cognition.

The model should imitate useful engineering behaviour, not attempt to simulate the biological brain.

---

## NATIA May Not Need a Project Entity

Traditional development environments organize work around Projects.

NATIA may not require Project as a native conceptual entity.

An Initiative may span:

- multiple repositories;
- multiple products;
- several technologies;
- documentation;
- experiments;
- conversations;
- infrastructure;
- external systems.

A Project may therefore be treated as an external Resource or organizational representation rather than a NATIA root concept.

### Open question

Should Project exist as:

1. an external Resource;
2. a user-defined organizational label;
3. a subordinate entity of an Initiative;
4. no native concept at all?

---

## The Desktop May Become NATIA Studio

Desktop describes where the reference client runs.

Studio describes what the user does there.

The native application may eventually be named:

> NATIA Studio

This would position the product as an environment for investigation, design, experimentation and creation rather than merely a desktop client.

The architectural document remains `04_DESKTOP.MD`.

The product name is not yet decided.

---

## Opening NATIA Means Recovering a Mental State

Traditional IDEs open files and projects.

NATIA should recover the operational state of an Initiative:

- current objectives;
- unresolved questions;
- recent decisions;
- active hypotheses;
- pending actions;
- relevant knowledge;
- available capabilities;
- recent changes;
- possible next steps.

The user should resume thinking rather than reconstruct context.

---

# 3. Capability Graph Hypotheses

## The Graph Is Traversed from a Need

Orchestration should not begin by asking:

> Which tool should I invoke?

It should begin with:

> What needs to be achieved?

Examples:

- understand;
- compare;
- decide;
- create;
- verify;
- explain;
- execute;
- recover;
- communicate.

The need determines which capabilities are composed.

---

## Human Needs May Form a Semantic Layer

The Capability Graph may require two related levels:

```text
Need
    ↓
Capability composition
    ↓
Resource selection
