unit Natia.InMemory.EventJournal;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Events,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions,
  Natia.Contracts.Events;

type
  TInMemoryEventJournal = class(TInterfacedObject, IEventJournal)
  private
    FEvents: TObjectList<TFactEvent>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Append(AEvent: TFactEvent);
    function Count: Integer;
    function CountForWorkspace(const AWorkspaceId: TWorkspaceId): Integer;
    function GetAll: TArray<TFactEvent>;
    function ContainsEventType(const AType: TFactEventType): Boolean;
  end;

  TInMemorySessionEventSink = class(TInterfacedObject, ISessionEventSink)
  private
    FEvents: TObjectList<TSessionEvent>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Append(AEvent: TSessionEvent);
    function Count: Integer;
    function GetAll: TArray<TSessionEvent>;
  end;

implementation

{ TInMemoryEventJournal }

constructor TInMemoryEventJournal.Create;
begin
  inherited Create;
  FEvents := TObjectList<TFactEvent>.Create(True);
end;

destructor TInMemoryEventJournal.Destroy;
begin
  FEvents.Free;
  inherited;
end;

procedure TInMemoryEventJournal.Append(AEvent: TFactEvent);
begin
  if AEvent = nil then
    raise ENatiaDomainError.Create('Fact event is required');
  FEvents.Add(AEvent);
end;

function TInMemoryEventJournal.Count: Integer;
begin
  Result := FEvents.Count;
end;

function TInMemoryEventJournal.CountForWorkspace(const AWorkspaceId: TWorkspaceId): Integer;
var
  Ev: TFactEvent;
begin
  Result := 0;
  for Ev in FEvents do
    if Ev.WorkspaceId = AWorkspaceId then
      Inc(Result);
end;

function TInMemoryEventJournal.GetAll: TArray<TFactEvent>;
begin
  Result := FEvents.ToArray;
end;

function TInMemoryEventJournal.ContainsEventType(const AType: TFactEventType): Boolean;
var
  Ev: TFactEvent;
begin
  for Ev in FEvents do
    if Ev.EventType = AType then
      Exit(True);
  Result := False;
end;

{ TInMemorySessionEventSink }

constructor TInMemorySessionEventSink.Create;
begin
  inherited Create;
  FEvents := TObjectList<TSessionEvent>.Create(True);
end;

destructor TInMemorySessionEventSink.Destroy;
begin
  FEvents.Free;
  inherited;
end;

procedure TInMemorySessionEventSink.Append(AEvent: TSessionEvent);
begin
  if AEvent = nil then
    raise ENatiaDomainError.Create('Session event is required');
  FEvents.Add(AEvent);
end;

function TInMemorySessionEventSink.Count: Integer;
begin
  Result := FEvents.Count;
end;

function TInMemorySessionEventSink.GetAll: TArray<TSessionEvent>;
begin
  Result := FEvents.ToArray;
end;

end.
