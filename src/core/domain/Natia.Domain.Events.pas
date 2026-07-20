unit Natia.Domain.Events;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers;

type
  TFactEventType = (
    fetWorkspaceCreated,
    fetWorkspaceRenamed,
    fetWorkspaceArchived,
    fetBindingAdded,
    fetBindingRemoved,
    fetConversationCreated,
    fetConversationArchived,
    fetKnowledgeAccepted
  );

  TSessionEventType = (
    setRuntimeActivationStarted,
    setRuntimeActivationCompleted,
    setRuntimeActivationFailed,
    setConnectionEstablished,
    setConnectionLost,
    setConnectionFailed,
    setConnectionDegraded
  );

  TFactEvent = class
  private
    FEventId: TEventId;
    FWorkspaceId: TWorkspaceId;
    FRuntimeId: TRuntimeId;
    FHasRuntimeId: Boolean;
    FEventType: TFactEventType;
    FOccurredAt: TDateTime;
    FActor: string;
    FCorrelationId: string;
    FCausationId: string;
    FSchemaVersion: Integer;
    FPayload: string;
  public
    constructor Create(
      const AEventId: TEventId;
      const AWorkspaceId: TWorkspaceId;
      const AEventType: TFactEventType;
      const AOccurredAt: TDateTime;
      const AActor: string;
      const APayload: string;
      const ASchemaVersion: Integer = 1
    );

    procedure SetRuntimeId(const ARuntimeId: TRuntimeId);
    procedure SetCorrelationId(const AValue: string);
    procedure SetCausationId(const AValue: string);

    property EventId: TEventId read FEventId;
    property WorkspaceId: TWorkspaceId read FWorkspaceId;
    property RuntimeId: TRuntimeId read FRuntimeId;
    property HasRuntimeId: Boolean read FHasRuntimeId;
    property EventType: TFactEventType read FEventType;
    property OccurredAt: TDateTime read FOccurredAt;
    property Actor: string read FActor;
    property CorrelationId: string read FCorrelationId;
    property CausationId: string read FCausationId;
    property SchemaVersion: Integer read FSchemaVersion;
    property Payload: string read FPayload;
  end;

  TSessionEvent = class
  private
    FEventType: TSessionEventType;
    FWorkspaceId: TWorkspaceId;
    FRuntimeId: TRuntimeId;
    FOccurredAt: TDateTime;
    FDetail: string;
  public
    constructor Create(
      const AEventType: TSessionEventType;
      const AWorkspaceId: TWorkspaceId;
      const ARuntimeId: TRuntimeId;
      const AOccurredAt: TDateTime;
      const ADetail: string
    );
    property EventType: TSessionEventType read FEventType;
    property WorkspaceId: TWorkspaceId read FWorkspaceId;
    property RuntimeId: TRuntimeId read FRuntimeId;
    property OccurredAt: TDateTime read FOccurredAt;
    property Detail: string read FDetail;
  end;

function FactEventTypeToString(const AType: TFactEventType): string;

implementation

function FactEventTypeToString(const AType: TFactEventType): string;
begin
  case AType of
    fetWorkspaceCreated: Result := 'WorkspaceCreated';
    fetWorkspaceRenamed: Result := 'WorkspaceRenamed';
    fetWorkspaceArchived: Result := 'WorkspaceArchived';
    fetBindingAdded: Result := 'BindingAdded';
    fetBindingRemoved: Result := 'BindingRemoved';
    fetConversationCreated: Result := 'ConversationCreated';
    fetConversationArchived: Result := 'ConversationArchived';
    fetKnowledgeAccepted: Result := 'KnowledgeAccepted';
  else
    Result := 'Unknown';
  end;
end;

{ TFactEvent }

constructor TFactEvent.Create(
  const AEventId: TEventId;
  const AWorkspaceId: TWorkspaceId;
  const AEventType: TFactEventType;
  const AOccurredAt: TDateTime;
  const AActor: string;
  const APayload: string;
  const ASchemaVersion: Integer
);
begin
  inherited Create;
  FEventId := AEventId;
  FWorkspaceId := AWorkspaceId;
  FHasRuntimeId := False;
  FEventType := AEventType;
  FOccurredAt := AOccurredAt;
  FActor := AActor;
  FPayload := APayload;
  FSchemaVersion := ASchemaVersion;
  FCorrelationId := '';
  FCausationId := '';
end;

procedure TFactEvent.SetRuntimeId(const ARuntimeId: TRuntimeId);
begin
  FRuntimeId := ARuntimeId;
  FHasRuntimeId := True;
end;

procedure TFactEvent.SetCorrelationId(const AValue: string);
begin
  FCorrelationId := AValue;
end;

procedure TFactEvent.SetCausationId(const AValue: string);
begin
  FCausationId := AValue;
end;

{ TSessionEvent }

constructor TSessionEvent.Create(
  const AEventType: TSessionEventType;
  const AWorkspaceId: TWorkspaceId;
  const ARuntimeId: TRuntimeId;
  const AOccurredAt: TDateTime;
  const ADetail: string
);
begin
  inherited Create;
  FEventType := AEventType;
  FWorkspaceId := AWorkspaceId;
  FRuntimeId := ARuntimeId;
  FOccurredAt := AOccurredAt;
  FDetail := ADetail;
end;

end.
