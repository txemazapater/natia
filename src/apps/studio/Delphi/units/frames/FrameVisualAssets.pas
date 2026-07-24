unit FrameVisualAssets;

{ Visual Asset Registry lab — gallery + diagnostics for VAR 0.1. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrameVisualAssets = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pnlControls: TPanel;
    lblWeight: TLabel;
    cmbWeight: TComboBox;
    lblSize: TLabel;
    cmbSize: TComboBox;
    btnResolveTwice: TButton;
    btnFallbackTest: TButton;
    pnlDiag: TPanel;
    memDiag: TMemo;
    scrollGallery: TScrollBox;
    procedure cmbWeightChange(Sender: TObject);
    procedure cmbSizeChange(Sender: TObject);
    procedure btnResolveTwiceClick(Sender: TObject);
    procedure btnFallbackTestClick(Sender: TObject);
  private
    FIconNames: TStringList;
    FTiles: TObjectList<TPanel>;
    FDefaultWeight: string;
    FDefaultSize: Integer;
    procedure ClearTiles;
    procedure LoadDemoConfig;
    procedure RebuildGallery;
    function SelectedWeight: string;
    function SelectedSize: Integer;
    function CurrentDpi: Integer;
    procedure ShowResolvedDiag(const AAssetId: string; ATwice: Boolean);
    procedure StyleChrome;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyDemo;
  end;

implementation

{$R *.dfm}

uses
  System.JSON,
  System.IOUtils,
  Natia.Theme,
  Natia.Visual.Paths,
  Natia.Visual.Types,
  Natia.Visual.Bootstrap,
  Natia.Visual.Registry;

constructor TFrameVisualAssets.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIconNames := TStringList.Create;
  FTiles := TObjectList<TPanel>.Create(True);
  FDefaultWeight := 'duotone';
  FDefaultSize := 24;
end;

destructor TFrameVisualAssets.Destroy;
begin
  FTiles.Free;
  FIconNames.Free;
  inherited;
end;

procedure TFrameVisualAssets.StyleChrome;
begin
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  pnlControls.Color := TNatiaTheme.SurfaceAlt;
  pnlControls.ParentBackground := False;
  pnlDiag.Color := TNatiaTheme.Surface;
  pnlDiag.ParentBackground := False;
  scrollGallery.Color := TNatiaTheme.AppBack;
  lblTitle.Caption := 'Visual Asset Registry';
  lblTitle.Font.Style := [fsBold];
  lblSubtitle.Caption := 'NATIA Studio solicita iconos por identificador lógico (phosphor://), no por rutas SVG.';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;
  lblWeight.Caption := 'Peso';
  lblSize.Caption := 'Tamaño lógico';
  btnResolveTwice.Caption := 'Resolver ×2 (caché)';
  btnFallbackTest.Caption := 'Probar fallback';
  memDiag.Font.Name := 'Consolas';
  memDiag.Font.Size := 9;
end;

procedure TFrameVisualAssets.LoadDemoConfig;
var
  Path, Text: string;
  Root: TJSONValue;
  Obj: TJSONObject;
  Arr: TJSONArray;
  Item: TJSONValue;
  V: TJSONValue;
  I: Integer;
begin
  FIconNames.Clear;
  Path := FindNatiaRepoFile('config\visual\var-demo.json');
  if not TFile.Exists(Path) then
  begin
    FIconNames.AddStrings(['robot', 'brain', 'database', 'terminal', 'folder',
      'gear', 'warning', 'play', 'stop', 'magnifying-glass']);
    Exit;
  end;

  Text := TFile.ReadAllText(Path, TEncoding.UTF8);
  Root := TJSONObject.ParseJSONValue(Text);
  if Root = nil then
    Exit;
  try
    Obj := Root as TJSONObject;
    V := Obj.GetValue('defaultSize');
    if V <> nil then
      FDefaultSize := StrToIntDef(V.Value, 24);
    V := Obj.GetValue('defaultWeight');
    if V <> nil then
      FDefaultWeight := LowerCase(V.Value);
    V := Obj.GetValue('icons');
    if V is TJSONArray then
    begin
      Arr := TJSONArray(V);
      for I := 0 to Arr.Count - 1 do
      begin
        Item := Arr.Items[I];
        if Item is TJSONString then
          FIconNames.Add(TJSONString(Item).Value);
      end;
    end;
  finally
    Root.Free;
  end;
end;

function TFrameVisualAssets.SelectedWeight: string;
begin
  if cmbWeight.ItemIndex >= 0 then
    Result := LowerCase(cmbWeight.Items[cmbWeight.ItemIndex])
  else
    Result := FDefaultWeight;
end;

function TFrameVisualAssets.SelectedSize: Integer;
begin
  if cmbSize.ItemIndex >= 0 then
    Result := StrToIntDef(cmbSize.Items[cmbSize.ItemIndex], FDefaultSize)
  else
    Result := FDefaultSize;
end;

function TFrameVisualAssets.CurrentDpi: Integer;
begin
  Result := Screen.PixelsPerInch;
  if Result < 1 then
    Result := 96;
end;

procedure TFrameVisualAssets.ClearTiles;
begin
  FTiles.Clear;
end;

procedure TFrameVisualAssets.RebuildGallery;
var
  Name, AssetId: string;
  Tile: TPanel;
  Img: TImage;
  Cap: TLabel;
  Resolved: TResolvedVisualAsset;
  Col, Row, Cell, Gap, X, Y: Integer;
begin
  ClearTiles;
  Cell := SelectedSize + 48;
  Gap := 12;
  Col := 0;
  Row := 0;

  for Name in FIconNames do
  begin
    AssetId := Format('phosphor://%s/%s', [Name, SelectedWeight]);
    Tile := TPanel.Create(Self);
    Tile.Parent := scrollGallery;
    Tile.BevelOuter := bvNone;
    Tile.BorderStyle := bsSingle;
    Tile.Color := TNatiaTheme.CardBack;
    Tile.ParentBackground := False;
    Tile.Width := Cell;
    Tile.Height := Cell + 20;
    X := 12 + Col * (Cell + Gap);
    Y := 12 + Row * (Tile.Height + Gap);
    Tile.SetBounds(X, Y, Tile.Width, Tile.Height);
    Tile.Caption := '';

    Img := TImage.Create(Tile);
    Img.Parent := Tile;
    Img.SetBounds(12, 12, SelectedSize + 8, SelectedSize + 8);
    Img.Center := True;
    Img.Proportional := True;
    Img.Stretch := False;

    Cap := TLabel.Create(Tile);
    Cap.Parent := Tile;
    Cap.SetBounds(4, Tile.Height - 22, Tile.Width - 8, 16);
    Cap.Caption := Name;
    Cap.Alignment := taCenter;
    Cap.Font.Size := 7;
    Cap.Font.Color := TNatiaTheme.TextSecondary;

    Resolved := VisualAssets.ResolveIcon(AssetId, SelectedSize, CurrentDpi);
    try
      Img.Picture.Assign(Resolved.Bitmap);
      Cap.Hint := AssetId;
      Cap.ShowHint := True;
    finally
      Resolved.Free;
    end;

    FTiles.Add(Tile);
    Inc(Col);
    if Col >= 5 then
    begin
      Col := 0;
      Inc(Row);
    end;
  end;
end;

procedure TFrameVisualAssets.ShowResolvedDiag(const AAssetId: string; ATwice: Boolean);
var
  R1, R2: TResolvedVisualAsset;
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    R1 := VisualAssets.ResolveIcon(AAssetId, SelectedSize, CurrentDpi);
    try
      Lines.Add('Requested ID: ' + R1.RequestedId);
      Lines.Add('Resolved ID:  ' + R1.ResolvedId);
      Lines.Add(Format('Logical size: %d', [R1.LogicalSize]));
      Lines.Add(Format('Physical size: %d', [R1.PhysicalSize]));
      Lines.Add(Format('DPI: %d', [R1.Dpi]));
      Lines.Add(Format('From cache: %s', [BoolToStr(R1.FromCache, True)]));
      Lines.Add(Format('Used fallback: %s', [BoolToStr(R1.UsedFallback, True)]));
      Lines.Add(Format('Cache entries: %d', [VisualAssets.CacheCount]));
    finally
      R1.Free;
    end;

    if ATwice then
    begin
      Lines.Add('--- second resolve ---');
      R2 := VisualAssets.ResolveIcon(AAssetId, SelectedSize, CurrentDpi);
      try
        Lines.Add(Format('From cache: %s', [BoolToStr(R2.FromCache, True)]));
        Lines.Add(Format('Used fallback: %s', [BoolToStr(R2.UsedFallback, True)]));
      finally
        R2.Free;
      end;
    end;

    memDiag.Lines.Assign(Lines);
  finally
    Lines.Free;
  end;
end;

procedure TFrameVisualAssets.ApplyDemo;
var
  Idx: Integer;
begin
  StyleChrome;
  LoadDemoConfig;

  cmbWeight.Items.Clear;
  cmbWeight.Items.AddStrings(['regular', 'duotone', 'fill', 'bold']);
  Idx := cmbWeight.Items.IndexOf(FDefaultWeight);
  if Idx < 0 then
    Idx := 1;
  cmbWeight.ItemIndex := Idx;

  cmbSize.Items.Clear;
  cmbSize.Items.AddStrings(['16', '20', '24', '32', '48', '64']);
  Idx := cmbSize.Items.IndexOf(IntToStr(FDefaultSize));
  if Idx < 0 then
    Idx := 2;
  cmbSize.ItemIndex := Idx;

  RebuildGallery;
  if FIconNames.Count > 0 then
    ShowResolvedDiag(Format('phosphor://%s/%s', [FIconNames[0], SelectedWeight]), False);
end;

procedure TFrameVisualAssets.cmbWeightChange(Sender: TObject);
begin
  RebuildGallery;
end;

procedure TFrameVisualAssets.cmbSizeChange(Sender: TObject);
begin
  RebuildGallery;
end;

procedure TFrameVisualAssets.btnResolveTwiceClick(Sender: TObject);
var
  Name: string;
begin
  if FIconNames.Count = 0 then
    Name := 'robot'
  else
    Name := FIconNames[0];
  ShowResolvedDiag(Format('phosphor://%s/%s', [Name, SelectedWeight]), True);
end;

procedure TFrameVisualAssets.btnFallbackTestClick(Sender: TObject);
begin
  ShowResolvedDiag('phosphor://this-icon-does-not-exist/duotone', True);
  RebuildGallery;
end;

end.
