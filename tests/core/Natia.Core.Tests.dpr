program Natia.Core.Tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Natia.Domain.Identifiers in '..\..\src\core\domain\Natia.Domain.Identifiers.pas',
  Natia.Domain.Exceptions in '..\..\src\core\domain\Natia.Domain.Exceptions.pas',
  Natia.Domain.Support in '..\..\src\core\domain\Natia.Domain.Support.pas',
  Natia.Domain.Events in '..\..\src\core\domain\Natia.Domain.Events.pas',
  Natia.Domain.Workspace in '..\..\src\core\domain\Natia.Domain.Workspace.pas',
  Natia.Domain.WorkspaceRuntime in '..\..\src\core\domain\Natia.Domain.WorkspaceRuntime.pas',
  Natia.Domain.Conversation in '..\..\src\core\domain\Natia.Domain.Conversation.pas',
  Natia.Domain.Knowledge in '..\..\src\core\domain\Natia.Domain.Knowledge.pas',
  Natia.Contracts.Events in '..\..\src\core\contracts\Natia.Contracts.Events.pas',
  Natia.Contracts.Repositories in '..\..\src\core\contracts\Natia.Contracts.Repositories.pas',
  Natia.Contracts.Resources in '..\..\src\core\contracts\Natia.Contracts.Resources.pas',
  Natia.Contracts.Export in '..\..\src\core\contracts\Natia.Contracts.Export.pas',
  Natia.InMemory.Repositories in '..\..\src\core\inmemory\Natia.InMemory.Repositories.pas',
  Natia.InMemory.EventJournal in '..\..\src\core\inmemory\Natia.InMemory.EventJournal.pas',
  Natia.InMemory.ResourceConnector in '..\..\src\core\inmemory\Natia.InMemory.ResourceConnector.pas',
  Natia.InMemory.WorkspaceExporter in '..\..\src\core\inmemory\Natia.InMemory.WorkspaceExporter.pas',
  Natia.Application.Workspaces in '..\..\src\core\application\Natia.Application.Workspaces.pas',
  Natia.Application.Conversations in '..\..\src\core\application\Natia.Application.Conversations.pas',
  Natia.Application.Knowledge in '..\..\src\core\application\Natia.Application.Knowledge.pas',
  Natia.Tests.Fixtures in 'Natia.Tests.Fixtures.pas',
  Natia.Tests.Acceptance in 'Natia.Tests.Acceptance.pas',
  Natia.Tests.DependencyGuard in 'Natia.Tests.DependencyGuard.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  ExitCodeValue: Integer;
begin
  ExitCodeValue := 0;
  try
    TDUnitX.CheckCommandLine;
    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;
    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);
    Results := Runner.Execute;
    if not Results.AllPassed then
      ExitCodeValue := 1;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ExitCodeValue := 2;
    end;
  end;
  Halt(ExitCodeValue);
end.
