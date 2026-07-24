unit Natia.Visual.Provider.Phosphor;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Visual.Provider;

type
  TPhosphorAssetProvider = class(TInterfacedObject, IVisualAssetProvider)
  private
    FRoot: string;
    FIndexPath: string;
    FIcons: TDictionary<string, TDictionary<string, string>>;
    FIconCount: Integer;
    procedure ClearIcons;
    procedure LoadIndex;
    function ParseId(const AAssetId: string; out AName, AWeight: string): Boolean;
    function IsSafeName(const AValue: string): Boolean;
  public
    constructor Create(const APhosphorRoot, AIndexPath: string);
    destructor Destroy; override;

    function ProviderId: string;
    function CanHandle(const AAssetId: string): Boolean;
    function Exists(const AAssetId: string): Boolean;
    function ResolveSourcePath(const AAssetId: string): string;
    function IconCount: Integer;
  end;

  EPhosphorAssetError = class(Exception);

implementation

uses
  System.Classes,
  System.IOUtils,
  System.JSON,
  System.StrUtils,
  Natia.Visual.Logging;

const
  CScheme = 'phosphor://';
  CAllowedWeights: array[0..3] of string = ('regular', 'duotone', 'fill', 'bold');

function WeightAllowed(const AWeight: string): Boolean;
var
  W: string;
begin
  for W in CAllowedWeights do
    if SameText(W, AWeight) then
      Exit(True);
  Result := False;
end;

constructor TPhosphorAssetProvider.Create(const APhosphorRoot, AIndexPath: string);
begin
  inherited Create;
  FRoot := ExcludeTrailingPathDelimiter(TPath.GetFullPath(APhosphorRoot));
  FIndexPath := TPath.GetFullPath(AIndexPath);
  FIcons := TDictionary<string, TDictionary<string, string>>.Create;
  LoadIndex;
end;

destructor TPhosphorAssetProvider.Destroy;
begin
  ClearIcons;
  FIcons.Free;
  inherited;
end;

procedure TPhosphorAssetProvider.ClearIcons;
var
  Pair: TPair<string, TDictionary<string, string>>;
begin
  for Pair in FIcons do
    Pair.Value.Free;
  FIcons.Clear;
  FIconCount := 0;
end;

procedure TPhosphorAssetProvider.LoadIndex;
var
  Text: string;
  Root: TJSONObject;
  IconsObj: TJSONObject;
  IconPair: TJSONPair;
  WeightPair: TJSONPair;
  Weights: TDictionary<string, string>;
  IconObj: TJSONObject;
begin
  ClearIcons;
  if not TFile.Exists(FIndexPath) then
    raise EPhosphorAssetError.CreateFmt('Phosphor index not found: %s', [FIndexPath]);

  Text := TFile.ReadAllText(FIndexPath, TEncoding.UTF8);
  Root := TJSONObject.ParseJSONValue(Text) as TJSONObject;
  if Root = nil then
    raise EPhosphorAssetError.Create('Invalid Phosphor index JSON');
  try
    IconsObj := Root.GetValue('icons') as TJSONObject;
    if IconsObj = nil then
      raise EPhosphorAssetError.Create('Phosphor index missing "icons"');

    for IconPair in IconsObj do
    begin
      IconObj := IconPair.JsonValue as TJSONObject;
      if IconObj = nil then
        Continue;
      Weights := TDictionary<string, string>.Create;
      for WeightPair in IconObj do
        Weights.AddOrSetValue(LowerCase(WeightPair.JsonString.Value), WeightPair.JsonValue.Value);
      FIcons.AddOrSetValue(LowerCase(IconPair.JsonString.Value), Weights);
    end;
    FIconCount := FIcons.Count;
  finally
    Root.Free;
  end;

  VisualLogFmt(vllInfo, 'VAR catalog loaded: %d icons', [FIconCount]);
end;

function TPhosphorAssetProvider.IsSafeName(const AValue: string): Boolean;
var
  C: Char;
begin
  Result := False;
  if AValue = '' then
    Exit;
  if AValue.Contains('..') or AValue.Contains('/') or AValue.Contains('\')
    or AValue.Contains(':') then
    Exit;
  for C in AValue do
    if not CharInSet(C, ['a'..'z', 'A'..'Z', '0'..'9', '-', '_']) then
      Exit;
  Result := True;
end;

function TPhosphorAssetProvider.ParseId(const AAssetId: string; out AName, AWeight: string): Boolean;
var
  Raw, Body, LeftPart, RightPart: string;
  P: Integer;
begin
  Result := False;
  AName := '';
  AWeight := '';
  Raw := Trim(AAssetId);
  if not StartsText(CScheme, Raw) then
    Exit;
  Body := Trim(Copy(Raw, Length(CScheme) + 1, MaxInt));
  if Body = '' then
    Exit;

  P := Pos('/', Body);
  if P <= 1 then
    Exit;
  LeftPart := Copy(Body, 1, P - 1);
  RightPart := Copy(Body, P + 1, MaxInt);
  if (LeftPart = '') or (RightPart = '') then
    Exit;
  { Exactly one path segment for name and one for weight. }
  if Pos('/', RightPart) > 0 then
    Exit;
  if not IsSafeName(LeftPart) or not IsSafeName(RightPart) then
    Exit;
  if not WeightAllowed(RightPart) then
    Exit;
  AName := LowerCase(LeftPart);
  AWeight := LowerCase(RightPart);
  Result := True;
end;

function TPhosphorAssetProvider.ProviderId: string;
begin
  Result := 'phosphor';
end;

function TPhosphorAssetProvider.CanHandle(const AAssetId: string): Boolean;
begin
  Result := StartsText(CScheme, Trim(AAssetId));
end;

function TPhosphorAssetProvider.Exists(const AAssetId: string): Boolean;
var
  Name, Weight, Rel, Full: string;
  Weights: TDictionary<string, string>;
begin
  Result := False;
  if not ParseId(AAssetId, Name, Weight) then
    Exit;
  if not FIcons.TryGetValue(Name, Weights) then
    Exit;
  if not Weights.TryGetValue(Weight, Rel) then
    Exit;
  Full := TPath.Combine(FRoot, StringReplace(Rel, '/', PathDelim, [rfReplaceAll]));
  Result := TFile.Exists(Full);
end;

function TPhosphorAssetProvider.ResolveSourcePath(const AAssetId: string): string;
var
  Name, Weight, Rel: string;
  Weights: TDictionary<string, string>;
  Full: string;
begin
  Result := '';
  if not ParseId(AAssetId, Name, Weight) then
    raise EPhosphorAssetError.CreateFmt('Invalid phosphor id: %s', [AAssetId]);
  if not FIcons.TryGetValue(Name, Weights) then
    raise EPhosphorAssetError.CreateFmt('Unknown phosphor icon: %s', [Name]);
  if not Weights.TryGetValue(Weight, Rel) then
    raise EPhosphorAssetError.CreateFmt('Weight %s not available for %s', [Weight, Name]);
  Full := TPath.Combine(FRoot, StringReplace(Rel, '/', PathDelim, [rfReplaceAll]));
  Full := TPath.GetFullPath(Full);
  if not StartsText(TPath.GetFullPath(FRoot), Full) then
    raise EPhosphorAssetError.Create('Resolved path escapes phosphor root');
  if not TFile.Exists(Full) then
    raise EPhosphorAssetError.CreateFmt('SVG missing: %s', [Full]);
  Result := Full;
end;

function TPhosphorAssetProvider.IconCount: Integer;
begin
  Result := FIconCount;
end;

end.
