unit FrameProject;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrameProject = class(TFrame)
    pnlProjectHeader: TPanel;
    lblProjectName: TLabel;
    lblProjectMeta: TLabel;
    pcProject: TPageControl;
    tsOverview: TTabSheet;
    tsGit: TTabSheet;
    tsTasks: TTabSheet;
    tsDocs: TTabSheet;
    tsTerminal: TTabSheet;
    memOverview: TMemo;
    lstBranches: TListBox;
    lstCommits: TListBox;
    lstPRs: TListBox;
    lblBranches: TLabel;
    lblCommits: TLabel;
    lblPRs: TLabel;
    lstTasks: TListBox;
    memDocs: TMemo;
    memTerminal: TMemo;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameProject.ApplyMockData;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlProjectHeader.Color := TNatiaTheme.Surface;
  pnlProjectHeader.ParentBackground := False;

  lblProjectName.Caption := 'NATIA Core';
  lblProjectName.Font.Size := 16;
  lblProjectName.Font.Style := [fsBold];
  lblProjectMeta.Caption := 'Git · main · ahead 0 · behind 0 · mock workspace';
  lblProjectMeta.Font.Color := TNatiaTheme.TextSecondary;

  tsOverview.Caption := 'Resumen';
  tsGit.Caption := 'Repositorio';
  tsTasks.Caption := 'Tareas / Roadmap';
  tsDocs.Caption := 'Documentación';
  tsTerminal.Caption := 'Terminal / Logs';

  memOverview.Lines.Clear;
  memOverview.Lines.Add('Proyecto: NATIA Core');
  memOverview.Lines.Add('Runtime: Object Pascal · in-memory store');
  memOverview.Lines.Add('Tests: 21/21 Win32 · Win64');
  memOverview.Lines.Add('Fase: 0.4 Shell visual (mock)');
  memOverview.Lines.Add('');
  memOverview.Lines.Add('Roadmap inmediato: validación UX del shell IDE.');

  lblBranches.Caption := 'Ramas';
  lstBranches.Items.Clear;
  lstBranches.Items.Add('* main');
  lstBranches.Items.Add('  feature/shell-sprint0');
  lstBranches.Items.Add('  docs/domain-model');

  lblCommits.Caption := 'Commits recientes';
  lstCommits.Items.Clear;
  lstCommits.Items.Add('ef6dc9b  feat: add VCL desktop shell skeleton');
  lstCommits.Items.Add('6b759ea  feat: implement Phase 0.3 in-memory Core');
  lstCommits.Items.Add('79f5e4a  docs: Phase 0.2 ADR-0003 closure');

  lblPRs.Caption := 'Pull requests (mock)';
  lstPRs.Items.Clear;
  lstPRs.Items.Add('#12  Shell Sprint 0 mockup  · Open');
  lstPRs.Items.Add('#11  Core DUnitX suite     · Merged');

  lstTasks.Items.Clear;
  lstTasks.Items.Add('[x] Domain model + ADR-0003');
  lstTasks.Items.Add('[x] Core in-memory + tests');
  lstTasks.Items.Add('[ ] Shell visual Sprint 0');
  lstTasks.Items.Add('[ ] Persistencia operacional');
  lstTasks.Items.Add('[ ] Connectors lazy');

  memDocs.Lines.Clear;
  memDocs.Lines.Add('docs/VISION.md');
  memDocs.Lines.Add('docs/ARCHITECTURE.md');
  memDocs.Lines.Add('docs/DOMAIN-MODEL.md');
  memDocs.Lines.Add('docs/PHASE-0.3-EXECUTABLE-CORE.md');
  memDocs.Lines.Add('docs/adr/0003-core-domain-refinement.md');

  memTerminal.Lines.Clear;
  memTerminal.Font.Name := 'Consolas';
  memTerminal.Lines.Add('PS C:\dev\Natia> tools\build-and-test-win64.bat');
  memTerminal.Lines.Add('[OK] 21 tests passed');
  memTerminal.Lines.Add('PS C:\dev\Natia> # mock terminal — sin ejecución real');
end;

end.
