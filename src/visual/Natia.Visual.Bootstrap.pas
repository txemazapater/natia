unit Natia.Visual.Bootstrap;

{
  Central VAR initialization for NATIA Studio (and tests).
  Not a rigid singleton: Init creates; Shutdown frees; Get returns shared instance.
}

interface

uses
  Natia.Visual.Registry;

procedure InitVisualAssets;
procedure ShutdownVisualAssets;
function VisualAssets: TVisualAssetRegistry;
function VisualAssetsReady: Boolean;
function VisualAssetsRoot: string;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Natia.Visual.Paths,
  Natia.Visual.Logging,
  Natia.Visual.Provider,
  Natia.Visual.Provider.Phosphor;

var
  GRegistry: TVisualAssetRegistry;
  GAssetsRoot: string;

procedure InitVisualAssets;
var
  PhosphorRoot, IndexPath: string;
  Provider: IVisualAssetProvider;
begin
  if GRegistry <> nil then
    Exit;

  GAssetsRoot := FindNatiaAssetsRoot;
  PhosphorRoot := TPath.Combine(GAssetsRoot, 'icons\phosphor');
  IndexPath := TPath.Combine(PhosphorRoot, 'index.json');

  GRegistry := TVisualAssetRegistry.Create;
  try
    Provider := TPhosphorAssetProvider.Create(PhosphorRoot, IndexPath);
    GRegistry.RegisterProvider(Provider);
  except
    on E: Exception do
    begin
      VisualLogFmt(vllError, 'VAR init failed: %s', [E.Message]);
      { Keep empty registry so UI can still use emergency fallback. }
    end;
  end;
end;

procedure ShutdownVisualAssets;
begin
  FreeAndNil(GRegistry);
  GAssetsRoot := '';
end;

function VisualAssets: TVisualAssetRegistry;
begin
  if GRegistry = nil then
    InitVisualAssets;
  Result := GRegistry;
end;

function VisualAssetsReady: Boolean;
begin
  Result := GRegistry <> nil;
end;

function VisualAssetsRoot: string;
begin
  if GAssetsRoot = '' then
    GAssetsRoot := FindNatiaAssetsRoot;
  Result := GAssetsRoot;
end;

end.
