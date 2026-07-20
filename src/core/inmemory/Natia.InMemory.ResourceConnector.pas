unit Natia.InMemory.ResourceConnector;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Workspace,
  Natia.Domain.WorkspaceRuntime,
  Natia.Contracts.Resources;

type
  TInMemoryResourceConnector = class(TInterfacedObject, IResourceConnector)
  private
    FOutcomes: TDictionary<string, TConnectionOutcome>;
    FDefaultOutcome: TConnectionOutcome;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetOutcome(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
    procedure SetDefaultOutcome(const AOutcome: TConnectionOutcome);
    function Connect(const ABinding: TWorkspaceBinding): TConnectionOutcome;
  end;

implementation

{ TInMemoryResourceConnector }

constructor TInMemoryResourceConnector.Create;
begin
  inherited Create;
  FOutcomes := TDictionary<string, TConnectionOutcome>.Create;
  FDefaultOutcome := coSuccess;
end;

destructor TInMemoryResourceConnector.Destroy;
begin
  FOutcomes.Free;
  inherited;
end;

procedure TInMemoryResourceConnector.SetOutcome(const ABindingId: TBindingId; const AOutcome: TConnectionOutcome);
begin
  FOutcomes.AddOrSetValue(ABindingId.ToString, AOutcome);
end;

procedure TInMemoryResourceConnector.SetDefaultOutcome(const AOutcome: TConnectionOutcome);
begin
  FDefaultOutcome := AOutcome;
end;

function TInMemoryResourceConnector.Connect(const ABinding: TWorkspaceBinding): TConnectionOutcome;
begin
  if ABinding = nil then
    Exit(coFailure);
  if not FOutcomes.TryGetValue(ABinding.Id.ToString, Result) then
    Result := FDefaultOutcome;
end;

end.
