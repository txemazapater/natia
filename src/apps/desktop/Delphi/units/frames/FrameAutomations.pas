unit FrameAutomations;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrameAutomations = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pnlCanvas: TPanel;
    lblCanvasHint: TLabel;
    shpTrigger: TShape;
    lblTrigger: TLabel;
    shpAgent: TShape;
    lblAgent: TLabel;
    shpNemo: TShape;
    lblNemo: TLabel;
    shpNotify: TShape;
    lblNotify: TLabel;
    shpLine1: TShape;
    shpLine2: TShape;
    shpLine3: TShape;
    pnlFlows: TPanel;
    lblFlows: TLabel;
    lstFlows: TListBox;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameAutomations.ApplyMockData;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  pnlCanvas.Color := TNatiaTheme.SurfaceAlt;
  pnlCanvas.ParentBackground := False;
  pnlFlows.Color := TNatiaTheme.Surface;
  pnlFlows.ParentBackground := False;

  lblTitle.Caption := 'Automatizaciones';
  lblTitle.Font.Size := 16;
  lblTitle.Font.Style := [fsBold];
  lblSubtitle.Caption := 'Workflows visuales · inspiración Node-RED / n8n · solo aspecto';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;

  lblCanvasHint.Caption := 'Lienzo de flujo (mock) — nodos no ejecutables';
  lblCanvasHint.Font.Color := TNatiaTheme.TextSecondary;

  shpTrigger.Brush.Color := TNatiaTheme.AccentSoft;
  shpTrigger.Pen.Color := TNatiaTheme.Border;
  lblTrigger.Caption := 'Trigger'#13#10'Git push';
  shpAgent.Brush.Color := TNatiaTheme.AccentSoft;
  shpAgent.Pen.Color := TNatiaTheme.Border;
  lblAgent.Caption := 'Agente'#13#10'Reviewer';
  shpNemo.Brush.Color := TNatiaTheme.AccentSoft;
  shpNemo.Pen.Color := TNatiaTheme.Border;
  lblNemo.Caption := 'NEMO'#13#10'Promover';
  shpNotify.Brush.Color := TNatiaTheme.AccentSoft;
  shpNotify.Pen.Color := TNatiaTheme.Border;
  lblNotify.Caption := 'Notify'#13#10'Status';

  shpLine1.Brush.Color := TNatiaTheme.Border;
  shpLine2.Brush.Color := TNatiaTheme.Border;
  shpLine3.Brush.Color := TNatiaTheme.Border;

  lblFlows.Caption := 'Flujos';
  lblFlows.Font.Style := [fsBold];
  lstFlows.Items.Clear;
  lstFlows.Items.Add('Review on push → NEMO');
  lstFlows.Items.Add('Nightly export workspace');
  lstFlows.Items.Add('Device heartbeat alert');
  lstFlows.Items.Add('Model health check');
  lstFlows.ItemIndex := 0;
end;

end.
