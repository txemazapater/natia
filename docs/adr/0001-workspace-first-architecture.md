# ADR-0001: Workspace-first architecture

- Status: Accepted
- Date: 2026-07-20

## Context

NATIA was initially described as a native desktop AI workbench centred on providers, conversations, tools and agents.

That framing is insufficient for long-lived projects and teams. Conversations are temporary views over a much larger body of project state. Repositories, documentation, architectural decisions, roadmaps, tools, services, credentials, permissions, execution history and human discussions must remain coherent across sessions, people and AI models.

The practical problem is continuity. Users currently spend significant effort reconstructing where a project stands, why decisions were made, which services are required and what changed since their previous session. The problem grows rapidly as more projects and more contributors are added.

## Decision

NATIA will use a Workspace-first architecture.

The Workspace, not the conversation, is the primary product entity and the central unit of persistence, orchestration and user experience.

A Workspace will own or reference:

- project identity and instructions;
- one or more repositories;
- documentation and Architecture Decision Records;
- roadmap, milestones, tasks, risks and blockers;
- conversations and summaries;
- historical changes and activity;
- AI providers and model preferences;
- tools, extensions and MCP servers;
- local and remote service connections;
- environment configuration and secret references;
- active identity, delegated identities and authority policy;
- health and readiness state.

Opening a Workspace will be treated as starting an operational environment. NATIA will restore relevant state, verify required capabilities and present the current project position before the user has to reconstruct it manually.

Conversation will remain a first-class interface, but it will be one Workspace surface among others.

## Consequences

### Positive

- Project knowledge survives individual conversations, models and contributors.
- NATIA can explain where a project stands and what changed.
- Tools and services become explicit Workspace dependencies instead of transient chat capabilities.
- Permissions and active identities can be represented and audited consistently.
- Teams can share project continuity rather than only files.
- Roadmap awareness and historical reasoning become core capabilities.

### Costs and risks

- Workspace state requires a carefully versioned data model.
- Synchronisation between local state, repositories and remote services will be complex.
- NATIA must distinguish facts from inferred project status.
- Historical information may become noisy without consolidation and retention policies.
- Credentials, delegated authority and administrative execution require strict security boundaries.
- The first usable version must resist becoming an oversized project-management platform.

## Architectural direction

A dedicated Workspace Engine will coordinate:

- Workspace lifecycle and readiness;
- context and memory consolidation;
- resource and service registry;
- identity and permission context;
- activity ingestion and change detection;
- project-state synthesis;
- roadmap and decision awareness;
- export, backup and portability.

Provider, conversation, agent and tool subsystems will operate within an explicit Workspace context.

## Rejected alternatives

### Conversation-first application

Rejected because conversations do not adequately represent project state and encourage repeated context reconstruction.

### Repository-only workspace

Rejected because important project knowledge also exists in services, conversations, decisions, credentials, runtime state and external systems.

### Generic project-management centre

Rejected because NATIA's purpose is operational continuity and intelligent work orchestration, not replacing every issue tracker or planning platform.

## Guiding statement

> NATIA exists to preserve the continuity of thought across people, time and projects.