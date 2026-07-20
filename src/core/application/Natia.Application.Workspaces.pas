unit Natia.Application.Workspaces;

interface

uses
  System.SysUtils,
  Natia.Domain.Identifiers,
  Natia.Domain.Support,
  Natia.Domain.Workspace,
  Natia.Domain.WorkspaceRuntime,
  Natia.Domain.Events,
  Natia.Domain.Exceptions,
  Natia.Contracts.Repositories,
  Natia.Contracts.Events,
  Natia.Contracts.Resources;

type
  TWorkspaceApplication = class
  private
    FWorkspaces: IWorkspaceRepository;
    FJournal: IEventJournal;
    FSessions: ISessionEventSink;
    FConnector: IResourceConnector;
    FClock: IClock;
    FIds: IIdGenerator;
    FActor: string;
    function NewFact(
      const AWorkspaceId: TWorkspaceId;
      const AType: TFactEventType;
      const APayload: string
    ): TFactEvent;
  public
    constructor Create(
      const AWorkspaces: IWorkspaceRepository;
      const AJournal: IEventJournal;
      const ASessions: ISessionEventSink;
      const AConnector: IResourceConnector;
      const AClock: IClock;
      const AIds: IIdGenerator;
      const AActor: string = 'system'
    );

    function CreateWorkspace(
      const AName: string;
      const AInstructions: string = '';
      const AProviderId: string = '';
      const AModelId: string = ''
    ): TWorkspace;

    procedure RenameWorkspace(const AWorkspaceId: TWorkspaceId; const ANewName: string);
    procedure ActivateWorkspaceAdministratively(const AWorkspaceId: TWorkspaceId);
    procedure ArchiveWorkspace(const AWorkspaceId: TWorkspaceId);

    function AddFileLocationBinding(
      const AWorkspaceId: TWorkspaceId;
      const ADisplayName: string;
      const APath: string;
      const ARequired: Boolean = False;
      const ARole: string = 'workspace-files'
    ): TWorkspaceBinding;

    function AddGenericEndpointBinding(
      const AWorkspaceId: TWorkspaceId;
      const ADisplayName: string;
      const AEndpoint: string;
      const ARequired: Boolean = False;
      const ARole: string = 'endpoint'
    ): TWorkspaceBinding;

    procedure RemoveBinding(const AWorkspaceId: TWorkspaceId; const ABindingId: TBindingId);

    function ActivateRuntime(const AWorkspaceId: TWorkspaceId): TWorkspaceRuntime;
    function EnsureConnected(ARuntime: TWorkspaceRuntime; const ABindingId: TBindingId): TConnectionOutcome;
  end;

implementation

{ TWorkspaceApplication }

constructor TWorkspaceApplication.Create(
  const AWorkspaces: IWorkspaceRepository;
  const AJournal: IEventJournal;
  const ASessions: ISessionEventSink;
  const AConnector: IResourceConnector;
  const AClock: IClock;
  const AIds: IIdGenerator;
  const AActor: string
);
begin
  inherited Create;
  FWorkspaces := AWorkspaces;
  FJournal := AJournal;
  FSessions := ASessions;
  FConnector := AConnector;
  FClock := AClock;
  FIds := AIds;
  FActor := AActor;
end;

function TWorkspaceApplication.NewFact(
  const AWorkspaceId: TWorkspaceId;
  const AType: TFactEventType;
  const APayload: string
): TFactEvent;
begin
  Result := TFactEvent.Create(
    TEventId.CreateNew(FIds.NewGuid),
    AWorkspaceId,
    AType,
    FClock.UtcNow,
    FActor,
    APayload
  );
end;

function TWorkspaceApplication.CreateWorkspace(
  const AName: string;
  const AInstructions: string;
  const AProviderId: string;
  const AModelId: string
): TWorkspace;
var
  Id: TWorkspaceId;
begin
  Id := TWorkspaceId.CreateNew(FIds.NewGuid);
  Result := TWorkspace.Create(Id, AName, AInstructions, AProviderId, AModelId);
  FWorkspaces.Save(Result);
  FJournal.Append(NewFact(Id, fetWorkspaceCreated, Result.Name));
end;

procedure TWorkspaceApplication.RenameWorkspace(const AWorkspaceId: TWorkspaceId; const ANewName: string);
var
  Ws: TWorkspace;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Ws.Rename(ANewName);
  FJournal.Append(NewFact(AWorkspaceId, fetWorkspaceRenamed, ANewName));
end;

procedure TWorkspaceApplication.ActivateWorkspaceAdministratively(const AWorkspaceId: TWorkspaceId);
var
  Ws: TWorkspace;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Ws.ActivateAdministratively;
end;

procedure TWorkspaceApplication.ArchiveWorkspace(const AWorkspaceId: TWorkspaceId);
var
  Ws: TWorkspace;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Ws.Archive;
  FJournal.Append(NewFact(AWorkspaceId, fetWorkspaceArchived, Ws.Name));
end;

function TWorkspaceApplication.AddFileLocationBinding(
  const AWorkspaceId: TWorkspaceId;
  const ADisplayName: string;
  const APath: string;
  const ARequired: Boolean;
  const ARole: string
): TWorkspaceBinding;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  EmptySecrets: TArray<TSecretReference>;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  SetLength(EmptySecrets, 0);
  Binding := TWorkspaceBinding.Create(
    TBindingId.CreateNew(FIds.NewGuid),
    bkFileLocation,
    ADisplayName,
    ARole,
    ARequired,
    APath,
    EmptySecrets
  );
  Result := Ws.AddBinding(Binding);
  FJournal.Append(NewFact(AWorkspaceId, fetBindingAdded, Result.Id.ToString));
end;

function TWorkspaceApplication.AddGenericEndpointBinding(
  const AWorkspaceId: TWorkspaceId;
  const ADisplayName: string;
  const AEndpoint: string;
  const ARequired: Boolean;
  const ARole: string
): TWorkspaceBinding;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  EmptySecrets: TArray<TSecretReference>;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  SetLength(EmptySecrets, 0);
  Binding := TWorkspaceBinding.Create(
    TBindingId.CreateNew(FIds.NewGuid),
    bkGenericEndpoint,
    ADisplayName,
    ARole,
    ARequired,
    AEndpoint,
    EmptySecrets
  );
  Result := Ws.AddBinding(Binding);
  FJournal.Append(NewFact(AWorkspaceId, fetBindingAdded, Result.Id.ToString));
end;

procedure TWorkspaceApplication.RemoveBinding(const AWorkspaceId: TWorkspaceId; const ABindingId: TBindingId);
var
  Ws: TWorkspace;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');
  Ws.RemoveBinding(ABindingId);
  FJournal.Append(NewFact(AWorkspaceId, fetBindingRemoved, ABindingId.ToString));
end;

function TWorkspaceApplication.ActivateRuntime(const AWorkspaceId: TWorkspaceId): TWorkspaceRuntime;
var
  Ws: TWorkspace;
  Runtime: TWorkspaceRuntime;
begin
  Ws := FWorkspaces.FindById(AWorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');

  Runtime := TWorkspaceRuntime.Create(
    TRuntimeId.CreateNew(FIds.NewGuid),
    AWorkspaceId
  );

  FSessions.Append(TSessionEvent.Create(
    setRuntimeActivationStarted, AWorkspaceId, Runtime.RuntimeId, FClock.UtcNow, ''));

  Runtime.BeginActivation;

  if Ws.LifecycleStatus = lsArchived then
  begin
    Runtime.CompleteActivationFailed('Workspace is archived');
    FSessions.Append(TSessionEvent.Create(
      setRuntimeActivationFailed, AWorkspaceId, Runtime.RuntimeId, FClock.UtcNow, Runtime.FailureReason));
    Result := Runtime;
    Exit;
  end;

  // Lazy activation: do not connect bindings.
  Runtime.CompleteActivationReady;
  FSessions.Append(TSessionEvent.Create(
    setRuntimeActivationCompleted, AWorkspaceId, Runtime.RuntimeId, FClock.UtcNow, 'Ready'));
  Result := Runtime;
end;

function TWorkspaceApplication.EnsureConnected(
  ARuntime: TWorkspaceRuntime;
  const ABindingId: TBindingId
): TConnectionOutcome;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  Outcome: TConnectionOutcome;
begin
  if ARuntime = nil then
    raise ENatiaDomainError.Create('Runtime is required');

  Ws := FWorkspaces.FindById(ARuntime.WorkspaceId);
  if Ws = nil then
    raise ENatiaNotFound.Create('Workspace not found');

  Binding := Ws.FindBinding(ABindingId);
  if Binding = nil then
    raise ENatiaNotFound.Create('Binding not found');

  Outcome := FConnector.Connect(Binding);
  ARuntime.RegisterConnection(ABindingId, Outcome);

  case Outcome of
    coSuccess:
      FSessions.Append(TSessionEvent.Create(
        setConnectionEstablished, ARuntime.WorkspaceId, ARuntime.RuntimeId, FClock.UtcNow, ABindingId.ToString));
    coFailure:
      FSessions.Append(TSessionEvent.Create(
        setConnectionFailed, ARuntime.WorkspaceId, ARuntime.RuntimeId, FClock.UtcNow, ABindingId.ToString));
    coDegraded:
      FSessions.Append(TSessionEvent.Create(
        setConnectionDegraded, ARuntime.WorkspaceId, ARuntime.RuntimeId, FClock.UtcNow, ABindingId.ToString));
  end;

  Result := Outcome;
end;

end.
