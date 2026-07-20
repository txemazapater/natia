unit Natia.Contracts.Export;

interface

uses
  Natia.Domain.Identifiers;

type
  TWorkspaceExportDocument = record
    Text: string;
    WorkspaceId: string;
    Name: string;
    LifecycleStatus: string;
    BindingCount: Integer;
    KnowledgeCount: Integer;
    ConversationCount: Integer;
  end;

  IWorkspaceExporter = interface
    ['{E1F2A3B4-C5D6-4789-E012-3456789ABC40}']
    function ExportWorkspace(const AWorkspaceId: TWorkspaceId): TWorkspaceExportDocument;
  end;

implementation

end.
