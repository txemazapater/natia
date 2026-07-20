# NATIA — Vision

## Purpose

NATIA is an open-source native desktop environment for working with artificial intelligence models, agents and tools.

It exists because most current desktop AI clients are not truly desktop applications. They are web applications packaged for the desktop, usually carrying a browser runtime, a JavaScript runtime and several abstraction layers before the user can interact with the operating system.

NATIA takes the opposite approach:

> Start from the operating system, then integrate AI.

The goal is not to create another chat window. The goal is to build a fast, durable and extensible native application that can remain open all day, manage long-running tasks, coordinate multiple processes and interact safely with the local machine.

## The problem

Modern AI desktop clients frequently suffer from the same limitations:

- slow startup;
- high idle memory consumption;
- duplicated browser runtimes;
- weak operating-system integration;
- fragile background execution;
- limited process isolation;
- provider lock-in;
- monolithic extension models;
- interfaces designed around chat rather than work.

These compromises may be reasonable for rapid product development, but they should not define the final shape of desktop AI software.

## The proposal

NATIA will be a native AI workbench with:

- immediate startup and low idle resource usage;
- a responsive native user interface;
- explicit multiprocess execution;
- streaming model responses without blocking the interface;
- support for local, remote and self-hosted models;
- first-class compatibility with OpenAI-style APIs;
- tools and agents that are replaceable and inspectable;
- safe access to operating-system capabilities;
- persistent workspaces and conversations;
- an extension model that does not compromise the core process;
- complete source availability and community-oriented development.

## What NATIA is

NATIA is intended to become:

- a desktop client for multiple AI providers;
- a host for local and remote agents;
- a workbench for tools, prompts, contexts and workflows;
- a supervisor for background AI tasks;
- a reference implementation of efficient native AI software;
- a reusable foundation for specialised desktop assistants.

## What NATIA is not

NATIA is not intended to be:

- another browser wrapper;
- an Electron replacement built with the same architectural assumptions;
- a single-provider client;
- a model training platform;
- an autonomous system with unrestricted access to the computer;
- a collection of hidden prompts presented as a product;
- a new proprietary protocol created only to lock users into the application.

## Native means more than compiled

For NATIA, native software means:

- using the operating system deliberately;
- treating processes, threads, files, sockets and services as first-class resources;
- integrating with the desktop without embedding an entire browser;
- respecting platform conventions;
- remaining responsive under load;
- failing in isolated components rather than freezing as a whole;
- providing predictable installation, execution and removal.

A compiled binary is not enough. Native behaviour is the real objective.

## Open by design

NATIA must remain useful without depending on a single company, cloud or model family.

The project will favour:

- open protocols;
- documented interfaces;
- replaceable providers;
- exportable user data;
- human-readable configuration where practical;
- transparent execution logs;
- permissive extension mechanisms;
- compatibility with open models and self-hosted infrastructure.

OpenAI-compatible APIs are treated as an interoperability convention, not as a dependency on OpenAI.

## Long-term ambition

NATIA should demonstrate that modern AI desktop software can be:

- lighter;
- faster;
- safer;
- more transparent;
- more extensible;
- more respectful of the operating system;
- and more pleasant to use than the current generation of packaged web clients.

The project succeeds when users stop thinking of NATIA as an AI chat client and begin treating it as a normal, dependable desktop tool.

---

> Native AI deserves native software.
