unit Natia.Contracts.Resources;

interface

uses
  Natia.Domain.Identifiers,
  Natia.Domain.Workspace,
  Natia.Domain.WorkspaceRuntime;

type
  IResourceConnector = interface
    ['{D1E2F3A4-B5C6-4789-D012-3456789ABC30}']
    function Connect(const ABinding: TWorkspaceBinding): TConnectionOutcome;
  end;

implementation

end.
