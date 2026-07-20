unit Natia.InMemory.WorkspaceExporter;

interface

uses
  System.SysUtils,
  System.Classes,
  Natia.Domain.Identifiers,
  Natia.Domain.Workspace,
  Natia.Domain.Conversation,
  Natia.Domain.Knowledge,
  Natia.Domain.Exceptions,
  Natia.Contracts.Export,
  Natia.Contracts.Repositories;

type
  { Export policy (Phase 0.3):
    - Full workspace definition and bindings.
    - All knowledge entries (metadata + body/decision summary).
    - Conversation metadata only (id, title, status, message count).
    - Messages are not fully expanded (avoids dumping 10k messages). }
  TInMemoryWorkspaceExporter = class(TInterfacedObject, IWorkspaceExporter)
  private
    FWorkspaces: IWorkspaceRepository;
    FConversations: IConversationRepository;
    FKnowledge: IKnowledgeRepository;
  public
    constructor Create(
      const AWorkspaces: IWorkspaceRepository;
      const AConversations: IConversationRepository;
      const AKnowledge: IKnowledgeRepository
    );
    function ExportWorkspace(const AWorkspaceId: TWorkspaceId): TWorkspaceExportDocument;
  end;

implementation

{ TInMemoryWorkspaceExporter }

constructor TInMemoryWorkspaceExporter.Create(
  const AWorkspaces: IWorkspaceRepository;
  const AConversations: IConversationRepository;
  const AKnowledge: IKnowledgeRepository
);
begin
  inherited Create;
  FWorkspaces := AWorkspaces;
  FConversations := AConversations;
  FKnowledge := AKnowledge;
end;

function TInMemoryWorkspaceExporter.ExportWorkspace(
  const AWorkspaceId: TWorkspaceId
): TWorkspaceExportDocument;
var
  Ws: TWorkspace;
  Builder: TStringBuilder;
  Binding: TWorkspaceBinding;
  Entry: TKnowledgeEntry;
  Conv: TConversation;
  KnowledgeItems: TArray<TKnowledgeEntry>;
  Conversations: TArray<TConversation>;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');

  KnowledgeItems := FKnowledge.ListByWorkspace(AWorkspaceId);
  Conversations := FConversations.ListByWorkspace(AWorkspaceId);

  Builder := TStringBuilder.Create;
  try
    Builder.AppendLine('NATIA Workspace Export v1');
    Builder.AppendLine('WorkspaceId=' + Ws.Id.ToString);
    Builder.AppendLine('Name=' + Ws.Name);
    Builder.AppendLine('LifecycleStatus=' + LifecycleStatusToString(Ws.LifecycleStatus));
    Builder.AppendLine('Instructions=' + Ws.Instructions);
    Builder.AppendLine('ProviderId=' + Ws.ProviderId);
    Builder.AppendLine('ModelId=' + Ws.ModelId);
    Builder.AppendLine('Bindings:');
    for Binding in Ws.GetBindings do
      Builder.AppendLine(Format('  - %s [%s] %s required=%s path=%s',
        [Binding.Id.ToString, BindingKindToString(Binding.Kind), Binding.DisplayName,
         BoolToStr(Binding.Required, True), Binding.LocationOrEndpoint]));
    Builder.AppendLine('Knowledge:');
    for Entry in KnowledgeItems do
      Builder.AppendLine(Format('  - %s kind=%s status=%s title=%s provenance=%s',
        [Entry.Id.ToString, KnowledgeKindToString(Entry.Kind), KnowledgeStatusToString(Entry.Status),
         Entry.Title, KnowledgeProvenanceToString(Entry.Provenance.Kind)]));
    Builder.AppendLine('Conversations:');
    for Conv in Conversations do
      Builder.AppendLine(Format('  - %s title=%s status=%d messages=%d',
        [Conv.Id.ToString, Conv.Title, Ord(Conv.Status), Conv.MessageCount]));

    Result.Text := Builder.ToString;
    Result.WorkspaceId := Ws.Id.ToString;
    Result.Name := Ws.Name;
    Result.LifecycleStatus := LifecycleStatusToString(Ws.LifecycleStatus);
    Result.BindingCount := Ws.BindingCount;
    Result.KnowledgeCount := Length(KnowledgeItems);
    Result.ConversationCount := Length(Conversations);
  finally
    Builder.Free;
  end;
end;

end.
