unit Natia.Application.Knowledge;

interface

uses
  System.SysUtils,
  Natia.Domain.Identifiers,
  Natia.Domain.Support,
  Natia.Domain.Knowledge,
  Natia.Domain.Conversation,
  Natia.Domain.Events,
  Natia.Domain.Exceptions,
  Natia.Contracts.Repositories,
  Natia.Contracts.Events;

type
  TKnowledgeApplication = class
  private
    FWorkspaces: IWorkspaceRepository;
    FConversations: IConversationRepository;
    FKnowledge: IKnowledgeRepository;
    FJournal: IEventJournal;
    FClock: IClock;
    FIds: IIdGenerator;
    FActor: string;
  public
    constructor Create(
      const AWorkspaces: IWorkspaceRepository;
      const AConversations: IConversationRepository;
      const AKnowledge: IKnowledgeRepository;
      const AJournal: IEventJournal;
      const AClock: IClock;
      const AIds: IIdGenerator;
      const AActor: string = 'system'
    );

    function CreateScratch(
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ABody: string
    ): TKnowledgeEntry;

    function CreateFact(
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ABody: string
    ): TKnowledgeEntry;

    function CreateDecision(
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ADecision: TDecisionShape
    ): TKnowledgeEntry;

    function PromoteMessageToKnowledge(
      const AConversationId: TConversationId;
      const AMessageId: TMessageId;
      const ATitle: string
    ): TKnowledgeEntry;

    procedure ConvertScratchToFact(const AEntryId: TKnowledgeEntryId);
    procedure ConvertScratchToDecision(const AEntryId: TKnowledgeEntryId; const ADecision: TDecisionShape);
    procedure AcceptKnowledge(const AEntryId: TKnowledgeEntryId);
  end;

implementation

uses
  Natia.Domain.Workspace;

{ TKnowledgeApplication }

constructor TKnowledgeApplication.Create(
  const AWorkspaces: IWorkspaceRepository;
  const AConversations: IConversationRepository;
  const AKnowledge: IKnowledgeRepository;
  const AJournal: IEventJournal;
  const AClock: IClock;
  const AIds: IIdGenerator;
  const AActor: string
);
begin
  inherited Create;
  FWorkspaces := AWorkspaces;
  FConversations := AConversations;
  FKnowledge := AKnowledge;
  FJournal := AJournal;
  FClock := AClock;
  FIds := AIds;
  FActor := AActor;
end;

function TKnowledgeApplication.CreateScratch(
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ABody: string
): TKnowledgeEntry;
begin
  if FWorkspaces.FindById(AWorkspaceId) = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Result := TKnowledgeEntry.CreateScratch(
    TKnowledgeEntryId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    ATitle,
    ABody,
    TKnowledgeProvenanceInfo.Authored,
    FClock.UtcNow
  );
  FKnowledge.Save(Result);
end;

function TKnowledgeApplication.CreateFact(
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ABody: string
): TKnowledgeEntry;
begin
  if FWorkspaces.FindById(AWorkspaceId) = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Result := TKnowledgeEntry.CreateFact(
    TKnowledgeEntryId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    ATitle,
    ABody,
    TKnowledgeProvenanceInfo.Authored,
    FClock.UtcNow
  );
  FKnowledge.Save(Result);
end;

function TKnowledgeApplication.CreateDecision(
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ADecision: TDecisionShape
): TKnowledgeEntry;
begin
  if FWorkspaces.FindById(AWorkspaceId) = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Result := TKnowledgeEntry.CreateDecision(
    TKnowledgeEntryId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    ATitle,
    ADecision,
    TKnowledgeProvenanceInfo.Authored,
    FClock.UtcNow
  );
  FKnowledge.Save(Result);
end;

function TKnowledgeApplication.PromoteMessageToKnowledge(
  const AConversationId: TConversationId;
  const AMessageId: TMessageId;
  const ATitle: string
): TKnowledgeEntry;
var
  Conv: TConversation;
  Msg: TMessage;
begin
  Conv := FConversations.FindById(AConversationId);
  if Conv = nil then
    raise ENatiaNotFound.Create('Conversation not found');
  Msg := Conv.FindMessage(AMessageId);
  if Msg = nil then
    raise ENatiaNotFound.Create('Message not found');

  Result := TKnowledgeEntry.CreateFact(
    TKnowledgeEntryId.CreateNew(FIds.NewGuid),
    Conv.WorkspaceId,
    ATitle,
    Msg.Content,
    TKnowledgeProvenanceInfo.Promoted(AConversationId, AMessageId),
    FClock.UtcNow
  );
  FKnowledge.Save(Result);
end;

procedure TKnowledgeApplication.ConvertScratchToFact(const AEntryId: TKnowledgeEntryId);
var
  Entry: TKnowledgeEntry;
begin
  Entry := FKnowledge.FindById(AEntryId);
  if Entry = nil then
    raise ENatiaNotFound.Create('Knowledge entry not found');
  Entry.ConvertToFact;
end;

procedure TKnowledgeApplication.ConvertScratchToDecision(
  const AEntryId: TKnowledgeEntryId;
  const ADecision: TDecisionShape
);
var
  Entry: TKnowledgeEntry;
begin
  Entry := FKnowledge.FindById(AEntryId);
  if Entry = nil then
    raise ENatiaNotFound.Create('Knowledge entry not found');
  Entry.ConvertToDecision(ADecision);
end;

procedure TKnowledgeApplication.AcceptKnowledge(const AEntryId: TKnowledgeEntryId);
var
  Entry: TKnowledgeEntry;
begin
  Entry := FKnowledge.FindById(AEntryId);
  if Entry = nil then
    raise ENatiaNotFound.Create('Knowledge entry not found');
  Entry.Accept;
  FJournal.Append(TFactEvent.Create(
    TEventId.CreateNew(FIds.NewGuid),
    Entry.WorkspaceId,
    fetKnowledgeAccepted,
    FClock.UtcNow,
    FActor,
    Entry.Id.ToString
  ));
end;

end.
