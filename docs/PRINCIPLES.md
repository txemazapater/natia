# NATIA — Engineering Principles

These principles are architectural constraints, not marketing language. When two implementation options are possible, the option that better preserves these principles should normally win.

## 1. Native first

NATIA is a desktop application, not a web application distributed as a desktop executable.

The primary implementation must use native operating-system capabilities and native controls where they provide a meaningful benefit. Embedded web content may be used for isolated presentation needs, but it must not become the application runtime.

## 2. Fast by default

Startup time, interaction latency and idle resource usage are product features.

NATIA should avoid unnecessary initialization, background scanning and eager loading. Expensive components should be loaded only when required and should be measurable.

## 3. The interface must never wait for the model

Model inference, network access, filesystem operations, indexing and tool execution must not block the user-interface thread.

Every long-running operation must support, where technically possible:

- progress reporting;
- cancellation;
- timeout handling;
- structured failure reporting;
- safe cleanup.

## 4. Prefer process isolation over shared failure

Untrusted, experimental or failure-prone components should run outside the main process.

A broken plugin, stalled tool or exhausted model connection must not freeze or terminate the desktop shell. Workers should be supervised, restartable and replaceable.

## 5. Providers are interchangeable

NATIA must not assume that one provider, endpoint or model family is permanent.

Provider integrations should be implemented behind stable internal contracts. OpenAI-compatible APIs are a primary interoperability target, while provider-specific capabilities may be exposed through optional extensions.

## 6. Local-first, not local-only

NATIA should work naturally with local models, self-hosted services and private infrastructure. Cloud providers remain valid options, but they must not be required for the core application to function.

User configuration, history and workspace metadata should remain locally available unless the user explicitly chooses otherwise.

## 7. Explicit authority

Agents and tools must operate with clearly defined permissions.

NATIA should make visible:

- which tool is being invoked;
- what resource it will access;
- what data will leave the machine;
- whether an operation is read-only or destructive;
- whether human approval is required.

Convenience must not depend on invisible privilege.

## 8. Extensions must not own the core

The extension model should be broad but controlled. Extensions should communicate through documented protocols and should normally run out of process.

The core application must remain usable without third-party extensions, and an extension must be removable without corrupting the workspace.

## 9. Configuration should be understandable

Configuration must be simple enough to inspect, export, back up and repair.

Secrets should use operating-system credential facilities where available. Non-secret configuration should favour documented and portable formats.

## 10. Observability is part of correctness

NATIA must provide structured logs for model calls, tool execution, worker lifecycle and failures.

The user should be able to understand what happened without attaching a debugger. Sensitive information must be redacted by default.

## 11. Data belongs to the user

Conversations, prompts, workspaces and execution history must be exportable in documented formats.

NATIA should avoid opaque databases as the only representation of valuable user information. Internal storage may be optimized, but export and recovery must remain possible.

## 12. Open source must be practical

Source availability alone is not enough. The project should be buildable, understandable and extendable by people outside its original team.

The architecture should keep the reusable core as portable as reasonably possible. Delphi may provide the primary Windows experience, while compatibility with Free Pascal should be preserved in non-visual and protocol-oriented components when the cost is acceptable.

## 13. Measure before optimizing, but measure from the beginning

Performance targets must be supported by repeatable measurements:

- cold and warm startup time;
- idle memory usage;
- active memory usage;
- CPU usage at rest;
- UI response latency;
- worker startup and shutdown time;
- installation size.

NATIA should compare itself not only with its previous versions but with the desktop clients it intends to improve upon.

## 14. No accidental platform

NATIA may grow into an ecosystem, but every abstraction must solve a demonstrated problem.

The project should not invent a new protocol, plugin system, package manager or scripting language when an open and adequate standard already exists.

## 15. Desktop software should feel immediate

The final test is experiential:

- the window opens quickly;
- typing is never delayed;
- cancellation is immediate;
- progress is visible;
- errors are comprehensible;
- closing the application behaves predictably.

NATIA should feel like a well-made desktop tool before it feels like an AI product.
