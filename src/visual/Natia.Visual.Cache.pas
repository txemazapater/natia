unit Natia.Visual.Cache;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  Vcl.Graphics,
  Natia.Visual.Types;

type
  TVisualAssetCache = class
  private
    FItems: TObjectDictionary<string, TBitmap>;
  public
    constructor Create;
    destructor Destroy; override;

    function TryGet(const AKey: string; out ABitmap: TBitmap): Boolean;
    procedure Put(const AKey: string; ABitmap: TBitmap);
    procedure Clear;
    function Count: Integer;
  end;

implementation

constructor TVisualAssetCache.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TBitmap>.Create([doOwnsValues]);
end;

destructor TVisualAssetCache.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TVisualAssetCache.TryGet(const AKey: string; out ABitmap: TBitmap): Boolean;
begin
  Result := FItems.TryGetValue(AKey, ABitmap);
end;

procedure TVisualAssetCache.Put(const AKey: string; ABitmap: TBitmap);
var
  Owned: TBitmap;
begin
  if ABitmap = nil then
    Exit;
  Owned := TBitmap.Create;
  try
    Owned.Assign(ABitmap);
    FItems.AddOrSetValue(AKey, Owned);
    Owned := nil;
  finally
    Owned.Free;
  end;
end;

procedure TVisualAssetCache.Clear;
begin
  FItems.Clear;
end;

function TVisualAssetCache.Count: Integer;
begin
  Result := FItems.Count;
end;

end.
