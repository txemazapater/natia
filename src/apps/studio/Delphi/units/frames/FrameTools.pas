unit FrameTools;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrameTools = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    scrollTools: TScrollBox;
    pnlDocker: TPanel;
    lblDocker: TLabel;
    memDocker: TMemo;
    pnlGitHub: TPanel;
    lblGitHub: TLabel;
    memGitHub: TMemo;
    pnlSQL: TPanel;
    lblSQL: TLabel;
    memSQL: TMemo;
    pnlOdoo: TPanel;
    lblOdoo: TLabel;
    memOdoo: TMemo;
    pnlGLPI: TPanel;
    lblGLPI: TLabel;
    memGLPI: TMemo;
    pnlPowerShell: TPanel;
    lblPowerShell: TLabel;
    memPowerShell: TMemo;
    pnlPython: TPanel;
    lblPython: TLabel;
    memPython: TMemo;
    pnlMCP: TPanel;
    lblMCP: TLabel;
    memMCP: TMemo;
    pnlOllama: TPanel;
    lblOllama: TLabel;
    memOllama: TMemo;
    pnlOpenAI: TPanel;
    lblOpenAI: TLabel;
    memOpenAI: TMemo;
    pnlAzure: TPanel;
    lblAzure: TLabel;
    memAzure: TMemo;
    pnlHA: TPanel;
    lblHA: TLabel;
    memHA: TMemo;
    pnlNodeRED: TPanel;
    lblNodeRED: TLabel;
    memNodeRED: TMemo;
    pnln8n: TPanel;
    lbln8n: TLabel;
    memn8n: TMemo;
  private
    procedure StyleTool(APanel: TPanel; ATitle: TLabel; const ACaption: string;
      AMemo: TMemo; const ABody: string);
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameTools.StyleTool(APanel: TPanel; ATitle: TLabel;
  const ACaption: string; AMemo: TMemo; const ABody: string);
begin
  APanel.Color := TNatiaTheme.CardBack;
  APanel.ParentBackground := False;
  APanel.BevelOuter := bvNone;
  APanel.BorderStyle := bsSingle;
  ATitle.Caption := ACaption;
  ATitle.Font.Style := [fsBold];
  AMemo.Lines.Text := ABody;
  AMemo.ReadOnly := True;
  AMemo.BorderStyle := bsNone;
  AMemo.Color := TNatiaTheme.CardBack;
end;

procedure TFrameTools.ApplyMockData;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  lblTitle.Caption := 'Herramientas';
  lblTitle.Font.Size := 16;
  lblTitle.Font.Style := [fsBold];
  lblSubtitle.Caption := 'Integraciones futuras · sin comunicación real (Sprint 0)';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;

  StyleTool(pnlDocker, lblDocker, 'Docker', memDocker,
    'Contenedores: 0 running'#13#10'Compose: n/a'#13#10'Estado: reservado');
  StyleTool(pnlGitHub, lblGitHub, 'GitHub', memGitHub,
    'Repos: txemazapater/natia'#13#10'Issues: mock'#13#10'Actions: —');
  StyleTool(pnlSQL, lblSQL, 'SQL', memSQL,
    'Conexiones: 0'#13#10'Explorador de esquemas'#13#10'Consultas: mock');
  StyleTool(pnlOdoo, lblOdoo, 'Odoo', memOdoo,
    'ERP corporativo'#13#10'Binding: pendiente'#13#10'Sin API en Sprint 0');
  StyleTool(pnlGLPI, lblGLPI, 'GLPI', memGLPI,
    'Tickets IT'#13#10'Inventario'#13#10'Conector futuro');
  StyleTool(pnlPowerShell, lblPowerShell, 'PowerShell', memPowerShell,
    'Host embebido'#13#10'Sesiones remotas'#13#10'Consola inferior');
  StyleTool(pnlPython, lblPython, 'Python', memPython,
    'REPL / scripts'#13#10'venv manager'#13#10'Playground IA');
  StyleTool(pnlMCP, lblMCP, 'MCP', memMCP,
    'Servers: 0'#13#10'Inspector preparado'#13#10'Sin stdio aún');
  StyleTool(pnlOllama, lblOllama, 'Ollama', memOllama,
    'localhost:11434'#13#10'Modelos: mock list'#13#10'Sin HTTP');
  StyleTool(pnlOpenAI, lblOpenAI, 'OpenAI', memOpenAI,
    'Cloud provider'#13#10'Claves: SecretReference'#13#10'Sin llamadas');
  StyleTool(pnlAzure, lblAzure, 'Azure', memAzure,
    'OpenAI / AI Studio'#13#10'Subscriptions'#13#10'Reservado');
  StyleTool(pnlHA, lblHA, 'Home Assistant', memHA,
    'IoT / automatización hogar'#13#10'Device Manager link');
  StyleTool(pnlNodeRED, lblNodeRED, 'Node-RED', memNodeRED,
    'Flujos visuales'#13#10'Ver Automatizaciones');
  StyleTool(pnln8n, lbln8n, 'n8n', memn8n,
    'Workflows corporativos'#13#10'Ver Automatizaciones');
end;

end.
