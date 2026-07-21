unit FrameNemo;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrameNemo = class(TFrame)
    pnlNemoTree: TPanel;
    lblNemoTree: TLabel;
    treeNemo: TTreeView;
    edtSearch: TEdit;
    pnlNemoDoc: TPanel;
    lblDocTitle: TLabel;
    lblDocMeta: TLabel;
    memDoc: TMemo;
    pnlNemoMeta: TPanel;
    lblTags: TLabel;
    lstTags: TListBox;
    lblLinks: TLabel;
    lstLinks: TListBox;
    lblRecent: TLabel;
    lstRecent: TListBox;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameNemo.ApplyMockData;
var
  Root, Adr, Ideas, Road: TTreeNode;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlNemoTree.Color := TNatiaTheme.Surface;
  pnlNemoTree.ParentBackground := False;
  pnlNemoDoc.Color := TNatiaTheme.Surface;
  pnlNemoDoc.ParentBackground := False;
  pnlNemoMeta.Color := TNatiaTheme.SurfaceAlt;
  pnlNemoMeta.ParentBackground := False;

  lblNemoTree.Caption := 'NEMO · Conocimiento';
  lblNemoTree.Font.Style := [fsBold];
  edtSearch.TextHint := 'Buscar en NEMO…';
  edtSearch.Text := '';

  treeNemo.Items.Clear;
  Root := treeNemo.Items.Add(nil, 'Workspace NATIA');
  Adr := treeNemo.Items.AddChild(Root, 'ADR');
  treeNemo.Items.AddChild(Adr, '0001 Workspace-first');
  treeNemo.Items.AddChild(Adr, '0002 Domain model (histórico)');
  treeNemo.Items.AddChild(Adr, '0003 Core refinement');
  Ideas := treeNemo.Items.AddChild(Root, 'Ideas');
  treeNemo.Items.AddChild(Ideas, 'Shell docking nativo');
  treeNemo.Items.AddChild(Ideas, 'Export documental');
  Road := treeNemo.Items.AddChild(Root, 'Roadmap');
  treeNemo.Items.AddChild(Road, 'Fase 0.3 Core — done');
  treeNemo.Items.AddChild(Road, 'Fase 0.4 Shell — mock');
  treeNemo.Items.AddChild(Root, 'Decisiones');
  treeNemo.Items.AddChild(Root, 'Notas');
  Root.Expand(True);

  lblDocTitle.Caption := 'ADR-0003: Refinamiento del dominio';
  lblDocTitle.Font.Style := [fsBold];
  lblDocTitle.Font.Size := 12;
  lblDocMeta.Caption := 'Decision · Accepted · Procedencia: Authored · Mock preview';
  lblDocMeta.Font.Color := TNatiaTheme.TextSecondary;

  memDoc.Lines.Clear;
  memDoc.Lines.Add('# ADR-0003');
  memDoc.Lines.Add('');
  memDoc.Lines.Add('Workspace 1 — N Runtime. RuntimeId obligatorio.');
  memDoc.Lines.Add('Store operacional + exportación documental.');
  memDoc.Lines.Add('Activation lazy. Fact / Session / Signal events.');
  memDoc.Lines.Add('Knowledge: Fact | Decision | Scratch.');
  memDoc.Lines.Add('');
  memDoc.Lines.Add('(Contenido simulado — sin persistencia en Sprint 0.)');

  lblTags.Caption := 'Etiquetas';
  lstTags.Items.Clear;
  lstTags.Items.Add('architecture');
  lstTags.Items.Add('domain');
  lstTags.Items.Add('core');

  lblLinks.Caption := 'Relaciones / referencias';
  lstLinks.Items.Clear;
  lstLinks.Items.Add('→ DOMAIN-MODEL.md');
  lstLinks.Items.Add('→ DOMAIN-MODEL-REVIEW.md');
  lstLinks.Items.Add('→ PHASE-0.3-EXECUTABLE-CORE.md');

  lblRecent.Caption := 'Documentos recientes';
  lstRecent.Items.Clear;
  lstRecent.Items.Add('ADR-0003');
  lstRecent.Items.Add('VISION.md');
  lstRecent.Items.Add('PRINCIPLES.md');
end;

end.
