# NATIA — Roadmap

## Roadmap philosophy

NATIA will be developed in small architectural proofs. Each phase must leave the project usable, measurable and easier to extend.

The roadmap deliberately avoids starting with autonomous agents, complex plugin marketplaces or a full IDE. The first priority is to prove that a native AI desktop application can be fast, stable and pleasant to use.

## Phase 0 — Foundation

### Objective

Turn the idea into a project with explicit constraints and a reproducible development baseline.

### Deliverables

- vision and principles;
- initial architecture;
- license selection;
- contribution guidelines;
- coding conventions;
- initial Architecture Decision Record process;
- Delphi project skeleton;
- build instructions;
- basic automated checks where practical;
- performance measurement plan.

### Exit criteria

A new contributor can understand what NATIA is, build the empty application and know how architectural decisions are recorded.

## Phase 0.1 — Native shell

### Objective

Prove the desktop experience before adding AI complexity.

### Deliverables

- native Windows executable;
- main window and navigation skeleton;
- settings storage;
- structured logging;
- application lifecycle management;
- diagnostics view;
- startup and idle resource measurements;
- clean installation and portable development execution.

### Exit criteria

The application starts quickly, closes predictably and remains idle without unnecessary CPU activity.

## Phase 0.2 — First provider

### Objective

Connect NATIA to a generic OpenAI-compatible endpoint.

### Deliverables

- provider configuration;
- secure API-key reference;
- connection test;
- model listing;
- basic chat request;
- streamed output;
- normalized errors;
- immediate cancellation;
- request and response diagnostics with secret redaction.

### Initial targets

- Ollama;
- LM Studio;
- OpenAI-compatible self-hosted endpoints;
- optionally OpenAI itself for interoperability testing.

### Exit criteria

A user can configure an endpoint, select a model, send a prompt, watch the response stream and cancel it without freezing the interface.

## Phase 0.3 — Conversations and persistence

### Objective

Make NATIA useful as a dependable daily client.

### Deliverables

- SQLite persistence;
- conversation creation and renaming;
- message history;
- provider/model metadata per conversation;
- Markdown rendering strategy;
- copy and export;
- recovery after abnormal shutdown;
- configurable data location.

### Exit criteria

Conversations survive restart, can be exported and do not depend on a remote account.

## Phase 0.4 — Task supervision

### Objective

Establish the execution model for background work.

### Deliverables

- task registry;
- task states and progress events;
- cancellation tokens;
- timeouts;
- worker-process launch and supervision;
- heartbeat or health reporting;
- worker restart after failure;
- task activity view.

### Exit criteria

A deliberately crashed or stalled worker does not freeze or terminate NATIA and can be recovered visibly.

## Phase 0.5 — First tool

### Objective

Prove safe model-to-tool interaction.

### Deliverables

- tool manifest and schema;
- tool registry;
- read-only reference tool;
- user approval flow;
- execution in an isolated process;
- bounded input, output and execution time;
- audit record;
- tool result returned to the model.

### Suggested reference tool

A constrained filesystem reader limited to a user-approved folder.

### Exit criteria

The model can request a declared tool, the user can inspect and approve it, and the execution remains isolated and auditable.

## Phase 0.6 — Workspaces

### Objective

Move beyond isolated chats into persistent working contexts.

### Deliverables

- workspace creation;
- workspace instructions;
- allowed folders;
- preferred model/provider;
- enabled tools;
- exportable non-secret workspace definition;
- per-workspace conversations and history.

### Exit criteria

A user can maintain distinct environments for development, system administration, documentation or another recurring activity.

## Phase 0.7 — MCP integration

### Objective

Allow NATIA to consume existing open tool ecosystems without making MCP the internal architecture.

### Deliverables

- MCP server configuration;
- stdio transport;
- server lifecycle supervision;
- tool discovery;
- capability presentation;
- permission mapping;
- logs and failure handling;
- optional remote transport after the local model is stable.

### Exit criteria

At least one external MCP server can be started, inspected and used without compromising the main process.

## Phase 0.8 — Agent loop

### Objective

Introduce controlled multi-step execution.

### Deliverables

- explicit agent session state;
- maximum iteration limits;
- token and time budgets;
- tool-call loop;
- human approval policy;
- stop, pause and resume semantics;
- visible reasoning summary or action trace without exposing hidden model internals;
- final execution report.

### Exit criteria

An agent can complete a bounded multi-step task while the user retains control and can understand every external action.

## Phase 0.9 — Extension SDK

### Objective

Make NATIA extensible without making the main process fragile.

### Deliverables

- extension manifest specification;
- versioned extension protocol;
- provider extension example;
- tool extension example;
- process lifecycle contract;
- capability and permission declarations;
- developer documentation;
- compatibility policy.

### Exit criteria

A third party can build and run a small extension without modifying the NATIA source tree or loading arbitrary code into the UI process.

## Phase 1.0 — First public release

### Objective

Deliver a stable native AI workbench suitable for real daily use.

### Required qualities

- fast and measurable startup;
- stable conversation workflow;
- local and remote provider support;
- recoverable persistence;
- supervised tools and workers;
- workspaces;
- MCP support;
- basic controlled agents;
- documented extension path;
- installer and portable package;
- migration and backup documentation;
- security and privacy documentation.

## Post-1.0 directions

Possible future work, subject to evidence and community demand:

- richer document and image contexts;
- local semantic indexes and RAG;
- terminal and development workflows;
- Git integration;
- scheduled and background tasks;
- remote NATIA workers;
- specialised editions or workspace packs;
- Lazarus or alternative client experiments;
- accessibility improvements;
- enterprise policy and deployment;
- extension discovery and signed packages;
- collaboration and optional synchronization.

## Features intentionally deferred

The following are not initial priorities:

- training or fine-tuning models;
- a custom model runtime;
- unrestricted autonomous operation;
- embedded browser-based IDE functionality;
- a proprietary cloud account requirement;
- an extension marketplace before the extension protocol is stable;
- complete cross-platform UI parity;
- replacing established standards without a demonstrated need.

## Definition of progress

A phase is not complete because code exists. It is complete when:

- the feature behaves predictably;
- failure modes are visible;
- resource use is measured;
- documentation matches reality;
- user data can be recovered;
- the architecture remains simpler than before.
