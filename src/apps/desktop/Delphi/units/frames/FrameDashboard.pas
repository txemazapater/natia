unit FrameDashboard;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrameDashboard = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    scrollCards: TScrollBox;
    pnlCardRecentChats: TPanel;
    lblCardRecentChats: TLabel;
    lstRecentChats: TListBox;
    pnlCardProjects: TPanel;
    lblCardProjects: TLabel;
    lstProjects: TListBox;
    pnlCardNemo: TPanel;
    lblCardNemo: TLabel;
    lstNemo: TListBox;
    pnlCardModels: TPanel;
    lblCardModels: TLabel;
    lstModels: TListBox;
    pnlCardAgents: TPanel;
    lblCardAgents: TLabel;
    lstAgents: TListBox;
    pnlCardSystem: TPanel;
    lblCardSystem: TLabel;
    memSystem: TMemo;
    pnlCardActivity: TPanel;
    lblCardActivity: TLabel;
    lstActivity: TListBox;
    pnlCardTasks: TPanel;
    lblCardTasks: TLabel;
    lstTasks: TListBox;
    pnlCardNews: TPanel;
    lblCardNews: TLabel;
    lstNews: TListBox;
    pnlCardUpdates: TPanel;
    lblCardUpdates: TLabel;
    lstUpdates: TListBox;
  private
    procedure StyleCard(APanel: TPanel; ATitle: TLabel);
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameDashboard.StyleCard(APanel: TPanel; ATitle: TLabel);
begin
  APanel.Color := TNatiaTheme.CardBack;
  APanel.ParentBackground := False;
  APanel.BevelOuter := bvNone;
  APanel.BorderStyle := bsSingle;
  ATitle.Font.Style := [fsBold];
  ATitle.Font.Color := TNatiaTheme.TextPrimary;
  ATitle.Font.Name := 'Segoe UI';
end;

procedure TFrameDashboard.ApplyMockData;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  lblTitle.Caption := 'Home';
  lblTitle.Font.Size := 18;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Name := 'Segoe UI';
  lblSubtitle.Caption := 'Workspace operativo · Continuidad del proyecto · Mock Sprint 0';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;

  StyleCard(pnlCardRecentChats, lblCardRecentChats);
  StyleCard(pnlCardProjects, lblCardProjects);
  StyleCard(pnlCardNemo, lblCardNemo);
  StyleCard(pnlCardModels, lblCardModels);
  StyleCard(pnlCardAgents, lblCardAgents);
  StyleCard(pnlCardSystem, lblCardSystem);
  StyleCard(pnlCardActivity, lblCardActivity);
  StyleCard(pnlCardTasks, lblCardTasks);
  StyleCard(pnlCardNews, lblCardNews);
  StyleCard(pnlCardUpdates, lblCardUpdates);

  lblCardRecentChats.Caption := 'Conversaciones recientes';
  lstRecentChats.Items.Clear;
  lstRecentChats.Items.Add('ADR-0003 refinamiento del Core');
  lstRecentChats.Items.Add('Diseño shell desktop Sprint 0');
  lstRecentChats.Items.Add('Persistencia operacional — notas');

  lblCardProjects.Caption := 'Proyectos recientes';
  lstProjects.Items.Clear;
  lstProjects.Items.Add('NATIA Core');
  lstProjects.Items.Add('NEMO Knowledge');
  lstProjects.Items.Add('SAPIENS Gateway');

  lblCardNemo.Caption := 'Documentos NEMO';
  lstNemo.Items.Clear;
  lstNemo.Items.Add('DOMAIN-MODEL.md');
  lstNemo.Items.Add('ADR-0003 Core refinement');
  lstNemo.Items.Add('PHASE-0.3 notes');

  lblCardModels.Caption := 'Modelos instalados';
  lstModels.Items.Clear;
  lstModels.Items.Add('llama3.1:8b  (Ollama · local)');
  lstModels.Items.Add('qwen2.5-coder:14b');
  lstModels.Items.Add('gpt-4.1  (OpenAI · cloud)');

  lblCardAgents.Caption := 'Agentes disponibles';
  lstAgents.Items.Clear;
  lstAgents.Items.Add('Architect — diseño y ADR');
  lstAgents.Items.Add('Coder — cambios acotados');
  lstAgents.Items.Add('Reviewer — revisión crítica');

  lblCardSystem.Caption := 'Estado del sistema';
  memSystem.Lines.Clear;
  memSystem.Lines.Add('CPU  12%   Mem  3.2 GB   GPU idle');
  memSystem.Lines.Add('NEMO  Ready · index 1.2k docs');
  memSystem.Lines.Add('Providers  2 local · 1 cloud');
  memSystem.Lines.Add('Tasks  0 running · 3 queued');

  lblCardActivity.Caption := 'Actividad reciente';
  lstActivity.Items.Clear;
  lstActivity.Items.Add('10:42  Workspace NATIA activado');
  lstActivity.Items.Add('10:40  Knowledge Scratch → Fact');
  lstActivity.Items.Add('09:15  Export Workspace (mock)');

  lblCardTasks.Caption := 'Tareas pendientes';
  lstTasks.Items.Clear;
  lstTasks.Items.Add('[ ] Validar mockup Sprint 0');
  lstTasks.Items.Add('[ ] Revisar docking visual');
  lstTasks.Items.Add('[ ] Alinear tipografía');

  lblCardNews.Caption := 'Noticias IA';
  lstNews.Items.Clear;
  lstNews.Items.Add('OpenAI-compatible endpoints estables');
  lstNews.Items.Add('MCP stdio — patrones de supervisión');

  lblCardUpdates.Caption := 'Actualizaciones';
  lstUpdates.Items.Clear;
  lstUpdates.Items.Add('NATIA Desktop 0.4.0-dev (este mock)');
  lstUpdates.Items.Add('Core 0.3.0 — suite 21 tests');
end;

end.
