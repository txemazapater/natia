unit Natia.InMemory.Repositories;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions,
  Natia.Domain.Workspace,
  Natia.Domain.Conversation,
  Natia.Domain.Knowledge,
  Natia.Contracts.Repositories;

type
  TInMemoryWorkspaceRepository = class(TInterfacedObject, IWorkspaceRepository)
  private
    FItems: TObjectDictionary<string, TWorkspace>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save(AWorkspace: TWorkspace);
    function FindById(const AId: TWorkspaceId): TWorkspace;
    function Exists(const AId: TWorkspaceId): Boolean;
  end;

  TInMemoryConversationRepository = class(TInterfacedObject, IConversationRepository)
  private
    FItems: TObjectDictionary<string, TConversation>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save(AConversation: TConversation);
    function FindById(const AId: TConversationId): TConversation;
    function ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TConversation>;
  end;

  TInMemoryKnowledgeRepository = class(TInterfacedObject, IKnowledgeRepository)
  private
    FItems: TObjectDictionary<string, TKnowledgeEntry>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save(AEntry: TKnowledgeEntry);
    function FindById(const AId: TKnowledgeEntryId): TKnowledgeEntry;
    function ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TKnowledgeEntry>;
  end;

implementation

{ TInMemoryWorkspaceRepository }

constructor TInMemoryWorkspaceRepository.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TWorkspace>.Create([doOwnsValues]);
end;

destructor TInMemoryWorkspaceRepository.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TInMemoryWorkspaceRepository.Save(AWorkspace: TWorkspace);
var
  Key: string;
begin
  if AWorkspace = nil then
    raise ENatiaDomainError.Create('Workspace is required');
  Key := AWorkspace.Id.ToString;
  if FItems.ContainsKey(Key) then
  begin
    if FItems[Key] <> AWorkspace then
      raise ENatiaConflict.Create('Workspace identity already stored with a different instance');
    Exit;
  end;
  FItems.Add(Key, AWorkspace);
end;

function TInMemoryWorkspaceRepository.FindById(const AId: TWorkspaceId): TWorkspace;
begin
  if not FItems.TryGetValue(AId.ToString, Result) then
    Result := nil;
end;

function TInMemoryWorkspaceRepository.Exists(const AId: TWorkspaceId): Boolean;
begin
  Result := FItems.ContainsKey(AId.ToString);
end;

{ TInMemoryConversationRepository }

constructor TInMemoryConversationRepository.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TConversation>.Create([doOwnsValues]);
end;

destructor TInMemoryConversationRepository.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TInMemoryConversationRepository.Save(AConversation: TConversation);
var
  Key: string;
begin
  if AConversation = nil then
    raise ENatiaDomainError.Create('Conversation is required');
  Key := AConversation.Id.ToString;
  if FItems.ContainsKey(Key) then
  begin
    if FItems[Key] <> AConversation then
      raise ENatiaConflict.Create('Conversation identity already stored with a different instance');
    Exit;
  end;
  FItems.Add(Key, AConversation);
end;

function TInMemoryConversationRepository.FindById(const AId: TConversationId): TConversation;
begin
  if not FItems.TryGetValue(AId.ToString, Result) then
    Result := nil;
end;

function TInMemoryConversationRepository.ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TConversation>;
var
  List: TList<TConversation>;
  Item: TConversation;
begin
  List := TList<TConversation>.Create;
  try
    for Item in FItems.Values do
      if Item.WorkspaceId = AWorkspaceId then
        List.Add(Item);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ TInMemoryKnowledgeRepository }

constructor TInMemoryKnowledgeRepository.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TKnowledgeEntry>.Create([doOwnsValues]);
end;

destructor TInMemoryKnowledgeRepository.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TInMemoryKnowledgeRepository.Save(AEntry: TKnowledgeEntry);
var
  Key: string;
begin
  if AEntry = nil then
    raise ENatiaDomainError.Create('Knowledge entry is required');
  Key := AEntry.Id.ToString;
  if FItems.ContainsKey(Key) then
  begin
    if FItems[Key] <> AEntry then
      raise ENatiaConflict.Create('Knowledge identity already stored with a different instance');
    Exit;
  end;
  FItems.Add(Key, AEntry);
end;

function TInMemoryKnowledgeRepository.FindById(const AId: TKnowledgeEntryId): TKnowledgeEntry;
begin
  if not FItems.TryGetValue(AId.ToString, Result) then
    Result := nil;
end;

function TInMemoryKnowledgeRepository.ListByWorkspace(const AWorkspaceId: TWorkspaceId): TArray<TKnowledgeEntry>;
var
  List: TList<TKnowledgeEntry>;
  Item: TKnowledgeEntry;
begin
  List := TList<TKnowledgeEntry>.Create;
  try
    for Item in FItems.Values do
      if Item.WorkspaceId = AWorkspaceId then
        List.Add(Item);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

end.
