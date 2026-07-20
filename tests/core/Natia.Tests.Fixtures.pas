unit Natia.Tests.Fixtures;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Support,
  Natia.Domain.Identifiers,
  Natia.Contracts.Repositories,
  Natia.Contracts.Events,
  Natia.Contracts.Resources,
  Natia.Contracts.Export,
  Natia.InMemory.Repositories,
  Natia.InMemory.EventJournal,
  Natia.InMemory.ResourceConnector,
  Natia.InMemory.WorkspaceExporter,
  Natia.Application.Workspaces,
  Natia.Application.Conversations,
  Natia.Application.Knowledge;

type
  TFixedClock = class(TInterfacedObject, IClock)
  private
    FValue: TDateTime;
  public
    constructor Create(const AValue: TDateTime);
    function UtcNow: TDateTime;
    procedure SetValue(const AValue: TDateTime);
  end;

  TSequentialIdGenerator = class(TInterfacedObject, IIdGenerator)
  private
    FCounter: Integer;
  public
    constructor Create;
    function NewGuid: TGUID;
  end;

  TCoreTestContext = class
  private
    FClock: TFixedClock;
    FIds: TSequentialIdGenerator;
    FClockIntf: IClock;
    FIdsIntf: IIdGenerator;
    FWorkspaces: IWorkspaceRepository;
    FConversations: IConversationRepository;
    FKnowledge: IKnowledgeRepository;
    FJournal: IEventJournal;
    FSessions: ISessionEventSink;
    FConnector: TInMemoryResourceConnector;
    FConnectorIntf: IResourceConnector;
    FExporter: IWorkspaceExporter;
    FWorkspaceApp: TWorkspaceApplication;
    FConversationApp: TConversationApplication;
    FKnowledgeApp: TKnowledgeApplication;
  public
    constructor Create;
    destructor Destroy; override;

    property Clock: TFixedClock read FClock;
    property Ids: TSequentialIdGenerator read FIds;
    property Workspaces: IWorkspaceRepository read FWorkspaces;
    property Conversations: IConversationRepository read FConversations;
    property Knowledge: IKnowledgeRepository read FKnowledge;
    property Journal: IEventJournal read FJournal;
    property Sessions: ISessionEventSink read FSessions;
    property Connector: TInMemoryResourceConnector read FConnector;
    property Exporter: IWorkspaceExporter read FExporter;
    property WorkspaceApp: TWorkspaceApplication read FWorkspaceApp;
    property ConversationApp: TConversationApplication read FConversationApp;
    property KnowledgeApp: TKnowledgeApplication read FKnowledgeApp;
  end;

implementation

{ TFixedClock }

constructor TFixedClock.Create(const AValue: TDateTime);
begin
  inherited Create;
  FValue := AValue;
end;

function TFixedClock.UtcNow: TDateTime;
begin
  Result := FValue;
end;

procedure TFixedClock.SetValue(const AValue: TDateTime);
begin
  FValue := AValue;
end;

{ TSequentialIdGenerator }

constructor TSequentialIdGenerator.Create;
begin
  inherited Create;
  FCounter := 0;
end;

function TSequentialIdGenerator.NewGuid: TGUID;
begin
  Inc(FCounter);
  Result := TGUID.Empty;
  Result.D1 := Cardinal(FCounter);
end;

{ TCoreTestContext }

constructor TCoreTestContext.Create;
begin
  inherited Create;
  FClock := TFixedClock.Create(EncodeDate(2026, 7, 20) + EncodeTime(12, 0, 0, 0));
  FIds := TSequentialIdGenerator.Create;
  FClockIntf := FClock;
  FIdsIntf := FIds;

  FWorkspaces := TInMemoryWorkspaceRepository.Create;
  FConversations := TInMemoryConversationRepository.Create;
  FKnowledge := TInMemoryKnowledgeRepository.Create;
  FJournal := TInMemoryEventJournal.Create;
  FSessions := TInMemorySessionEventSink.Create;
  FConnector := TInMemoryResourceConnector.Create;
  FConnectorIntf := FConnector;
  FExporter := TInMemoryWorkspaceExporter.Create(FWorkspaces, FConversations, FKnowledge);

  FWorkspaceApp := TWorkspaceApplication.Create(
    FWorkspaces, FJournal, FSessions, FConnectorIntf, FClockIntf, FIdsIntf, 'tester');
  FConversationApp := TConversationApplication.Create(
    FWorkspaces, FConversations, FJournal, FClockIntf, FIdsIntf, 'tester');
  FKnowledgeApp := TKnowledgeApplication.Create(
    FWorkspaces, FConversations, FKnowledge, FJournal, FClockIntf, FIdsIntf, 'tester');
end;

destructor TCoreTestContext.Destroy;
begin
  FKnowledgeApp.Free;
  FConversationApp.Free;
  FWorkspaceApp.Free;
  FExporter := nil;
  FConnectorIntf := nil;
  FSessions := nil;
  FJournal := nil;
  FKnowledge := nil;
  FConversations := nil;
  FWorkspaces := nil;
  FIdsIntf := nil;
  FClockIntf := nil;
  inherited;
end;

end.
