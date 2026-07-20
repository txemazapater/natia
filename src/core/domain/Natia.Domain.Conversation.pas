unit Natia.Domain.Conversation;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions;

type
  TMessageRole = (mrSystem, mrUser, mrAssistant, mrTool);

  TConversationStatus = (csActive, csArchived);

  TMessage = class
  private
    FId: TMessageId;
    FRole: TMessageRole;
    FContent: string;
    FOccurredAt: TDateTime;
  public
    constructor Create(
      const AId: TMessageId;
      const ARole: TMessageRole;
      const AContent: string;
      const AOccurredAt: TDateTime
    );
    property Id: TMessageId read FId;
    property Role: TMessageRole read FRole;
    property Content: string read FContent;
    property OccurredAt: TDateTime read FOccurredAt;
  end;

  TConversation = class
  private
    FId: TConversationId;
    FWorkspaceId: TWorkspaceId;
    FTitle: string;
    FStatus: TConversationStatus;
    FMessages: TObjectList<TMessage>;
  public
    constructor Create(
      const AId: TConversationId;
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string
    );
    destructor Destroy; override;

    function AppendMessage(AMessage: TMessage): TMessage;
    procedure Archive;
    function MessageCount: Integer;
    function FindMessage(const AMessageId: TMessageId): TMessage;

    property Id: TConversationId read FId;
    property WorkspaceId: TWorkspaceId read FWorkspaceId;
    property Title: string read FTitle;
    property Status: TConversationStatus read FStatus;
  end;

implementation

{ TMessage }

constructor TMessage.Create(
  const AId: TMessageId;
  const ARole: TMessageRole;
  const AContent: string;
  const AOccurredAt: TDateTime
);
begin
  inherited Create;
  FId := AId;
  FRole := ARole;
  FContent := AContent;
  FOccurredAt := AOccurredAt;
end;

{ TConversation }

constructor TConversation.Create(
  const AId: TConversationId;
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string
);
begin
  inherited Create;
  FId := AId;
  FWorkspaceId := AWorkspaceId;
  FTitle := ATitle;
  FStatus := csActive;
  FMessages := TObjectList<TMessage>.Create(True);
end;

destructor TConversation.Destroy;
begin
  FMessages.Free;
  inherited;
end;

function TConversation.AppendMessage(AMessage: TMessage): TMessage;
begin
  if FStatus = csArchived then
    raise ENatiaDomainError.Create('Conversation is archived');
  if AMessage = nil then
    raise ENatiaDomainError.Create('Message is required');
  FMessages.Add(AMessage);
  Result := AMessage;
end;

procedure TConversation.Archive;
begin
  FStatus := csArchived;
end;

function TConversation.MessageCount: Integer;
begin
  Result := FMessages.Count;
end;

function TConversation.FindMessage(const AMessageId: TMessageId): TMessage;
var
  Msg: TMessage;
begin
  for Msg in FMessages do
    if Msg.Id = AMessageId then
      Exit(Msg);
  Result := nil;
end;

end.
