# CAPABILITY GRAPH

> *"NATIA does not know what it can do. It discovers what is possible."*

**Status:** Draft  
**Version:** 0.1  
**Last updated:** 2026-07-22

---

# Purpose

This document defines the Capability Graph.

The Capability Graph is the dynamic map of everything NATIA is capable of accomplishing.

Rather than describing software components, it describes relationships between capabilities.

It is through this graph that NATIA discovers how to satisfy a need.

---

# Introduction

Traditional software is built around predefined workflows.

A request enters the system.

The software executes a known sequence of operations.

The workflow was decided by its developers.

NATIA follows a different philosophy.

It discovers possible solutions by exploring its available capabilities.

---

# Capabilities

A Capability is an abstract ability.

Examples include:

- Observe
- Search
- Analyze
- Remember
- Explain
- Translate
- Execute
- Generate
- Communicate
- Learn

A Capability defines **what** may be achieved.

It never defines **how**.

---

# Relationships

Capabilities are not isolated.

Each capability may depend on, complement or extend another capability.

The Capability Graph represents those relationships.

Examples:

```
Observe
        │
        ▼
Context
        │
        ▼
Reason
      ╱   ╲
     ▼     ▼
Search  Memory
     ╲   ╱
      ▼ ▼
Decision
        │
        ▼
Execution
```

The graph is not hierarchical.

It is a network.

---

# Needs

The Capability Graph is not traversed from a starting node.

It is traversed from a need.

Examples:

"I need to understand this."

"I need to compare alternatives."

"I need to create documentation."

"I need to deploy a service."

The need determines the traversal.

Not the implementation.

---

# Discovery

Capabilities are discovered dynamically.

The graph is expected to evolve continuously.

New capabilities may appear.

Existing capabilities may disappear.

Relationships may change.

The orchestration model adapts automatically.

---

# Composition

Complex behaviour emerges from combinations of capabilities.

No capability is expected to solve complete problems.

Instead, orchestration composes multiple capabilities into a coherent solution.

For example:

```
Need

↓

Search

↓

Reason

↓

Summarize

↓

Generate

↓

Review

↓

Result
```

Every capability remains independent.

The solution emerges from collaboration.

---

# Resources

Capabilities are implemented using resources.

Different resources may implement the same capability.

Examples:

Reason

↓

GPT

Claude

Local LLM

Rule Engine

Human Expert

The Capability Graph never depends on a specific resource.

Only capabilities are represented.

---

# Extensibility

The Capability Graph is open.

New capabilities may be introduced at any time.

If they expose the required contracts, they immediately become available for orchestration.

No redesign is required.

Growth is therefore evolutionary rather than structural.

---

# Explainability

Every traversal of the graph must be explainable.

It should always be possible to answer:

- Which need initiated the traversal?
- Which capabilities participated?
- Why were they selected?
- Which alternatives existed?
- Which resources implemented them?

Understanding the path is as important as obtaining the result.

---

# Evolution

The Capability Graph is never complete.

It continuously evolves as NATIA evolves.

Every new capability increases the solution space.

The value of NATIA therefore grows through relationships rather than through size.

---

# What the Capability Graph Does Not Define

This document intentionally excludes:

- specific AI models
- programming languages
- APIs
- software modules
- desktop components
- databases
- operating systems

Those are implementation details.

The graph represents concepts.

Not technologies.

---

# Summary

The Capability Graph is the adaptive knowledge of what NATIA can do.

It allows the system to discover solutions instead of executing predefined workflows.

Capabilities remain independent.

Resources remain replaceable.

Relationships continuously evolve.

The Capability Graph is therefore the foundation of NATIA's adaptability.

It is not a map of software.

It is a map of possibilities.
