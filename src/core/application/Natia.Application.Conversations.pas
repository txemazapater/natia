unit Natia.Application.Conversations;

interface

uses
  System.SysUtils,
  Natia.Domain.Identifiers,
  Natia.Domain.Support,
  Natia.Domain.Workspace,
  Natia.Domain.Conversation,
  Natia.Domain.Events,
  Natia.Domain.Exceptions,
  Natia.Contracts.Repositories,
  Natia.Contracts.Events;

type
  TConversationApplication = class
  private
    FWorkspaces: IWorkspaceRepository;
    FConversations: IConversationRepository;
    FJournal: IEventJournal;
    FClock: IClock;
    FIds: IIdGenerator;
    FActor: string;
  public
    constructor Create(
      const AWorkspaces: IWorkspaceRepository;
      const AConversations: IConversationRepository;
      const AJournal: IEventJournal;
      const AClock: IClock;
      const AIds: IIdGenerator;
      const AActor: string = 'system'
    );

    function CreateConversation(
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string
    ): TConversation;

    function AppendMessage(
      const AConversationId: TConversationId;
      const ARole: TMessageRole;
      const AContent: string
    ): TMessage;

    procedure ArchiveConversation(const AConversationId: TConversationId);
  end;

implementation

{ TConversationApplication }

constructor TConversationApplication.Create(
  const AWorkspaces: IWorkspaceRepository;
  const AConversations: IConversationRepository;
  const AJournal: IEventJournal;
  const AClock: IClock;
  const AIds: IIdGenerator;
  const AActor: string
);
begin
  inherited Create;
  FWorkspaces := AWorkspaces;
  FConversations := AConversations;
  FJournal := AJournal;
  FClock := AClock;
  FIds := AIds;
  FActor := AActor;
end;

function TConversationApplication.CreateConversation(
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string
): TConversation;
var
  Ws: TWorkspace;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  if Ws.LifecycleStatus = lsArchived then
    raise ENatiaDomainError.Create('Cannot create conversation on archived workspace');

  Result := TConversation.Create(
    TConversationId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    ATitle
  );
  FConversations.Save(Result);
  FJournal.Append(TFactEvent.Create(
    TEventId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    fetConversationCreated,
    FClock.UtcNow,
    FActor,
    Result.Id.ToString
  ));
end;

function TConversationApplication.AppendMessage(
  const AConversationId: TConversationId;
  const ARole: TMessageRole;
  const AContent: string
): TMessage;
var
  Conv: TConversation;
  Msg: TMessage;
begin
  Conv := FConversations.FindById(AConversationId);
  if Conv = nil then
    raise ENatiaNotFound.Create('Conversation not found');

  Msg := TMessage.Create(
    TMessageId.CreateNew(FIds.NewGuid),
    ARole,
    AContent,
    FClock.UtcNow
  );
  Result := Conv.AppendMessage(Msg);
  // Intentionally no Fact Event per message.
end;

procedure TConversationApplication.ArchiveConversation(const AConversationId: TConversationId);
var
  Conv: TConversation;
begin
  Conv := FConversations.FindById(AConversationId);
  if Conv = nil then
    raise ENatiaNotFound.Create('Conversation not found');
  Conv.Archive;
  FJournal.Append(TFactEvent.Create(
    TEventId.CreateNew(FIds.NewGuid),
    Conv.WorkspaceId,
    fetConversationArchived,
    FClock.UtcNow,
    FActor,
    Conv.Id.ToString
  ));
end;

end.
