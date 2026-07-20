# NATIA

**NATIA** is an experimental open-source native desktop AI operating workspace.

NATIA starts from two simple ideas:

> An AI agent should behave like a real desktop application.

> The Workspace is the product. Conversation is one of its interfaces.

Most current desktop AI clients are web applications packaged for the desktop and centred on isolated conversations. NATIA takes the opposite approach: start from the operating system, build a fast and dependable native application, and place models, agents, tools, services and project memory inside a persistent Workspace.

A NATIA Workspace should know where a project stands, what changed, which capabilities it requires and what the most valuable next step may be. Users should not have to reconstruct context every time they return.

## Project direction

NATIA aims to provide:

- a responsive native Windows interface;
- fast startup and low idle resource usage;
- persistent, project-aware Workspaces;
- continuity across conversations, people, models and time;
- explicit multiprocess execution and supervision;
- compatibility with OpenAI-style APIs without vendor lock-in;
- support for local, remote and self-hosted models;
- connected tools, MCP servers and local or remote services;
- safe and inspectable execution under explicit identities and permissions;
- roadmap, decision and project-state awareness;
- an out-of-process extension model;
- user-owned, exportable data;
- an open architecture that can be understood, reused and extended.

The first reference client is expected to use **Delphi and VCL** to build an excellent native Windows application. NATIA is licensed under the **MIT License**. Proprietary development tools must not become an excuse for proprietary architecture: portable core, protocol, schema and non-visual components should remain accessible and compatible with Free Pascal where doing so is reasonable.

## Current status

NATIA is in **Phase 0: Foundation**.

No production implementation exists yet. The repository currently defines the manifesto, vision, engineering constraints, initial architecture and phased roadmap before code is introduced.

## Documentation

- [The NATIA Manifesto](MANIFESTO.md)
- [Vision](docs/VISION.md)
- [Engineering principles](docs/PRINCIPLES.md)
- [Initial architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture Decision Records](docs/adr/README.md)
- [ADR-0001: Workspace-first architecture](docs/adr/0001-workspace-first-architecture.md)

## Core principles

- The Workspace is the product.
- Preserve the continuity of thought.
- Native first.
- Fast by default.
- The interface must never wait for the model.
- Prefer process isolation over shared failure.
- Providers are interchangeable.
- Local-first, not local-only.
- Tools operate with explicit authority.
- Extensions must not own the core.
- User data remains exportable.
- Performance is measured from the beginning.

## Name

NATIA began as **Native Integrated Agent**.

The name may outgrow the original expansion as the project evolves. NATIA is the product identity; the architecture and documented principles define what it means.

---

> NATIA exists to preserve the continuity of thought across people, time and projects.