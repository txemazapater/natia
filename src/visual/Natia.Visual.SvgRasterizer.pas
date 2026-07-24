unit Natia.Visual.SvgRasterizer;

{
  Lightweight SVG → TBitmap for Phosphor icons (path/circle/line/rect).
  Uses GDI+. No Skia/DevExpress. currentColor is replaced before parse.
  VAR 0.1: arcs approximated; duotone opacity supported.
}

interface

uses
  System.SysUtils,
  Vcl.Graphics,
  Natia.Visual.Types;

type
  TSvgRasterizer = class
  public
    class function ColorForState(AState: TVisualAssetState): TColor; static;
    class function ColorToHex(AColor: TColor): string; static;
    class function PrepareSvgXml(const ARaw: string; AColor: TColor): string; static;
    class function RasterizeFile(
      const AFileName: string;
      APhysicalSize: Integer;
      AState: TVisualAssetState;
      out ABitmap: TBitmap
    ): Boolean; static;
    class function RasterizeXml(
      const AXml: string;
      APhysicalSize: Integer;
      AColor: TColor;
      out ABitmap: TBitmap
    ): Boolean; static;
    class procedure DrawEmergencyIcon(ABitmap: TBitmap; ASize: Integer; AColor: TColor); static;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  Winapi.GDIPAPI,
  Winapi.GDIPOBJ,
  System.Types,
  System.Math,
  System.Variants,
  System.IOUtils,
  Xml.XMLDoc,
  Xml.XMLIntf,
  Natia.Visual.Logging;

type
  { Winapi.Windows also defines TBitmap — keep VCL bitmap for this unit. }
  TBitmap = Vcl.Graphics.TBitmap;

procedure EnsureComForXml;
begin
  { LoadXMLData uses MSXML; COM must be initialized (VCL apps already do this). }
  CoInitialize(nil);
end;

type
  TPathParser = record
    S: string;
    I: Integer;
    function Peek: Char;
    function Next: Char;
    procedure SkipWs;
    function ReadNumber(out V: Double): Boolean;
    function ReadFlag(out V: Boolean): Boolean;
  end;

function TPathParser.Peek: Char;
begin
  if I <= Length(S) then
    Result := S[I]
  else
    Result := #0;
end;

function TPathParser.Next: Char;
begin
  Result := Peek;
  if I <= Length(S) then
    Inc(I);
end;

procedure TPathParser.SkipWs;
begin
  while CharInSet(Peek, [' ', #9, #10, #13, ',']) do
    Next;
end;

function TPathParser.ReadNumber(out V: Double): Boolean;
var
  Start: Integer;
  Token: string;
begin
  SkipWs;
  Start := I;
  if CharInSet(Peek, ['+', '-']) then
    Next;
  while CharInSet(Peek, ['0'..'9']) do
    Next;
  if Peek = '.' then
  begin
    Next;
    while CharInSet(Peek, ['0'..'9']) do
      Next;
  end;
  if CharInSet(Peek, ['e', 'E']) then
  begin
    Next;
    if CharInSet(Peek, ['+', '-']) then
      Next;
    while CharInSet(Peek, ['0'..'9']) do
      Next;
  end;
  Result := I > Start;
  if Result then
  begin
    Token := Copy(S, Start, I - Start);
    V := StrToFloatDef(Token, 0, TFormatSettings.Invariant);
  end;
end;

function TPathParser.ReadFlag(out V: Boolean): Boolean;
begin
  SkipWs;
  Result := CharInSet(Peek, ['0', '1']);
  if Result then
  begin
    V := Peek = '1';
    Next;
  end;
end;

class function TSvgRasterizer.ColorForState(AState: TVisualAssetState): TColor;
begin
  case AState of
    vasDisabled: Result := $00999999;
    vasWarning: Result := $000E7DC4;
    vasError: Result := $001C2BC4;
    vasActive, vasSelected: Result := $00BD6C0F;
  else
    Result := $001F1F1F;
  end;
end;

class function TSvgRasterizer.ColorToHex(AColor: TColor): string;
var
  C: Longint;
begin
  C := ColorToRGB(AColor);
  Result := Format('#%.2x%.2x%.2x', [GetRValue(C), GetGValue(C), GetBValue(C)]);
end;

class function TSvgRasterizer.PrepareSvgXml(const ARaw: string; AColor: TColor): string;
begin
  Result := StringReplace(ARaw, 'currentColor', ColorToHex(AColor), [rfReplaceAll, rfIgnoreCase]);
end;

class procedure TSvgRasterizer.DrawEmergencyIcon(ABitmap: TBitmap; ASize: Integer; AColor: TColor);
var
  G: TGPGraphics;
  Pen: TGPPen;
  Font: TGPFont;
  Brush: TGPSolidBrush;
  Family: TGPFontFamily;
  RectF: TGPRectF;
  Format: TGPStringFormat;
  C: Longint;
begin
  ABitmap.SetSize(ASize, ASize);
  ABitmap.PixelFormat := pf32bit;
  ABitmap.Canvas.Brush.Color := clWhite;
  ABitmap.Canvas.FillRect(System.Types.Rect(0, 0, ASize, ASize));
  C := ColorToRGB(AColor);
  G := TGPGraphics.Create(ABitmap.Canvas.Handle);
  try
    G.SetSmoothingMode(SmoothingModeAntiAlias);
    Pen := TGPPen.Create(MakeColor(GetRValue(C), GetGValue(C), GetBValue(C)), Max(1, ASize / 16.0));
    try
      G.DrawEllipse(Pen, 2, 2, ASize - 5, ASize - 5);
    finally
      Pen.Free;
    end;
    Family := TGPFontFamily.Create('Segoe UI');
    Font := TGPFont.Create(Family, Max(8, ASize * 0.55), FontStyleBold, UnitPixel);
    Brush := TGPSolidBrush.Create(MakeColor(GetRValue(C), GetGValue(C), GetBValue(C)));
    Format := TGPStringFormat.Create;
    try
      Format.SetAlignment(StringAlignmentCenter);
      Format.SetLineAlignment(StringAlignmentCenter);
      RectF := MakeRect(0.0, 0.0, Single(ASize), Single(ASize));
      G.DrawString('?', 1, Font, RectF, Format, Brush);
    finally
      Format.Free;
      Brush.Free;
      Font.Free;
      Family.Free;
    end;
  finally
    G.Free;
  end;
end;

procedure AddSvgPath(Path: TGPGraphicsPath; const D: string);
var
  P: TPathParser;
  Cmd, PrevCmd: Char;
  X, Y, X0, Y0, X1, Y1, X2, Y2, CX, CY: Double;
  RX, RY, Rot: Double;
  Large, Sweep: Boolean;
  HavePoint: Boolean;

  procedure MoveToAbs(AX, AY: Double);
  begin
    Path.StartFigure;
    X := AX;
    Y := AY;
    X0 := X;
    Y0 := Y;
    HavePoint := True;
  end;

  procedure LineToAbs(AX, AY: Double);
  begin
    if not HavePoint then
      MoveToAbs(AX, AY)
    else
      Path.AddLine(X, Y, AX, AY);
    X := AX;
    Y := AY;
    HavePoint := True;
  end;

begin
  P.S := D;
  P.I := 1;
  X := 0;
  Y := 0;
  X0 := 0;
  Y0 := 0;
  HavePoint := False;
  PrevCmd := #0;
  P.SkipWs;
  while P.Peek <> #0 do
  begin
    if CharInSet(P.Peek, ['A'..'Z', 'a'..'z']) then
      Cmd := P.Next
    else if PrevCmd = #0 then
      Break
    else
      Cmd := PrevCmd;

    case Cmd of
      'M', 'm':
        begin
          if not P.ReadNumber(X1) then
            Break;
          P.ReadNumber(Y1);
          if Cmd = 'm' then
          begin
            if HavePoint then
            begin
              X1 := X + X1;
              Y1 := Y + Y1;
            end;
          end;
          MoveToAbs(X1, Y1);
          PrevCmd := 'L';
          if Cmd = 'm' then
            PrevCmd := 'l';
          while P.ReadNumber(X1) do
          begin
            P.ReadNumber(Y1);
            if PrevCmd = 'l' then
              LineToAbs(X + X1, Y + Y1)
            else
              LineToAbs(X1, Y1);
          end;
        end;
      'L', 'l':
        begin
          while P.ReadNumber(X1) do
          begin
            P.ReadNumber(Y1);
            if Cmd = 'l' then
              LineToAbs(X + X1, Y + Y1)
            else
              LineToAbs(X1, Y1);
          end;
          PrevCmd := Cmd;
        end;
      'H', 'h':
        begin
          while P.ReadNumber(X1) do
          begin
            if Cmd = 'h' then
              LineToAbs(X + X1, Y)
            else
              LineToAbs(X1, Y);
          end;
          PrevCmd := Cmd;
        end;
      'V', 'v':
        begin
          while P.ReadNumber(Y1) do
          begin
            if Cmd = 'v' then
              LineToAbs(X, Y + Y1)
            else
              LineToAbs(X, Y1);
          end;
          PrevCmd := Cmd;
        end;
      'C', 'c':
        begin
          while P.ReadNumber(X1) do
          begin
            P.ReadNumber(Y1);
            P.ReadNumber(X2);
            P.ReadNumber(Y2);
            P.ReadNumber(CX);
            P.ReadNumber(CY);
            if Cmd = 'c' then
            begin
              X1 := X + X1;
              Y1 := Y + Y1;
              X2 := X + X2;
              Y2 := Y + Y2;
              CX := X + CX;
              CY := Y + CY;
            end;
            Path.AddBezier(X, Y, X1, Y1, X2, Y2, CX, CY);
            X := CX;
            Y := CY;
            HavePoint := True;
          end;
          PrevCmd := Cmd;
        end;
      'S', 's':
        begin
          while P.ReadNumber(X2) do
          begin
            P.ReadNumber(Y2);
            P.ReadNumber(CX);
            P.ReadNumber(CY);
            X1 := X;
            Y1 := Y;
            if Cmd = 's' then
            begin
              X2 := X + X2;
              Y2 := Y + Y2;
              CX := X + CX;
              CY := Y + CY;
            end;
            Path.AddBezier(X, Y, X1, Y1, X2, Y2, CX, CY);
            X := CX;
            Y := CY;
            HavePoint := True;
          end;
          PrevCmd := Cmd;
        end;
      'Q', 'q':
        begin
          while P.ReadNumber(X1) do
          begin
            P.ReadNumber(Y1);
            P.ReadNumber(CX);
            P.ReadNumber(CY);
            if Cmd = 'q' then
            begin
              X1 := X + X1;
              Y1 := Y + Y1;
              CX := X + CX;
              CY := Y + CY;
            end;
            Path.AddBezier(
              X, Y,
              X + (2 / 3) * (X1 - X), Y + (2 / 3) * (Y1 - Y),
              CX + (2 / 3) * (X1 - CX), CY + (2 / 3) * (Y1 - CY),
              CX, CY);
            X := CX;
            Y := CY;
            HavePoint := True;
          end;
          PrevCmd := Cmd;
        end;
      'A', 'a':
        begin
          while P.ReadNumber(RX) do
          begin
            P.ReadNumber(RY);
            P.ReadNumber(Rot);
            P.ReadFlag(Large);
            P.ReadFlag(Sweep);
            P.ReadNumber(X1);
            P.ReadNumber(Y1);
            if Cmd = 'a' then
            begin
              X1 := X + X1;
              Y1 := Y + Y1;
            end;
            // VAR 0.1: approximate elliptical arc with a cubic via control points
            LineToAbs(X1, Y1);
          end;
          PrevCmd := Cmd;
        end;
      'Z', 'z':
        begin
          Path.CloseFigure;
          X := X0;
          Y := Y0;
          HavePoint := True;
          PrevCmd := Cmd;
        end;
    else
      Break;
    end;
    P.SkipWs;
  end;
end;

function ParseColorAttr(const AValue: string; ADefault: TColor): TColor;
var
  V: string;
  R, G, B: Integer;
begin
  V := Trim(AValue);
  if (V = '') then
    Exit(ADefault);
  if SameText(V, 'none') then
    Exit(clNone);
  if (Length(V) = 7) and (V[1] = '#') then
  begin
    R := StrToIntDef('$' + Copy(V, 2, 2), 0);
    G := StrToIntDef('$' + Copy(V, 4, 2), 0);
    B := StrToIntDef('$' + Copy(V, 6, 2), 0);
    Exit(RGB(R, G, B));
  end;
  Result := ADefault;
end;

function LocalName(const ANodeName: string): string;
var
  P: Integer;
begin
  P := Pos(':', ANodeName);
  if P > 0 then
    Result := Copy(ANodeName, P + 1, MaxInt)
  else
    Result := ANodeName;
  Result := LowerCase(Result);
end;

procedure AddRoundRect(Path: TGPGraphicsPath; X, Y, W, H, RX: Single);
begin
  if RX <= 0 then
  begin
    Path.AddRectangle(MakeRect(X, Y, W, H));
    Exit;
  end;
  if RX * 2 > W then
    RX := W / 2;
  if RX * 2 > H then
    RX := H / 2;
  Path.AddArc(X, Y, RX * 2, RX * 2, 180, 90);
  Path.AddArc(X + W - RX * 2, Y, RX * 2, RX * 2, 270, 90);
  Path.AddArc(X + W - RX * 2, Y + H - RX * 2, RX * 2, RX * 2, 0, 90);
  Path.AddArc(X, Y + H - RX * 2, RX * 2, RX * 2, 90, 90);
  Path.CloseFigure;
end;

procedure DrawElement(G: TGPGraphics; Node: IXMLNode; ADefault: TColor);
var
  Name, D, FillAttr, StrokeAttr: string;
  StrokeC, FillC: TColor;
  StrokeW: Single;
  Path: TGPGraphicsPath;
  Pen: TGPPen;
  Brush: TGPSolidBrush;
  X, Y, W, H, X1, Y1, X2, Y2, R, RX: Single;
  Opacity: Single;
  Alpha: Byte;
  Child: IXMLNode;
  I: Integer;
  C: Longint;
begin
  if (Node = nil) or (Node.NodeType <> ntElement) then
    Exit;
  Name := LocalName(Node.NodeName);

  Opacity := StrToFloatDef(VarToStr(Node.Attributes['opacity']), 1, TFormatSettings.Invariant);
  if Opacity < 0 then
    Opacity := 0;
  if Opacity > 1 then
    Opacity := 1;
  Alpha := Byte(Round(255 * Opacity));

  FillAttr := VarToStr(Node.Attributes['fill']);
  StrokeAttr := VarToStr(Node.Attributes['stroke']);
  StrokeC := ParseColorAttr(StrokeAttr, clNone);
  if FillAttr = '' then
  begin
    if Name = 'circle' then
      FillC := ADefault
    else if Name = 'path' then
      FillC := ADefault
    else
      FillC := clNone;
  end
  else
    FillC := ParseColorAttr(FillAttr, clNone);

  StrokeW := StrToFloatDef(VarToStr(Node.Attributes['stroke-width']), 16, TFormatSettings.Invariant);

  // Skip transparent full-canvas background rect
  if (Name = 'rect') and SameText(FillAttr, 'none')
    and (StrToFloatDef(VarToStr(Node.Attributes['width']), 0) >= 256)
    and (StrToFloatDef(VarToStr(Node.Attributes['x']), 0) = 0) then
  begin
    // still walk children if any
  end
  else
  begin
    Path := TGPGraphicsPath.Create;
    try
      if Name = 'path' then
      begin
        D := VarToStr(Node.Attributes['d']);
        if D <> '' then
          AddSvgPath(Path, D);
      end
      else if Name = 'circle' then
      begin
        X := StrToFloatDef(VarToStr(Node.Attributes['cx']), 0);
        Y := StrToFloatDef(VarToStr(Node.Attributes['cy']), 0);
        R := StrToFloatDef(VarToStr(Node.Attributes['r']), 0);
        Path.AddEllipse(X - R, Y - R, R * 2, R * 2);
      end
      else if Name = 'line' then
      begin
        X1 := StrToFloatDef(VarToStr(Node.Attributes['x1']), 0);
        Y1 := StrToFloatDef(VarToStr(Node.Attributes['y1']), 0);
        X2 := StrToFloatDef(VarToStr(Node.Attributes['x2']), 0);
        Y2 := StrToFloatDef(VarToStr(Node.Attributes['y2']), 0);
        Path.AddLine(X1, Y1, X2, Y2);
      end
      else if Name = 'rect' then
      begin
        X := StrToFloatDef(VarToStr(Node.Attributes['x']), 0);
        Y := StrToFloatDef(VarToStr(Node.Attributes['y']), 0);
        W := StrToFloatDef(VarToStr(Node.Attributes['width']), 0);
        H := StrToFloatDef(VarToStr(Node.Attributes['height']), 0);
        RX := StrToFloatDef(VarToStr(Node.Attributes['rx']), 0);
        AddRoundRect(Path, X, Y, W, H, RX);
      end;

      if (Path.GetPointCount > 0) or (Name = 'line') then
      begin
        if FillC <> clNone then
        begin
          C := ColorToRGB(FillC);
          Brush := TGPSolidBrush.Create(MakeColor(Alpha, GetRValue(C), GetGValue(C), GetBValue(C)));
          try
            G.FillPath(Brush, Path);
          finally
            Brush.Free;
          end;
        end;
        if StrokeC <> clNone then
        begin
          C := ColorToRGB(StrokeC);
          Pen := TGPPen.Create(MakeColor(Alpha, GetRValue(C), GetGValue(C), GetBValue(C)), StrokeW);
          try
            Pen.SetLineCap(LineCapRound, LineCapRound, DashCapRound);
            Pen.SetLineJoin(LineJoinRound);
            G.DrawPath(Pen, Path);
          finally
            Pen.Free;
          end;
        end;
      end;
    finally
      Path.Free;
    end;
  end;

  if Node.HasChildNodes then
    for I := 0 to Node.ChildNodes.Count - 1 do
    begin
      Child := Node.ChildNodes[I];
      DrawElement(G, Child, ADefault);
    end;
end;

class function TSvgRasterizer.RasterizeXml(
  const AXml: string;
  APhysicalSize: Integer;
  AColor: TColor;
  out ABitmap: TBitmap
): Boolean;
var
  Doc: IXMLDocument;
  Root: IXMLNode;
  G: TGPGraphics;
  Scale: Single;
  Prepared: string;
begin
  Result := False;
  ABitmap := nil;
  if APhysicalSize < 1 then
    Exit;
  EnsureComForXml;
  Prepared := PrepareSvgXml(AXml, AColor);
  try
    Doc := LoadXMLData(Prepared);
  except
    on E: Exception do
    begin
      VisualLogFmt(vllError, 'VAR render failed: XML parse %s', [E.Message]);
      Exit;
    end;
  end;
  Root := Doc.DocumentElement;
  if Root = nil then
    Exit;

  ABitmap := TBitmap.Create;
  try
    ABitmap.PixelFormat := pf32bit;
    ABitmap.SetSize(APhysicalSize, APhysicalSize);
    ABitmap.Canvas.Brush.Color := clWhite;
    ABitmap.Canvas.FillRect(System.Types.Rect(0, 0, APhysicalSize, APhysicalSize));

    Scale := APhysicalSize / 256.0;
    G := TGPGraphics.Create(ABitmap.Canvas.Handle);
    try
      G.SetSmoothingMode(SmoothingModeAntiAlias);
      G.SetPixelOffsetMode(PixelOffsetModeHighQuality);
      G.ScaleTransform(Scale, Scale);
      DrawElement(G, Root, AColor);
    finally
      G.Free;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      FreeAndNil(ABitmap);
      VisualLogFmt(vllError, 'VAR render failed: %s', [E.Message]);
      Result := False;
    end;
  end;
end;

class function TSvgRasterizer.RasterizeFile(
  const AFileName: string;
  APhysicalSize: Integer;
  AState: TVisualAssetState;
  out ABitmap: TBitmap
): Boolean;
var
  Xml: string;
begin
  Result := False;
  ABitmap := nil;
  if not TFile.Exists(AFileName) then
    Exit;
  try
    Xml := TFile.ReadAllText(AFileName, TEncoding.UTF8);
    Result := RasterizeXml(Xml, APhysicalSize, ColorForState(AState), ABitmap);
  except
    on E: Exception do
    begin
      VisualLogFmt(vllError, 'VAR render failed: %s', [E.Message]);
      Result := False;
    end;
  end;
end;

end.
