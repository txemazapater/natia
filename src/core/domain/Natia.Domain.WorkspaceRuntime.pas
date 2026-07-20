unit Natia.Domain.WorkspaceRuntime;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions;

type
  TReadinessStatus = (
    rsInactive,
    rsActivating,
    rsReady,
    rsDegraded,
    rsFailed
  );

  TConnectionOutcome = (coSuccess, coFailure, coDegraded);

  TSimulatedConnection = class
  private
    FBindingId: TBindingId;
    FOutcome: TConnectionOutcome;
  public
    constructor Create(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
    property BindingId: TBindingId read FBindingId;
    property Outcome: TConnectionOutcome read FOutcome;
  end;

  TWorkspaceRuntime = class
  private
    FRuntimeId: TRuntimeId;
    FWorkspaceId: TWorkspaceId;
    FReadiness: TReadinessStatus;
    FConnections: TObjectDictionary<string, TSimulatedConnection>;
    FFailureReason: string;
  public
    constructor Create(const ARuntimeId: TRuntimeId; const AWorkspaceId: TWorkspaceId);
    destructor Destroy; override;

    procedure BeginActivation;
    procedure CompleteActivationReady;
    procedure CompleteActivationFailed(const AReason: string);
    procedure MarkDegraded(const AReason: string = '');
    procedure Stop;
    procedure RegisterConnection(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
    function HasConnection(const ABindingId: TBindingId): Boolean;
    function ConnectionCount: Integer;

    property RuntimeId: TRuntimeId read FRuntimeId;
    property WorkspaceId: TWorkspaceId read FWorkspaceId;
    property Readiness: TReadinessStatus read FReadiness;
    property FailureReason: string read FFailureReason;
  end;

function ReadinessStatusToString(const AStatus: TReadinessStatus): string;

implementation

function ReadinessStatusToString(const AStatus: TReadinessStatus): string;
begin
  case AStatus of
    rsInactive: Result := 'Inactive';
    rsActivating: Result := 'Activating';
    rsReady: Result := 'Ready';
    rsDegraded: Result := 'Degraded';
    rsFailed: Result := 'Failed';
  else
    Result := 'Unknown';
  end;
end;

{ TSimulatedConnection }

constructor TSimulatedConnection.Create(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
begin
  inherited Create;
  FBindingId := ABindingId;
  FOutcome := AOutcome;
end;

{ TWorkspaceRuntime }

constructor TWorkspaceRuntime.Create(const ARuntimeId: TRuntimeId; const AWorkspaceId: TWorkspaceId);
begin
  inherited Create;
  FRuntimeId := ARuntimeId;
  FWorkspaceId := AWorkspaceId;
  FReadiness := rsInactive;
  FConnections := TObjectDictionary<string, TSimulatedConnection>.Create([doOwnsValues]);
  FFailureReason := '';
end;

destructor TWorkspaceRuntime.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TWorkspaceRuntime.BeginActivation;
begin
  if FReadiness <> rsInactive then
    raise ENatiaDomainError.Create('Runtime can only activate from Inactive');
  FReadiness := rsActivating;
end;

procedure TWorkspaceRuntime.CompleteActivationReady;
begin
  if FReadiness <> rsActivating then
    raise ENatiaDomainError.Create('Runtime is not activating');
  FReadiness := rsReady;
  FFailureReason := '';
end;

procedure TWorkspaceRuntime.CompleteActivationFailed(const AReason: string);
begin
  if FReadiness <> rsActivating then
    raise ENatiaDomainError.Create('Runtime is not activating');
  FReadiness := rsFailed;
  FFailureReason := AReason;
end;

procedure TWorkspaceRuntime.MarkDegraded(const AReason: string);
begin
  if FReadiness in [rsInactive, rsActivating, rsFailed] then
    raise ENatiaDomainError.Create('Runtime cannot be degraded from current status');
  FReadiness := rsDegraded;
  if AReason <> '' then
    FFailureReason := AReason;
end;

procedure TWorkspaceRuntime.Stop;
begin
  FReadiness := rsInactive;
  FConnections.Clear;
  FFailureReason := '';
end;

procedure TWorkspaceRuntime.RegisterConnection(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
var
  Key: string;
  Conn: TSimulatedConnection;
begin
  if FReadiness in [rsInactive, rsActivating, rsFailed] then
    raise ENatiaDomainError.Create('Runtime is not operable for connections');

  Key := ABindingId.ToString;
  Conn := TSimulatedConnection.Create(ABindingId, AOutcome);
  FConnections.AddOrSetValue(Key, Conn);

  case AOutcome of
    coSuccess:
      ; // leave Ready or Degraded as-is
    coFailure, coDegraded:
      begin
        if FReadiness = rsReady then
          MarkDegraded('Connection issue for binding ' + Key);
      end;
  end;
end;

function TWorkspaceRuntime.HasConnection(const ABindingId: TBindingId): Boolean;
begin
  Result := FConnections.ContainsKey(ABindingId.ToString);
end;

function TWorkspaceRuntime.ConnectionCount: Integer;
begin
  Result := FConnections.Count;
end;

end.
