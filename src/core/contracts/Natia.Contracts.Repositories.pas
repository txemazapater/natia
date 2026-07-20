unit Natia.Contracts.Repositories;

interface

uses
  Natia.Domain.Identifiers,
  Natia.Domain.Workspace,
  Natia.Domain.Conversation,
  Natia.Domain.Knowledge;

type
  IWorkspaceRepository = interface
    ['{C1D2E3F4-A5B6-4789-C012-3456789ABC20}']
    procedure Save(AWorkspace: TWorkspace);
    function FindById(const AId: TWorkspaceId): TWorkspace;
    function Exists(const AId: TWorkspaceId): Boolean;
  end;

  IConversationRepository = interface
    ['{C1D2E3F4-A5B6-4789-C012-3456789ABC21}']
    procedure Save(AConversation: TConversation);
    function FindById(const AId: TConversationId): TConversation;
    function ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TConversation>;
  end;

  IKnowledgeRepository = interface
    ['{C1D2E3F4-A5B6-4789-C012-3456789ABC22}']
    procedure Save(AEntry: TKnowledgeEntry);
    function FindById(const AId: TKnowledgeEntryId): TKnowledgeEntry;
    function ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TKnowledgeEntry>;
  end;

implementation

end.
