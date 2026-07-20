# NATIA — Initial Architecture

## Status

This document describes the initial architectural direction. It is intentionally technology-aware but not yet an implementation specification. Decisions that become binding should later be recorded as Architecture Decision Records in `docs/adr/`.

## Architectural objectives

NATIA must provide:

- a native and immediately responsive desktop shell;
- non-blocking access to local and remote AI models;
- explicit supervision of background work;
- isolation of extensions and risky operations;
- provider independence;
- transparent and recoverable local persistence;
- a stable path from a small first release to a complete agent workbench.

## Proposed system shape

```text
+------------------------------------------------------------+
| NATIA Desktop                                              |
|                                                            |
|  Native UI                                                 |
|  - workspaces                                              |
|  - conversations                                           |
|  - model and provider selection                            |
|  - activity, approvals and diagnostics                     |
+-------------------------------+----------------------------+
                                |
                                | typed internal commands/events
                                v
+------------------------------------------------------------+
| NATIA Core                                                 |
|                                                            |
|  session manager       provider registry                   |
|  agent coordinator     permission policy                   |
|  task supervisor       persistence                         |
|  event bus             diagnostics                         |
+----------+------------------+-------------------+-----------+
           |                  |                   |
           v                  v                   v
+----------------+  +------------------+  +-------------------+
| Model workers  |  | Tool workers     |  | Extension hosts   |
|                |  |                  |  |                   |
| OpenAI API     |  | filesystem       |  | MCP servers       |
| Ollama         |  | shell/process    |  | external plugins  |
| LM Studio      |  | Git              |  | specialised apps  |
| self-hosted    |  | HTTP/database    |  |                   |
+----------------+  +------------------+  +-------------------+
```

## 1. Desktop shell

The desktop shell owns the visible application lifecycle and native user experience.

Responsibilities:

- application startup and shutdown;
- windows, navigation and native controls;
- keyboard and accessibility behaviour;
- presentation of conversations and streaming output;
- workspace selection;
- user approvals;
- task and worker status;
- user-facing diagnostics.

The shell must not execute model inference, indexing or unbounded tools on its UI thread.

### Initial platform

The first reference client should target Windows using Delphi and VCL. This is a deliberate product decision: the first objective is to build an excellent native Windows application rather than a compromised cross-platform shell.

Cross-platform compatibility should be pursued at the protocol and core-library levels before promising multiple graphical clients.

## 2. Core

The core coordinates application state without depending directly on visual controls.

Candidate responsibilities:

- provider and model registry;
- conversation and workspace lifecycle;
- request construction;
- streaming event normalization;
- agent loop coordination;
- task cancellation and timeout policy;
- tool permission evaluation;
- worker supervision;
- persistence orchestration;
- structured logging.

The core should use interfaces and plain data structures that can be tested without starting the GUI.

## 3. Providers

A provider is an adapter between NATIA and a model service.

A minimal provider contract should eventually cover:

- connection testing;
- model discovery;
- capability description;
- chat or response creation;
- token/event streaming;
- cancellation;
- embeddings where supported;
- tool-call exchange;
- normalized error reporting.

Example providers:

- generic OpenAI-compatible endpoint;
- OpenAI;
- Ollama;
- LM Studio;
- SAPIENS or another self-hosted gateway;
- provider-specific adapters added later.

NATIA should not reduce all providers to the lowest common denominator. A shared baseline should coexist with discoverable optional capabilities.

## 4. Tasks, threads and processes

NATIA should distinguish three concepts clearly.

### UI tasks

Small operations that update presentation state. They remain on the main thread and must complete quickly.

### Background tasks

Bounded operations suitable for worker threads, such as parsing a response, reading configuration or transforming data.

### Worker processes

Long-running, untrusted, memory-intensive or failure-prone operations, including:

- tool execution;
- repository indexing;
- document processing;
- shell sessions;
- third-party extensions;
- MCP servers;
- specialised local model bridges.

The main process acts as supervisor. Workers should expose health, lifecycle and cancellation signals. A failed worker must be restartable without restarting the application.

## 5. Interprocess communication

No final IPC mechanism has been selected.

Candidates for the Windows reference implementation include:

- named pipes;
- local TCP sockets;
- standard input/output for simple executable tools;
- HTTP or WebSocket for independently hosted services;
- MCP where its semantics match the integration.

The chosen internal protocol should support:

- request identifiers;
- asynchronous events;
- streaming;
- cancellation;
- heartbeats;
- structured errors;
- version negotiation;
- bounded message sizes.

A binary protocol is not automatically required. Simplicity and inspectability are important during the first phases.

## 6. Tools and agents

A tool is a declared capability with a schema, permission requirements and an execution implementation.

An agent is a coordinator that can combine model interaction, tools, state and policy to pursue a task.

These concepts must remain separate. A tool should be callable without requiring a fully autonomous agent loop, and an agent should not receive unrestricted system access merely because a model requested it.

Each tool should declare at least:

- identifier and version;
- human-readable purpose;
- input and output schema;
- read/write/destructive classification;
- required permissions;
- timeout policy;
- execution host;
- audit representation.

## 7. Extensions

The preferred extension boundary is out of process.

An extension may provide:

- tools;
- provider adapters;
- importers and exporters;
- context sources;
- specialised workers;
- UI contributions through a constrained extension surface.

Native DLL plugins loaded into the main process should not be the default mechanism because they share memory, privileges and failure state with the application.

A future extension package may include:

```text
extension/
  manifest.json
  bin/
  schemas/
  resources/
  README.md
```

The package and discovery format remain undecided.

## 8. Persistence

SQLite is the leading candidate for structured local state.

Potential stored data:

- providers and non-secret configuration;
- model metadata cache;
- workspaces;
- conversations and messages;
- tool execution records;
- task state;
- extension registry;
- application settings.

Secrets must not be stored as plaintext in the database. On Windows, the credential manager or DPAPI-backed storage should be considered.

Important user data must be exportable in documented formats such as JSON, Markdown or JSON Lines.

## 9. Workspaces

A workspace groups the context required for a type of work.

It may contain:

- instructions;
- preferred providers and models;
- allowed folders;
- enabled tools;
- extension configuration;
- MCP servers;
- conversation history;
- approval policy;
- environment variables or secret references.

Workspaces should be portable where possible, while machine-specific paths and secrets remain clearly separated.

## 10. Security model

NATIA assumes model output is untrusted input.

The security design should include:

- least-privilege execution;
- explicit folder and resource scopes;
- approval gates for destructive actions;
- separation between read and write capabilities;
- secret redaction;
- audit logs;
- bounded execution time and output;
- process termination controls;
- clear indication of remote data transmission.

A future sandbox may improve isolation, but the first line of defence is a small, explicit and inspectable authority model.

## 11. Source layout proposal

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

This layout is provisional. The portable core should avoid visual dependencies and isolate platform-specific code.

## 12. First architectural proof

The first executable should prove the architecture rather than the feature count.

It should demonstrate:

1. native startup;
2. provider configuration;
3. model discovery;
4. streamed conversation output;
5. immediate cancellation;
6. non-blocking UI behaviour;
7. local persistence;
8. one isolated external tool;
9. worker failure and recovery;
10. measurable resource usage.

If these foundations are correct, additional agents, providers and tools can be added without turning NATIA into a monolith.
