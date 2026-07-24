unit MainForm;

{ NATIA Studio — Sprint 0 visual embryo. Sin integraciones ni lógica de negocio. }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Menus, Vcl.Buttons,
  FrameDashboard, FrameChat, FrameNemo, FrameProject, FrameTools,
  FrameMarketplace, FrameDevices, FrameAutomations, FrameVisualAssets;

type
  TNavModule = (
    nmHome, nmWorkspace, nmChats, nmNemo, nmProjects, nmAgents, nmTools,
    nmExtensions, nmTasks, nmNotifications, nmMarketplace, nmDevices,
    nmRemote, nmAutomations, nmSettings, nmHelp
  );

  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miFileNew: TMenuItem;
    miFileOpen: TMenuItem;
    miFileSep1: TMenuItem;
    miFileExit: TMenuItem;
    miEdit: TMenuItem;
    miView: TMenuItem;
    miViewExplorer: TMenuItem;
    miViewInspector: TMenuItem;
    miViewConsole: TMenuItem;
    miViewNav: TMenuItem;
    miWorkspace: TMenuItem;
    miTools: TMenuItem;
    miHelp: TMenuItem;
    miHelpAbout: TMenuItem;
    pnlChrome: TPanel;
    lblBrand: TLabel;
    lblChromeTitle: TLabel;
    edtGlobalSearch: TEdit;
    cmbProvider: TComboBox;
    cmbModel: TComboBox;
    cmbActiveAgent: TComboBox;
    shpConnection: TShape;
    lblConnection: TLabel;
    lblAvatar: TLabel;
    btnQuickSettings: TSpeedButton;
    lblSync: TLabel;
    btnNew: TSpeedButton;
    btnSave: TSpeedButton;
    btnRun: TSpeedButton;
    pnlBody: TPanel;
    pnlNav: TPanel;
    btnNavToggle: TSpeedButton;
    btnNavHome: TSpeedButton;
    btnNavWorkspace: TSpeedButton;
    btnNavChats: TSpeedButton;
    btnNavNemo: TSpeedButton;
    btnNavProjects: TSpeedButton;
    btnNavAgents: TSpeedButton;
    btnNavTools: TSpeedButton;
    btnNavExtensions: TSpeedButton;
    btnNavTasks: TSpeedButton;
    btnNavNotifications: TSpeedButton;
    btnNavMarketplace: TSpeedButton;
    btnNavDevices: TSpeedButton;
    btnNavRemote: TSpeedButton;
    btnNavAutomations: TSpeedButton;
    btnNavSettings: TSpeedButton;
    btnNavHelp: TSpeedButton;
    splNav: TSplitter;
    pnlExplorer: TPanel;
    lblExplorer: TLabel;
    treeExplorer: TTreeView;
    splExplorer: TSplitter;
    pnlCenter: TPanel;
    pnlWorkspaceChrome: TPanel;
    pcWorkspaceTabs: TPageControl;
    tsTabHome: TTabSheet;
    tsTabChat: TTabSheet;
    tsTabNemo: TTabSheet;
    tsTabProject: TTabSheet;
    pnlWorkspaceHost: TPanel;
    frameDashboard: TFrameDashboard;
    frameChat: TFrameChat;
    frameNemo: TFrameNemo;
    frameProject: TFrameProject;
    frameTools: TFrameTools;
    frameMarketplace: TFrameMarketplace;
    frameDevices: TFrameDevices;
    frameAutomations: TFrameAutomations;
    frameVisualAssets: TFrameVisualAssets;
    splConsole: TSplitter;
    pnlConsole: TPanel;
    pcConsole: TPageControl;
    tsTerminal: TTabSheet;
    tsPowerShell: TTabSheet;
    tsLogs: TTabSheet;
    tsOutput: TTabSheet;
    tsDebug: TTabSheet;
    tsMCP: TTabSheet;
    tsDocker: TTabSheet;
    tsSQL: TTabSheet;
    memTerminal: TMemo;
    memPowerShell: TMemo;
    memLogs: TMemo;
    memOutput: TMemo;
    memDebug: TMemo;
    memMCP: TMemo;
    memDocker: TMemo;
    memSQL: TMemo;
    splInspector: TSplitter;
    pnlInspector: TPanel;
    lblInspector: TLabel;
    pcInspector: TPageControl;
    tsProps: TTabSheet;
    tsActivity: TTabSheet;
    tsTimeline: TTabSheet;
    tsAgent: TTabSheet;
    tsModel: TTabSheet;
    tsStats: TTabSheet;
    memProps: TMemo;
    lstActivity: TListBox;
    memTimeline: TMemo;
    memAgent: TMemo;
    memModel: TMemo;
    memStats: TMemo;
    pnlStatus: TPanel;
    lblStatusModel: TLabel;
    lblStatusProvider: TLabel;
    lblStatusCPU: TLabel;
    lblStatusMem: TLabel;
    lblStatusGPU: TLabel;
    lblStatusConn: TLabel;
    lblStatusTasks: TLabel;
    lblStatusAgents: TLabel;
    lblStatusNemo: TLabel;
    lblStatusNotify: TLabel;
    lblStatusTime: TLabel;
    lblStatusUser: TLabel;
    tmrClock: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnNavClick(Sender: TObject);
    procedure btnNavToggleClick(Sender: TObject);
    procedure miViewExplorerClick(Sender: TObject);
    procedure miViewInspectorClick(Sender: TObject);
    procedure miViewConsoleClick(Sender: TObject);
    procedure miViewNavClick(Sender: TObject);
    procedure miFileExitClick(Sender: TObject);
    procedure miHelpAboutClick(Sender: TObject);
    procedure tmrClockTimer(Sender: TObject);
    procedure pcWorkspaceTabsChange(Sender: TObject);
  private
    FNavExpanded: Boolean;
    FCurrentModule: TNavModule;
    procedure ApplyTheme;
    procedure ApplyMockChrome;
    procedure ApplyMockConsole;
    procedure ApplyMockInspector;
    procedure ApplyMockStatus;
    procedure ApplyNavIcons;
    procedure AssignNavIcon(ABtn: TSpeedButton; const AAssetId: string);
    procedure ShowModule(AModule: TNavModule);
    procedure FillExplorer(AModule: TNavModule);
    procedure SelectNavButton(AModule: TNavModule);
    procedure HideAllFrames;
    function ModuleFromTag(ATag: Integer): TNavModule;
    function CurrentDpi: Integer;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Natia.Theme,
  Natia.Visual.Bootstrap,
  Natia.Visual.Logging,
  Natia.Visual.Types,
  Natia.Visual.Registry;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FNavExpanded := True;
  FCurrentModule := nmHome;

  VisualLogSetHandler(
    procedure(ALevel: TVisualLogLevel; const AMessage: string)
    begin
      if (memLogs <> nil) and not (csDestroying in ComponentState) then
        memLogs.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) + AMessage);
    end);

  try
    InitVisualAssets;
  except
    on E: Exception do
      memLogs.Lines.Add('[VAR] init error: ' + E.Message);
  end;

  ApplyTheme;
  ApplyMockChrome;
  ApplyMockConsole;
  ApplyMockInspector;
  ApplyMockStatus;
  ApplyNavIcons;
  frameDashboard.ApplyMockData;
  frameChat.ApplyMockData;
  frameNemo.ApplyMockData;
  frameProject.ApplyMockData;
  frameTools.ApplyMockData;
  frameMarketplace.ApplyMockData;
  frameDevices.ApplyMockData;
  frameAutomations.ApplyMockData;
  frameVisualAssets.ApplyDemo;
  ShowModule(nmHome);
  tmrClock.Enabled := True;
  tmrClockTimer(nil);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  VisualLogSetHandler(nil);
  ShutdownVisualAssets;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  { Layout uses Align/Splitters — reserved for future docking. }
end;

function TfrmMain.CurrentDpi: Integer;
begin
  Result := Screen.PixelsPerInch;
  if Result < 1 then
    Result := 96;
end;

procedure TfrmMain.AssignNavIcon(ABtn: TSpeedButton; const AAssetId: string);
var
  Resolved: TResolvedVisualAsset;
begin
  if VisualAssets = nil then
    Exit;
  Resolved := VisualAssets.ResolveIcon(AAssetId, 20, CurrentDpi);
  try
    ABtn.Glyph.Assign(Resolved.Bitmap);
    ABtn.NumGlyphs := 1;
    ABtn.Caption := '';
    ABtn.Layout := blGlyphTop;
  finally
    Resolved.Free;
  end;
end;

procedure TfrmMain.ApplyNavIcons;
begin
  { Migrated nav glyphs via VAR (logical ids, not SVG paths). }
  AssignNavIcon(btnNavHome, 'phosphor://house/regular');
  AssignNavIcon(btnNavProjects, 'phosphor://folder-open/duotone');
  AssignNavIcon(btnNavAgents, 'phosphor://robot/duotone');
  AssignNavIcon(btnNavNemo, 'phosphor://brain/duotone');
  AssignNavIcon(btnNavTools, 'phosphor://wrench/regular');
  AssignNavIcon(btnNavSettings, 'phosphor://gear/regular');
  AssignNavIcon(btnNavHelp, 'phosphor://magnifying-glass/regular');
  btnNavHelp.Hint := 'Visual Asset Registry';
end;

procedure TfrmMain.ApplyTheme;
begin
  Color := TNatiaTheme.AppBack;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Font.Color := TNatiaTheme.TextPrimary;

  pnlChrome.Color := TNatiaTheme.Surface;
  pnlChrome.ParentBackground := False;
  pnlBody.Color := TNatiaTheme.AppBack;
  pnlBody.ParentBackground := False;
  pnlNav.Color := TNatiaTheme.NavBack;
  pnlNav.ParentBackground := False;
  pnlExplorer.Color := TNatiaTheme.Surface;
  pnlExplorer.ParentBackground := False;
  pnlCenter.Color := TNatiaTheme.AppBack;
  pnlCenter.ParentBackground := False;
  pnlWorkspaceChrome.Color := TNatiaTheme.SurfaceAlt;
  pnlWorkspaceChrome.ParentBackground := False;
  pnlWorkspaceHost.Color := TNatiaTheme.AppBack;
  pnlWorkspaceHost.ParentBackground := False;
  pnlConsole.Color := TNatiaTheme.Surface;
  pnlConsole.ParentBackground := False;
  pnlInspector.Color := TNatiaTheme.Surface;
  pnlInspector.ParentBackground := False;
  pnlStatus.Color := TNatiaTheme.SurfaceAlt;
  pnlStatus.ParentBackground := False;

  lblBrand.Font.Color := TNatiaTheme.Accent;
  lblBrand.Font.Style := [fsBold];
  lblExplorer.Font.Style := [fsBold];
  lblInspector.Font.Style := [fsBold];
end;

procedure TfrmMain.ApplyMockChrome;
begin
  Caption := 'NATIA Studio';
  lblBrand.Caption := 'NATIA';
  lblChromeTitle.Caption := 'Studio · Workspace NATIA Core';
  lblChromeTitle.Font.Color := TNatiaTheme.TextSecondary;
  edtGlobalSearch.TextHint := 'Buscar en workspace, NEMO, chats, herramientas…';
  edtGlobalSearch.Text := '';

  cmbProvider.Items.Clear;
  cmbProvider.Items.Add('Ollama (local)');
  cmbProvider.Items.Add('OpenAI (cloud)');
  cmbProvider.Items.Add('Azure OpenAI');
  cmbProvider.ItemIndex := 0;

  cmbModel.Items.Clear;
  cmbModel.Items.Add('llama3.1:8b');
  cmbModel.Items.Add('qwen2.5-coder:14b');
  cmbModel.Items.Add('gpt-4.1');
  cmbModel.ItemIndex := 0;

  cmbActiveAgent.Items.Clear;
  cmbActiveAgent.Items.Add('Architect');
  cmbActiveAgent.Items.Add('Coder');
  cmbActiveAgent.Items.Add('Reviewer');
  cmbActiveAgent.ItemIndex := 0;

  shpConnection.Brush.Color := TNatiaTheme.Success;
  shpConnection.Pen.Color := TNatiaTheme.Success;
  lblConnection.Caption := 'Local Ready';
  lblAvatar.Caption := 'TZ';
  lblAvatar.Font.Style := [fsBold];
  btnQuickSettings.Caption := '...';
  lblSync.Caption := 'Sync · Idle';
  lblSync.Font.Color := TNatiaTheme.TextSecondary;
  btnNew.Caption := 'Nuevo';
  btnSave.Caption := 'Guardar';
  btnRun.Caption := 'Ejecutar';

  btnNavHome.Hint := 'Inicio';
  btnNavWorkspace.Hint := 'Workspace';
  btnNavChats.Hint := 'Chats';
  btnNavNemo.Hint := 'Memoria (NEMO)';
  btnNavProjects.Hint := 'Iniciativas';
  btnNavAgents.Hint := 'Agentes';
  btnNavTools.Hint := 'Herramientas';
  btnNavExtensions.Hint := 'Extensions';
  btnNavTasks.Hint := 'Tasks';
  btnNavNotifications.Hint := 'Notifications';
  btnNavMarketplace.Hint := 'Marketplace';
  btnNavDevices.Hint := 'Device Manager';
  btnNavRemote.Hint := 'Remote Systems';
  btnNavAutomations.Hint := 'Automations';
  btnNavSettings.Hint := 'Ajustes';
  btnNavHelp.Hint := 'Visual Asset Registry';
  btnNavToggle.Hint := 'Colapsar barra lateral';
  ShowHint := True;
end;

procedure TfrmMain.ApplyMockConsole;
begin
  tsTerminal.Caption := 'Terminal';
  tsPowerShell.Caption := 'PowerShell';
  tsLogs.Caption := 'Logs';
  tsOutput.Caption := 'Output';
  tsDebug.Caption := 'Debug';
  tsMCP.Caption := 'MCP';
  tsDocker.Caption := 'Docker';
  tsSQL.Caption := 'SQL';

  memTerminal.Font.Name := 'Consolas';
  memTerminal.Lines.Text :=
    'NATIA Terminal (mock)'#13#10 +
    'C:\dev\Natia>'#13#10 +
    'Listo. Sin ejecución real en Sprint 0.';
  memPowerShell.Font.Name := 'Consolas';
  memPowerShell.Lines.Text := 'PS C:\dev\Natia> Get-Date  # mock';
  memLogs.Lines.Text :=
    '[10:41:02] INFO  Workspace activated'#13#10 +
    '[10:41:03] INFO  Explorer ready'#13#10 +
    '[10:41:04] WARN  Connectors disabled (Sprint 0)';
  memOutput.Lines.Text := 'Build: skipped (UI mock only)';
  memDebug.Lines.Text := 'Breakpoints: 0 · Watches: 0';
  memMCP.Lines.Text := 'MCP servers: 0 connected (reserved)';
  memDocker.Lines.Text := 'docker ps — no daemon (mock)';
  memSQL.Lines.Text := 'SQL console — sin conexión';
end;

procedure TfrmMain.ApplyMockInspector;
begin
  lblInspector.Caption := 'Inspector';
  tsProps.Caption := 'Propiedades';
  tsActivity.Caption := 'Actividad';
  tsTimeline.Caption := 'Timeline';
  tsAgent.Caption := 'Agente';
  tsModel.Caption := 'Modelo';
  tsStats.Caption := 'Estadísticas';

  memProps.Lines.Text :=
    'Tipo: Workspace'#13#10 +
    'Id: ws-natia-core'#13#10 +
    'Runtime: Ready'#13#10 +
    'Tema: Light (reservado)';
  lstActivity.Items.Clear;
  lstActivity.Items.Add('11:12  Vista Home');
  lstActivity.Items.Add('11:10  Shell iniciado');
  memTimeline.Lines.Text :=
    '— Memoria NEMO (mock) —'#13#10 +
    '09:00  Fact: ADR-0003 Accepted'#13#10 +
    '10:30  Session: Shell Sprint 0';
  memAgent.Lines.Text :=
    'Activo: Architect'#13#10 +
    'Rol: diseño / ADR'#13#10 +
    'Herramientas: 0 (mock)';
  memModel.Lines.Text :=
    'Proveedor: Ollama'#13#10 +
    'Modelo: llama3.1:8b'#13#10 +
    'Contexto: 8k (simulado)';
  memStats.Lines.Text :=
    'Tokens hoy: 12.4k'#13#10 +
    'Conversaciones: 4'#13#10 +
    'Docs NEMO: 1.2k';
end;

procedure TfrmMain.ApplyMockStatus;
begin
  lblStatusModel.Caption := 'Modelo: llama3.1:8b';
  lblStatusProvider.Caption := 'Proveedor: Ollama';
  lblStatusCPU.Caption := 'CPU 12%';
  lblStatusMem.Caption := 'Mem 3.2 GB';
  lblStatusGPU.Caption := 'GPU idle';
  lblStatusConn.Caption := 'Conexión: Local';
  lblStatusTasks.Caption := 'Tareas: 0';
  lblStatusAgents.Caption := 'Agentes: 3';
  lblStatusNemo.Caption := 'NEMO: Ready';
  lblStatusNotify.Caption := 'Notif: 2';
  lblStatusUser.Caption := 'Usuario: txema';
end;

procedure TfrmMain.HideAllFrames;
begin
  frameDashboard.Visible := False;
  frameChat.Visible := False;
  frameNemo.Visible := False;
  frameProject.Visible := False;
  frameTools.Visible := False;
  frameMarketplace.Visible := False;
  frameDevices.Visible := False;
  frameAutomations.Visible := False;
  frameVisualAssets.Visible := False;
end;

procedure TfrmMain.ShowModule(AModule: TNavModule);
begin
  FCurrentModule := AModule;
  SelectNavButton(AModule);
  FillExplorer(AModule);
  HideAllFrames;

  case AModule of
    nmHome:
      begin
        frameDashboard.Visible := True;
        frameDashboard.BringToFront;
        pcWorkspaceTabs.ActivePage := tsTabHome;
      end;
    nmChats:
      begin
        frameChat.Visible := True;
        frameChat.BringToFront;
        pcWorkspaceTabs.ActivePage := tsTabChat;
      end;
    nmNemo:
      begin
        frameNemo.Visible := True;
        frameNemo.BringToFront;
        pcWorkspaceTabs.ActivePage := tsTabNemo;
      end;
    nmProjects, nmWorkspace:
      begin
        frameProject.Visible := True;
        frameProject.BringToFront;
        pcWorkspaceTabs.ActivePage := tsTabProject;
      end;
    nmTools:
      begin
        frameTools.Visible := True;
        frameTools.BringToFront;
      end;
    nmMarketplace, nmExtensions:
      begin
        frameMarketplace.Visible := True;
        frameMarketplace.BringToFront;
      end;
    nmDevices, nmRemote:
      begin
        frameDevices.Visible := True;
        frameDevices.BringToFront;
      end;
    nmAutomations:
      begin
        frameAutomations.Visible := True;
        frameAutomations.BringToFront;
      end;
    nmHelp:
      begin
        frameVisualAssets.Visible := True;
        frameVisualAssets.BringToFront;
        lblExplorer.Caption := 'Explorer · Visual Asset Registry';
      end;
    nmAgents, nmTasks, nmNotifications, nmSettings:
      begin
        frameDashboard.Visible := True;
        frameDashboard.BringToFront;
        pcWorkspaceTabs.ActivePage := tsTabHome;
        case AModule of
          nmAgents: lblExplorer.Caption := 'Explorer · Agents';
          nmTasks: lblExplorer.Caption := 'Explorer · Tasks';
          nmNotifications: lblExplorer.Caption := 'Explorer · Notifications';
          nmSettings: lblExplorer.Caption := 'Explorer · Settings';
        end;
      end;
  end;
end;

procedure TfrmMain.FillExplorer(AModule: TNavModule);
var
  Root: TTreeNode;
begin
  treeExplorer.Items.BeginUpdate;
  try
    treeExplorer.Items.Clear;
    case AModule of
      nmHome:
        begin
          lblExplorer.Caption := 'Explorer · Home';
          Root := treeExplorer.Items.Add(nil, 'Favoritos');
          treeExplorer.Items.AddChild(Root, 'Dashboard');
          treeExplorer.Items.AddChild(Root, 'NATIA Core');
          Root := treeExplorer.Items.Add(nil, 'Recientes');
          treeExplorer.Items.AddChild(Root, 'ADR-0003');
          treeExplorer.Items.AddChild(Root, 'Shell Sprint 0');
        end;
      nmChats:
        begin
          lblExplorer.Caption := 'Explorer · Chats';
          Root := treeExplorer.Items.Add(nil, 'Conversaciones');
          treeExplorer.Items.AddChild(Root, 'ADR-0003 refinamiento');
          treeExplorer.Items.AddChild(Root, 'Shell Sprint 0');
          treeExplorer.Items.AddChild(Root, 'Persistencia SQLite');
          Root := treeExplorer.Items.Add(nil, 'Historial');
          treeExplorer.Items.AddChild(Root, 'Esta semana');
          treeExplorer.Items.AddChild(Root, 'Archivadas');
        end;
      nmNemo:
        begin
          lblExplorer.Caption := 'Explorer · NEMO';
          Root := treeExplorer.Items.Add(nil, 'Conocimiento');
          treeExplorer.Items.AddChild(Root, 'ADR');
          treeExplorer.Items.AddChild(Root, 'Ideas');
          treeExplorer.Items.AddChild(Root, 'Roadmap');
          treeExplorer.Items.AddChild(Root, 'Decisiones');
          treeExplorer.Items.AddChild(Root, 'Notas');
        end;
      nmProjects, nmWorkspace:
        begin
          lblExplorer.Caption := 'Explorer · Projects';
          Root := treeExplorer.Items.Add(nil, 'NATIA Core');
          treeExplorer.Items.AddChild(Root, 'src/core');
          treeExplorer.Items.AddChild(Root, 'docs');
          treeExplorer.Items.AddChild(Root, 'tests');
          Root := treeExplorer.Items.Add(nil, 'Repositorios');
          treeExplorer.Items.AddChild(Root, 'natia');
        end;
      nmTools:
        begin
          lblExplorer.Caption := 'Explorer · Tools';
          Root := treeExplorer.Items.Add(nil, 'Integraciones');
          treeExplorer.Items.AddChild(Root, 'Docker');
          treeExplorer.Items.AddChild(Root, 'GitHub');
          treeExplorer.Items.AddChild(Root, 'SQL');
          treeExplorer.Items.AddChild(Root, 'MCP');
          treeExplorer.Items.AddChild(Root, 'Ollama');
        end;
      nmMarketplace, nmExtensions:
        begin
          lblExplorer.Caption := 'Explorer · Marketplace';
          Root := treeExplorer.Items.Add(nil, 'Plugins');
          treeExplorer.Items.AddChild(Root, 'Instalados');
          treeExplorer.Items.AddChild(Root, 'Disponibles');
          treeExplorer.Items.AddChild(Root, 'Actualizaciones');
        end;
      nmDevices, nmRemote:
        begin
          lblExplorer.Caption := 'Explorer · Devices';
          Root := treeExplorer.Items.Add(nil, 'Dispositivos');
          treeExplorer.Items.AddChild(Root, 'PCs');
          treeExplorer.Items.AddChild(Root, 'Servidores');
          treeExplorer.Items.AddChild(Root, 'IoT');
          treeExplorer.Items.AddChild(Root, 'PLCs');
        end;
      nmAutomations:
        begin
          lblExplorer.Caption := 'Explorer · Automations';
          Root := treeExplorer.Items.Add(nil, 'Flujos');
          treeExplorer.Items.AddChild(Root, 'Review on push');
          treeExplorer.Items.AddChild(Root, 'Nightly export');
        end;
      nmAgents:
        begin
          lblExplorer.Caption := 'Explorer · Agents';
          Root := treeExplorer.Items.Add(nil, 'Agentes');
          treeExplorer.Items.AddChild(Root, 'Architect');
          treeExplorer.Items.AddChild(Root, 'Coder');
          treeExplorer.Items.AddChild(Root, 'Reviewer');
        end;
      nmHelp:
        begin
          lblExplorer.Caption := 'Explorer · Visual Asset Registry';
          Root := treeExplorer.Items.Add(nil, 'VAR 0.1');
          treeExplorer.Items.AddChild(Root, 'phosphor://');
          treeExplorer.Items.AddChild(Root, 'Galería demo');
          treeExplorer.Items.AddChild(Root, 'Caché / fallback');
        end;
    else
      begin
        lblExplorer.Caption := 'Explorer';
        treeExplorer.Items.Add(nil, '(mock)');
      end;
    end;
    if treeExplorer.Items.Count > 0 then
      treeExplorer.FullExpand;
  finally
    treeExplorer.Items.EndUpdate;
  end;
end;

function TfrmMain.ModuleFromTag(ATag: Integer): TNavModule;
begin
  if (ATag < Ord(Low(TNavModule))) or (ATag > Ord(High(TNavModule))) then
    Result := nmHome
  else
    Result := TNavModule(ATag);
end;

procedure TfrmMain.SelectNavButton(AModule: TNavModule);
  procedure StyleBtn(Btn: TSpeedButton; Selected: Boolean);
  begin
    if Selected then
      Btn.Font.Style := [fsBold]
    else
      Btn.Font.Style := [];
  end;
begin
  StyleBtn(btnNavHome, AModule = nmHome);
  StyleBtn(btnNavWorkspace, AModule = nmWorkspace);
  StyleBtn(btnNavChats, AModule = nmChats);
  StyleBtn(btnNavNemo, AModule = nmNemo);
  StyleBtn(btnNavProjects, AModule = nmProjects);
  StyleBtn(btnNavAgents, AModule = nmAgents);
  StyleBtn(btnNavTools, AModule = nmTools);
  StyleBtn(btnNavExtensions, AModule = nmExtensions);
  StyleBtn(btnNavTasks, AModule = nmTasks);
  StyleBtn(btnNavNotifications, AModule = nmNotifications);
  StyleBtn(btnNavMarketplace, AModule = nmMarketplace);
  StyleBtn(btnNavDevices, AModule = nmDevices);
  StyleBtn(btnNavRemote, AModule = nmRemote);
  StyleBtn(btnNavAutomations, AModule = nmAutomations);
  StyleBtn(btnNavSettings, AModule = nmSettings);
  StyleBtn(btnNavHelp, AModule = nmHelp);
end;

procedure TfrmMain.btnNavClick(Sender: TObject);
begin
  if Sender is TSpeedButton then
    ShowModule(ModuleFromTag(TSpeedButton(Sender).Tag));
end;

procedure TfrmMain.btnNavToggleClick(Sender: TObject);
begin
  FNavExpanded := not FNavExpanded;
  if FNavExpanded then
    pnlNav.Width := 56
  else
    pnlNav.Width := 0;
  miViewNav.Checked := FNavExpanded;
end;

procedure TfrmMain.miViewExplorerClick(Sender: TObject);
begin
  pnlExplorer.Visible := not pnlExplorer.Visible;
  splExplorer.Visible := pnlExplorer.Visible;
  miViewExplorer.Checked := pnlExplorer.Visible;
end;

procedure TfrmMain.miViewInspectorClick(Sender: TObject);
begin
  pnlInspector.Visible := not pnlInspector.Visible;
  splInspector.Visible := pnlInspector.Visible;
  miViewInspector.Checked := pnlInspector.Visible;
end;

procedure TfrmMain.miViewConsoleClick(Sender: TObject);
begin
  pnlConsole.Visible := not pnlConsole.Visible;
  splConsole.Visible := pnlConsole.Visible;
  miViewConsole.Checked := pnlConsole.Visible;
end;

procedure TfrmMain.miViewNavClick(Sender: TObject);
begin
  btnNavToggleClick(nil);
end;

procedure TfrmMain.miFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miHelpAboutClick(Sender: TObject);
begin
  ShowMessage(
    'NATIA Studio'#13#10 +
    'Cliente de referencia nativo · Sprint 0 (embrión visual)'#13#10 +
    'Cognitive workspace para Inteligencia Artificial'#13#10 +
    'VAR 0.1: iconos Phosphor vía Visual Asset Registry'#13#10 +
    'Sin integraciones reales.');
end;

procedure TfrmMain.tmrClockTimer(Sender: TObject);
begin
  lblStatusTime.Caption := FormatDateTime('hh:nn:ss', Now);
end;

procedure TfrmMain.pcWorkspaceTabsChange(Sender: TObject);
begin
  if pcWorkspaceTabs.ActivePage = tsTabHome then
    ShowModule(nmHome)
  else if pcWorkspaceTabs.ActivePage = tsTabChat then
    ShowModule(nmChats)
  else if pcWorkspaceTabs.ActivePage = tsTabNemo then
    ShowModule(nmNemo)
  else if pcWorkspaceTabs.ActivePage = tsTabProject then
    ShowModule(nmProjects);
end;

end.
