unit Natia.Visual.Types;

interface

uses
  System.SysUtils,
  Vcl.Graphics;

type
  TVisualAssetKind = (
    vakIcon,
    vakImage,
    vakIllustration,
    vakLogo
  );

  TVisualAssetState = (
    vasNormal,
    vasHover,
    vasActive,
    vasSelected,
    vasDisabled,
    vasWarning,
    vasError
  );

  TVisualAssetRequest = record
  private
    FAssetId: string;
    FLogicalSize: Integer;
    FDpi: Integer;
    FState: TVisualAssetState;
  public
    class function Create(
      const AAssetId: string;
      ALogicalSize: Integer;
      ADpi: Integer = 96;
      AState: TVisualAssetState = vasNormal
    ): TVisualAssetRequest; static;

    function PhysicalSize: Integer;
    function CacheKey: string;
    function StateName: string;

    property AssetId: string read FAssetId;
    property LogicalSize: Integer read FLogicalSize;
    property Dpi: Integer read FDpi;
    property State: TVisualAssetState read FState;
  end;

  TResolvedVisualAsset = class
  private
    FBitmap: TBitmap;
    FRequestedId: string;
    FResolvedId: string;
    FFromCache: Boolean;
    FUsedFallback: Boolean;
    FLogicalSize: Integer;
    FPhysicalSize: Integer;
    FDpi: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>Owns a private bitmap copy. Caller frees this object.</summary>
    property Bitmap: TBitmap read FBitmap;
    property RequestedId: string read FRequestedId write FRequestedId;
    property ResolvedId: string read FResolvedId write FResolvedId;
    property FromCache: Boolean read FFromCache write FFromCache;
    property UsedFallback: Boolean read FUsedFallback write FUsedFallback;
    property LogicalSize: Integer read FLogicalSize write FLogicalSize;
    property PhysicalSize: Integer read FPhysicalSize write FPhysicalSize;
    property Dpi: Integer read FDpi write FDpi;
  end;

function VisualAssetStateToString(AState: TVisualAssetState): string;

implementation

function VisualAssetStateToString(AState: TVisualAssetState): string;
begin
  case AState of
    vasHover: Result := 'hover';
    vasActive: Result := 'active';
    vasSelected: Result := 'selected';
    vasDisabled: Result := 'disabled';
    vasWarning: Result := 'warning';
    vasError: Result := 'error';
  else
    Result := 'normal';
  end;
end;

class function TVisualAssetRequest.Create(
  const AAssetId: string;
  ALogicalSize: Integer;
  ADpi: Integer;
  AState: TVisualAssetState
): TVisualAssetRequest;
begin
  if ALogicalSize < 1 then
    ALogicalSize := 16;
  if ADpi < 1 then
    ADpi := 96;
  Result.FAssetId := Trim(AAssetId);
  Result.FLogicalSize := ALogicalSize;
  Result.FDpi := ADpi;
  Result.FState := AState;
end;

function TVisualAssetRequest.PhysicalSize: Integer;
begin
  Result := Round(FLogicalSize * FDpi / 96.0);
  if Result < 1 then
    Result := 1;
end;

function TVisualAssetRequest.StateName: string;
begin
  Result := VisualAssetStateToString(FState);
end;

function TVisualAssetRequest.CacheKey: string;
begin
  Result := Format('%s|%d|%d|%s', [LowerCase(FAssetId), FLogicalSize, FDpi, StateName]);
end;

constructor TResolvedVisualAsset.Create;
begin
  inherited Create;
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  FBitmap.AlphaFormat := afPremultiplied;
end;

destructor TResolvedVisualAsset.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

end.
