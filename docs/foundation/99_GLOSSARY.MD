# GLOSSARY

> *"Shared language creates shared understanding."*

**Status:** Living Document  
**Version:** 1.0  
**Last updated:** 2026-07-22

---

# Purpose

This glossary defines the official terminology used throughout the NATIA project.

Its purpose is to ensure that every concept has a single, unambiguous meaning.

Whenever a term is introduced into the architecture, it should first be defined here.

---

# A

## Action

An operation that changes the current state of an Initiative.

Actions may be performed by people, capabilities, agents or external systems.

---

## Agent

A software entity capable of performing one or more capabilities autonomously or semi-autonomously.

Agents implement capabilities.

They are not capabilities themselves.

---

# C

## Capability

An abstract ability available to NATIA.

Capabilities describe **what** can be achieved.

They never describe **how**.

---

## Capability Graph

The conceptual network that describes relationships between capabilities and enables orchestration to discover possible solutions.

It represents possibilities rather than workflows.

---

## Context

The interpretation of information within a Workspace.

Context provides meaning.

Without context, information has little value.

---

# D

## Decision

A validated choice that influences the evolution of an Initiative.

Significant decisions become part of project knowledge.

---

# I

## Initiative

The central unit of work inside NATIA.

An Initiative represents a coherent body of intellectual work pursued over time.

Everything in NATIA exists to support an Initiative.

---

## Intention

A personal motivation belonging to a person.

Intentions answer the question:

**Why does this work matter?**

Intentions inspire Initiatives.

They are not managed by the system.

---

# K

## Knowledge

Validated understanding accumulated during the evolution of an Initiative.

Knowledge includes decisions, discoveries, relationships, documentation and experience.

Knowledge survives individual sessions.

---

# M

## Model

The conceptual representation of reality adopted by NATIA.

The model defines the entities that exist inside the system.

---

# N

## NEMO

Named characteristic of a Workspace (and therefore of its Initiative): the explanatory continuity of knowledge — not only *what we know*, but *how we got here*.

NEMO is not an application, not a service, not a database, and not a root domain aggregate. Knowledge still belongs to the Workspace. NEMO names the memory/explanation facet and may appear as a Desktop surface over that knowledge.

See [ADR-0004](../adr/0004-foundation-reconciliation-and-nemo.md).

---

# O

## Observation

Any fact perceived by NATIA.

Observations enrich knowledge but do not modify it directly.

---

## Ontology

The definition of the concepts that exist inside the NATIA universe.

The ontology precedes architecture and implementation.

---

## Orchestration

The coordination of capabilities.

Orchestration determines how independent capabilities collaborate.

It does not perform reasoning.

It enables cooperation.

---

## Objective

A measurable outcome pursued by an Initiative.

Objectives provide direction and enable progress evaluation.

---

# P

## Person

The human participant.

People define intentions, validate knowledge and remain responsible for every significant decision.

NATIA exists to augment human capability.

---

# R

## Resource

A concrete implementation of a capability.

Examples include:

- Language Models
- Agents
- Databases
- APIs
- External Services
- Repositories

Resources are replaceable.

Capabilities are conceptual.

---

## Result

The outcome produced by one or more actions.

Results generate new observations and enrich knowledge.

---

## Runtime

Ambiguous without a qualifier. Prefer:

### Cognitive Runtime

The cognitive behaviour of NATIA: continuously transforming observations into context, context into decisions and decisions into actions. Described in [03_RUNTIME.MD](03_RUNTIME.MD). Not a persistable domain aggregate.

### WorkspaceRuntime

An execution instance of a Workspace (`RuntimeId`, readiness). Defined in [ADR-0003](../adr/0003-core-domain-refinement.md) and clarified in [ADR-0004](../adr/0004-foundation-reconciliation-and-nemo.md).

---

# S

## Session

A bounded period of work performed by one or more participants.

Multiple sessions contribute to the same Workspace.

---

## Workspace

The living operational state of an Initiative.

A Workspace preserves context, knowledge and the current understanding of the Initiative.

A Workspace is not a directory.

It is not a repository.

It is the evolving representation of intellectual work.

---

# T

## Technology

Any implementation chosen to realize one or more resources.

Technologies are expected to evolve.

The conceptual model should remain stable.

---

# W

## Workflow

A predefined sequence of operations.

Traditional systems execute workflows.

NATIA discovers solutions dynamically through orchestration and the Capability Graph.

---

# Guiding Principle

Whenever two terms appear to describe the same concept, the architecture should be simplified until only one definition remains.

One concept.

One meaning.

One name.

---

# Evolution

This glossary is intentionally incomplete.

As NATIA evolves, new concepts will emerge.

Every new concept should be incorporated here before becoming part of the architecture.

The glossary is therefore considered part of the architectural foundation of the project.
