unit Natia.Domain.Workspace;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions;

type
  TLifecycleStatus = (lsDraft, lsActive, lsArchived);

  TBindingKind = (bkFileLocation, bkGenericEndpoint);

  TSecretReference = record
    Key: string;
    class function Create(const AKey: string): TSecretReference; static;
  end;

  TWorkspaceBinding = class
  private
    FId: TBindingId;
    FKind: TBindingKind;
    FDisplayName: string;
    FRole: string;
    FRequired: Boolean;
    FLocationOrEndpoint: string;
    FSecretRefs: TArray<TSecretReference>;
  public
    constructor Create(
      const AId: TBindingId;
      const AKind: TBindingKind;
      const ADisplayName: string;
      const ARole: string;
      const ARequired: Boolean;
      const ALocationOrEndpoint: string;
      const ASecretRefs: TArray<TSecretReference>
    );
    property Id: TBindingId read FId;
    property Kind: TBindingKind read FKind;
    property DisplayName: string read FDisplayName;
    property Role: string read FRole;
    property Required: Boolean read FRequired;
    property LocationOrEndpoint: string read FLocationOrEndpoint;
    property SecretRefs: TArray<TSecretReference> read FSecretRefs;
  end;

  TWorkspace = class
  private
    FId: TWorkspaceId;
    FName: string;
    FInstructions: string;
    FProviderId: string;
    FModelId: string;
    FLifecycleStatus: TLifecycleStatus;
    FBindings: TObjectList<TWorkspaceBinding>;
    procedure EnsureNotArchived;
    procedure SetName(const AName: string);
  public
    constructor Create(
      const AId: TWorkspaceId;
      const AName: string;
      const AInstructions: string = '';
      const AProviderId: string = '';
      const AModelId: string = ''
    );
    destructor Destroy; override;

    procedure Rename(const ANewName: string);
    procedure ActivateAdministratively;
    procedure Archive;
    function AddBinding(ABinding: TWorkspaceBinding): TWorkspaceBinding;
    procedure RemoveBinding(const ABindingId: TBindingId);
    function FindBinding(const ABindingId: TBindingId): TWorkspaceBinding;
    function BindingCount: Integer;
    function GetBindings: TArray<TWorkspaceBinding>;

    property Id: TWorkspaceId read FId;
    property Name: string read FName;
    property Instructions: string read FInstructions write FInstructions;
    property ProviderId: string read FProviderId write FProviderId;
    property ModelId: string read FModelId write FModelId;
    property LifecycleStatus: TLifecycleStatus read FLifecycleStatus;
  end;

function LifecycleStatusToString(const AStatus: TLifecycleStatus): string;
function BindingKindToString(const AKind: TBindingKind): string;

implementation

function LifecycleStatusToString(const AStatus: TLifecycleStatus): string;
begin
  case AStatus of
    lsDraft: Result := 'Draft';
    lsActive: Result := 'Active';
    lsArchived: Result := 'Archived';
  else
    Result := 'Unknown';
  end;
end;

function BindingKindToString(const AKind: TBindingKind): string;
begin
  case AKind of
    bkFileLocation: Result := 'FileLocation';
    bkGenericEndpoint: Result := 'GenericEndpoint';
  else
    Result := 'Unknown';
  end;
end;

{ TSecretReference }

class function TSecretReference.Create(const AKey: string): TSecretReference;
begin
  Result.Key := AKey;
end;

{ TWorkspaceBinding }

constructor TWorkspaceBinding.Create(
  const AId: TBindingId;
  const AKind: TBindingKind;
  const ADisplayName: string;
  const ARole: string;
  const ARequired: Boolean;
  const ALocationOrEndpoint: string;
  const ASecretRefs: TArray<TSecretReference>
);
begin
  inherited Create;
  if Trim(ADisplayName) = '' then
    raise ENatiaDomainError.Create('Binding display name is required');
  FId := AId;
  FKind := AKind;
  FDisplayName := Trim(ADisplayName);
  FRole := ARole;
  FRequired := ARequired;
  FLocationOrEndpoint := ALocationOrEndpoint;
  FSecretRefs := ASecretRefs;
end;

{ TWorkspace }

constructor TWorkspace.Create(
  const AId: TWorkspaceId;
  const AName: string;
  const AInstructions: string;
  const AProviderId: string;
  const AModelId: string
);
begin
  inherited Create;
  FId := AId;
  SetName(AName);
  FInstructions := AInstructions;
  FProviderId := AProviderId;
  FModelId := AModelId;
  FLifecycleStatus := lsDraft;
  FBindings := TObjectList<TWorkspaceBinding>.Create(True);
end;

destructor TWorkspace.Destroy;
begin
  FBindings.Free;
  inherited;
end;

procedure TWorkspace.SetName(const AName: string);
begin
  if Trim(AName) = '' then
    raise ENatiaDomainError.Create('Workspace name is required');
  FName := Trim(AName);
end;

procedure TWorkspace.EnsureNotArchived;
begin
  if FLifecycleStatus = lsArchived then
    raise ENatiaDomainError.Create('Workspace is archived');
end;

procedure TWorkspace.Rename(const ANewName: string);
begin
  EnsureNotArchived;
  SetName(ANewName);
end;

procedure TWorkspace.ActivateAdministratively;
begin
  EnsureNotArchived;
  if FLifecycleStatus = lsActive then
    Exit;
  if FLifecycleStatus <> lsDraft then
    raise ENatiaDomainError.Create('Workspace cannot be activated from current status');
  FLifecycleStatus := lsActive;
end;

procedure TWorkspace.Archive;
begin
  if FLifecycleStatus = lsArchived then
    Exit;
  FLifecycleStatus := lsArchived;
end;

function TWorkspace.AddBinding(ABinding: TWorkspaceBinding): TWorkspaceBinding;
var
  Existing: TWorkspaceBinding;
begin
  EnsureNotArchived;
  if ABinding = nil then
    raise ENatiaDomainError.Create('Binding is required');
  Existing := FindBinding(ABinding.Id);
  if Existing <> nil then
  begin
    ABinding.Free;
    raise ENatiaConflict.Create('Binding already exists');
  end;
  FBindings.Add(ABinding);
  Result := ABinding;
end;

procedure TWorkspace.RemoveBinding(const ABindingId: TBindingId);
var
  I: Integer;
begin
  EnsureNotArchived;
  for I := 0 to FBindings.Count - 1 do
    if FBindings[I].Id = ABindingId then
    begin
      FBindings.Delete(I);
      Exit;
    end;
  raise ENatiaNotFound.CreateFmt('Binding not found: %s', [ABindingId.ToString]);
end;

function TWorkspace.FindBinding(const ABindingId: TBindingId): TWorkspaceBinding;
var
  Binding: TWorkspaceBinding;
begin
  for Binding in FBindings do
    if Binding.Id = ABindingId then
      Exit(Binding);
  Result := nil;
end;

function TWorkspace.BindingCount: Integer;
begin
  Result := FBindings.Count;
end;

function TWorkspace.GetBindings: TArray<TWorkspaceBinding>;
begin
  Result := FBindings.ToArray;
end;

end.
