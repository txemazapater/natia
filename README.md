# NATIA

**NATIA** is an experimental open-source native desktop AI workbench.

NATIA starts from a simple idea:

> An AI agent should behave like a real desktop application.

Most current desktop AI clients are web applications packaged for the desktop. NATIA takes the opposite approach: start from the operating system, build a fast and dependable native application, and integrate models, agents and tools without turning the desktop into a browser runtime.

## Project direction

NATIA aims to provide:

- a responsive native Windows interface;
- fast startup and low idle resource usage;
- explicit multiprocess execution and supervision;
- compatibility with OpenAI-style APIs without vendor lock-in;
- support for local, remote and self-hosted models;
- safe and inspectable tool execution;
- MCP integration;
- persistent workspaces and conversations;
- an out-of-process extension model;
- user-owned, exportable data;
- an open architecture that can be understood and extended.

The first reference client is expected to use **Delphi and VCL** to build an excellent native Windows application. Portable core and protocol components should remain compatible with Free Pascal where doing so is reasonable and does not compromise the primary implementation.

## Current status

NATIA is in **Phase 0: Foundation**.

No production implementation exists yet. The repository currently defines the vision, engineering constraints, initial architecture and phased roadmap before code is introduced.

## Documentation

- [Vision](docs/VISION.md)
- [Engineering principles](docs/PRINCIPLES.md)
- [Initial architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture Decision Records](docs/adr/README.md)

## Core principles

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

> Native AI deserves native software.
