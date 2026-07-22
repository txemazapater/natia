# MODEL

> *"Everything in NATIA revolves around an Initiative."*

**Status:** Draft  
**Version:** 0.1  
**Last updated:** 2026-07-22

---

# Purpose

This document defines the conceptual model of NATIA.

It introduces the fundamental entities that exist within the system and explains how they relate to each other.

This document intentionally avoids implementation details.

Programming languages, software components, databases and technologies are described in later documents.

---

# The Core Idea

NATIA is not organized around projects.

It is not organized around repositories.

It is not organized around source code.

NATIA is organized around **Initiatives**.

An Initiative represents a meaningful unit of work.

Everything else exists to support its evolution.

---

# Conceptual Hierarchy

```
Person
    │
    ▼
Intentions
    │
    ▼
Initiative
    │
    ▼
Objectives
    │
    ▼
Actions
    │
    ▼
Results
```

An Initiative transforms human intentions into measurable outcomes.

---

# Fundamental Entities

## Person

The person is the only indispensable actor.

Everything inside NATIA exists to assist human work.

The person defines intentions, validates knowledge and makes the final decisions.

---

## Intention

An intention represents a personal motivation.

Intentions answer the question:

> **Why do I want to do this?**

Intentions belong to people.

They are not managed by the system.

---

## Initiative

The Initiative is the central entity of NATIA.

An Initiative represents a coherent body of work pursued over time.

Examples include:

- Develop NATIA Desktop
- Investigate a new compiler architecture
- Design a monitoring appliance
- Build an AI workflow
- Research a hardware platform

Every Initiative evolves continuously.

Everything else inside NATIA contributes to an Initiative.

---

## Objective

Objectives define the expected outcomes of an Initiative.

Objectives answer:

> **What should be achieved?**

Objectives provide direction and allow progress to be measured.

---

## Workspace

Every Initiative owns exactly one Workspace.

The Workspace contains the living state of the Initiative.

It is not a directory.

It is not a repository.

It is not a collection of files.

It is the accumulated operational knowledge of the Initiative.

---

## Context

Context is the interpretation of the current Workspace.

Context allows both humans and intelligent capabilities to understand the current situation.

Without context, information has little value.

---

## Knowledge

Knowledge represents validated understanding.

It includes:

- Decisions
- Documentation
- Discoveries
- Failures
- Experiments
- Conversations
- References
- Relationships

Knowledge survives individual work sessions.

---

## Observation

Observation represents everything NATIA can perceive.

Examples include:

- Repository activity
- Documentation changes
- Build status
- External events
- Agent outputs
- User activity

Observation continuously enriches the Workspace.

---

## Decision

A decision changes the future evolution of an Initiative.

Decisions may be taken by a person or proposed by NATIA.

Significant decisions become part of project knowledge.

---

## Action

Actions modify the current state of an Initiative.

Actions may be executed by:

- The person
- An intelligent capability
- An agent
- An external tool
- An automated process

---

## Result

Results are produced by Actions.

Results may:

- generate new knowledge
- modify context
- create additional objectives
- trigger further actions

---

## Capability

A Capability is an abstract function available to NATIA.

Capabilities are independent from implementation.

Examples include:

- Observe
- Remember
- Search
- Analyze
- Plan
- Execute
- Communicate
- Generate
- Summarize

Technologies implement Capabilities.

Capabilities define the architecture.

---

# Conceptual Flow

```
Person
    │
    ▼
Intentions
    │
    ▼
Initiative
    │
    ▼
Objectives
    │
    ▼
Workspace
    │
    ▼
Context
    │
    ▼
Decision
    │
    ▼
Action
    │
    ▼
Result
    │
    ▼
Observation
    │
    ▼
Knowledge
    │
    └──────────────────────► Workspace
```

The Workspace continuously evolves as new knowledge is generated.

---

# What This Model Does Not Describe

This document intentionally excludes:

- User interface
- Desktop application
- Artificial Intelligence models
- Agents
- Orchestrator
- Programming languages
- Storage technologies
- APIs
- Communication protocols

Those concepts belong to subsequent documents.

---

# Summary

NATIA models intellectual work.

Not software.

Not repositories.

Not conversations.

Every Initiative represents a living body of knowledge.

Every capability exists to preserve, enrich and accelerate that knowledge.

Everything else is an implementation detail.
