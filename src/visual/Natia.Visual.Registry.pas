unit Natia.Visual.Registry;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Vcl.Graphics,
  Natia.Visual.Types,
  Natia.Visual.Provider,
  Natia.Visual.Cache;

type
  TVisualAssetRegistry = class
  private
    FProviders: TList<IVisualAssetProvider>;
    FCache: TVisualAssetCache;
    FFallbackId: string;
    function FindProvider(const AAssetId: string): IVisualAssetProvider;
    function TryRasterize(
      const AAssetId: string;
      const ARequest: TVisualAssetRequest;
      out ABitmap: TBitmap;
      out AResolvedId: string
    ): Boolean;
    function MakeEmergency(APhysicalSize: Integer; AState: TVisualAssetState): TBitmap;
    function Deliver(
      const ARequest: TVisualAssetRequest;
      const AResolvedId: string;
      ASource: TBitmap;
      AFromCache, AUsedFallback: Boolean
    ): TResolvedVisualAsset;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterProvider(const AProvider: IVisualAssetProvider);
    function Exists(const AAssetId: string): Boolean;
    function Resolve(const ARequest: TVisualAssetRequest): TResolvedVisualAsset;
    function ResolveIcon(
      const AAssetId: string;
      ALogicalSize: Integer;
      ADpi: Integer = 96;
      AState: TVisualAssetState = vasNormal
    ): TResolvedVisualAsset;
    procedure ClearCache;
    function CacheCount: Integer;
    property FallbackId: string read FFallbackId write FFallbackId;
  end;

implementation

uses
  Natia.Visual.Logging,
  Natia.Visual.SvgRasterizer;

const
  CDefaultFallback = 'phosphor://question/regular';

constructor TVisualAssetRegistry.Create;
begin
  inherited Create;
  FProviders := TList<IVisualAssetProvider>.Create;
  FCache := TVisualAssetCache.Create;
  FFallbackId := CDefaultFallback;
end;

destructor TVisualAssetRegistry.Destroy;
begin
  FCache.Free;
  FProviders.Free;
  inherited;
end;

procedure TVisualAssetRegistry.RegisterProvider(const AProvider: IVisualAssetProvider);
begin
  if AProvider = nil then
    Exit;
  FProviders.Add(AProvider);
  VisualLogFmt(vllInfo, 'VAR provider registered: %s', [AProvider.ProviderId]);
end;

function TVisualAssetRegistry.FindProvider(const AAssetId: string): IVisualAssetProvider;
var
  P: IVisualAssetProvider;
begin
  for P in FProviders do
    if P.CanHandle(AAssetId) then
      Exit(P);
  Result := nil;
end;

function TVisualAssetRegistry.Exists(const AAssetId: string): Boolean;
var
  P: IVisualAssetProvider;
begin
  P := FindProvider(AAssetId);
  Result := (P <> nil) and P.Exists(AAssetId);
end;

function TVisualAssetRegistry.MakeEmergency(APhysicalSize: Integer; AState: TVisualAssetState): TBitmap;
begin
  Result := TBitmap.Create;
  TSvgRasterizer.DrawEmergencyIcon(Result, APhysicalSize, TSvgRasterizer.ColorForState(AState));
end;

function TVisualAssetRegistry.TryRasterize(
  const AAssetId: string;
  const ARequest: TVisualAssetRequest;
  out ABitmap: TBitmap;
  out AResolvedId: string
): Boolean;
var
  P: IVisualAssetProvider;
  Path: string;
begin
  Result := False;
  ABitmap := nil;
  AResolvedId := '';
  P := FindProvider(AAssetId);
  if P = nil then
  begin
    VisualLogFmt(vllWarn, 'VAR asset not found: %s', [AAssetId]);
    Exit;
  end;
  if not P.Exists(AAssetId) then
  begin
    VisualLogFmt(vllWarn, 'VAR asset not found: %s', [AAssetId]);
    Exit;
  end;
  try
    Path := P.ResolveSourcePath(AAssetId);
  except
    on E: Exception do
    begin
      VisualLogFmt(vllWarn, 'VAR asset not found: %s (%s)', [AAssetId, E.Message]);
      Exit;
    end;
  end;
  if not TSvgRasterizer.RasterizeFile(Path, ARequest.PhysicalSize, ARequest.State, ABitmap) then
  begin
    VisualLogFmt(vllError, 'VAR render failed: %s', [AAssetId]);
    Exit;
  end;
  AResolvedId := AAssetId;
  Result := True;
end;

function TVisualAssetRegistry.Deliver(
  const ARequest: TVisualAssetRequest;
  const AResolvedId: string;
  ASource: TBitmap;
  AFromCache, AUsedFallback: Boolean
): TResolvedVisualAsset;
begin
  Result := TResolvedVisualAsset.Create;
  Result.RequestedId := ARequest.AssetId;
  Result.ResolvedId := AResolvedId;
  Result.FromCache := AFromCache;
  Result.UsedFallback := AUsedFallback;
  Result.LogicalSize := ARequest.LogicalSize;
  Result.PhysicalSize := ARequest.PhysicalSize;
  Result.Dpi := ARequest.Dpi;
  if ASource <> nil then
    Result.Bitmap.Assign(ASource);
end;

function TVisualAssetRegistry.Resolve(const ARequest: TVisualAssetRequest): TResolvedVisualAsset;
var
  Key: string;
  Cached, Rendered: TBitmap;
  ResolvedId: string;
  UsedFallback: Boolean;
begin
  Key := ARequest.CacheKey;
  if FCache.TryGet(Key, Cached) then
  begin
    VisualLogFmt(vllDebug, 'VAR cache hit: %s size=%d dpi=%d',
      [ARequest.AssetId, ARequest.LogicalSize, ARequest.Dpi]);
    Exit(Deliver(ARequest, ARequest.AssetId, Cached, True, False));
  end;

  VisualLogFmt(vllDebug, 'VAR cache miss: %s size=%d dpi=%d',
    [ARequest.AssetId, ARequest.LogicalSize, ARequest.Dpi]);

  UsedFallback := False;
  ResolvedId := ARequest.AssetId;
  Rendered := nil;
  try
    if not TryRasterize(ARequest.AssetId, ARequest, Rendered, ResolvedId) then
    begin
      UsedFallback := True;
      if SameText(ARequest.AssetId, FFallbackId) or
         not TryRasterize(FFallbackId, ARequest, Rendered, ResolvedId) then
      begin
        FreeAndNil(Rendered);
        ResolvedId := 'emergency://question';
        Rendered := MakeEmergency(ARequest.PhysicalSize, ARequest.State);
        VisualLogFmt(vllWarn, 'VAR fallback used: %s', [ResolvedId]);
      end
      else
      begin
        ResolvedId := FFallbackId;
        VisualLogFmt(vllWarn, 'VAR fallback used: %s', [FFallbackId]);
      end;
    end;

    FCache.Put(Key, Rendered);
    Result := Deliver(ARequest, ResolvedId, Rendered, False, UsedFallback);
  finally
    Rendered.Free;
  end;
end;

function TVisualAssetRegistry.ResolveIcon(
  const AAssetId: string;
  ALogicalSize: Integer;
  ADpi: Integer;
  AState: TVisualAssetState
): TResolvedVisualAsset;
begin
  Result := Resolve(TVisualAssetRequest.Create(AAssetId, ALogicalSize, ADpi, AState));
end;

procedure TVisualAssetRegistry.ClearCache;
begin
  FCache.Clear;
end;

function TVisualAssetRegistry.CacheCount: Integer;
begin
  Result := FCache.Count;
end;

end.
