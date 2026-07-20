program Natia.Core;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Natia.Domain.Identifiers in 'domain\Natia.Domain.Identifiers.pas',
  Natia.Domain.Exceptions in 'domain\Natia.Domain.Exceptions.pas',
  Natia.Domain.Support in 'domain\Natia.Domain.Support.pas',
  Natia.Domain.Events in 'domain\Natia.Domain.Events.pas',
  Natia.Domain.Workspace in 'domain\Natia.Domain.Workspace.pas',
  Natia.Domain.WorkspaceRuntime in 'domain\Natia.Domain.WorkspaceRuntime.pas',
  Natia.Domain.Conversation in 'domain\Natia.Domain.Conversation.pas',
  Natia.Domain.Knowledge in 'domain\Natia.Domain.Knowledge.pas',
  Natia.Contracts.Events in 'contracts\Natia.Contracts.Events.pas',
  Natia.Contracts.Repositories in 'contracts\Natia.Contracts.Repositories.pas',
  Natia.Contracts.Resources in 'contracts\Natia.Contracts.Resources.pas',
  Natia.Contracts.Export in 'contracts\Natia.Contracts.Export.pas',
  Natia.InMemory.Repositories in 'inmemory\Natia.InMemory.Repositories.pas',
  Natia.InMemory.EventJournal in 'inmemory\Natia.InMemory.EventJournal.pas',
  Natia.InMemory.ResourceConnector in 'inmemory\Natia.InMemory.ResourceConnector.pas',
  Natia.InMemory.WorkspaceExporter in 'inmemory\Natia.InMemory.WorkspaceExporter.pas',
  Natia.Application.Workspaces in 'application\Natia.Application.Workspaces.pas',
  Natia.Application.Conversations in 'application\Natia.Application.Conversations.pas',
  Natia.Application.Knowledge in 'application\Natia.Application.Knowledge.pas';

begin
  Writeln('Natia.Core Phase 0.3 — units linked successfully');
end.
