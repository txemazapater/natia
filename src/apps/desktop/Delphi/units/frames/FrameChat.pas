unit FrameChat;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons;

type
  TFrameChat = class(TFrame)
    pnlChatLeft: TPanel;
    lblConversations: TLabel;
    lstConversations: TListBox;
    pnlChatMain: TPanel;
    pnlChatHeader: TPanel;
    lblChatTitle: TLabel;
    lblChatMeta: TLabel;
    cmbAgent: TComboBox;
    cmbContext: TComboBox;
    memTranscript: TMemo;
    pnlComposer: TPanel;
    memPrompt: TMemo;
    btnSend: TButton;
    btnAttach: TButton;
    btnTools: TButton;
    lblTokens: TLabel;
    lblLatency: TLabel;
    pnlQuickActions: TPanel;
    btnQASummarize: TButton;
    btnQAPromote: TButton;
    btnQAExport: TButton;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameChat.ApplyMockData;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlChatLeft.Color := TNatiaTheme.Surface;
  pnlChatLeft.ParentBackground := False;
  pnlChatMain.Color := TNatiaTheme.Surface;
  pnlChatMain.ParentBackground := False;
  pnlChatHeader.Color := TNatiaTheme.SurfaceAlt;
  pnlChatHeader.ParentBackground := False;
  pnlComposer.Color := TNatiaTheme.SurfaceAlt;
  pnlComposer.ParentBackground := False;

  lblConversations.Caption := 'Conversaciones';
  lblConversations.Font.Style := [fsBold];
  lstConversations.Items.Clear;
  lstConversations.Items.Add('ADR-0003 refinamiento');
  lstConversations.Items.Add('Shell Sprint 0');
  lstConversations.Items.Add('Persistencia SQLite');
  lstConversations.Items.Add('MCP stdio — notas');
  lstConversations.ItemIndex := 1;

  lblChatTitle.Caption := 'Shell Sprint 0';
  lblChatTitle.Font.Style := [fsBold];
  lblChatTitle.Font.Size := 12;
  lblChatMeta.Caption := 'Agente: Architect · Contexto: Workspace NATIA · Mock';
  lblChatMeta.Font.Color := TNatiaTheme.TextSecondary;

  cmbAgent.Items.Clear;
  cmbAgent.Items.Add('Architect');
  cmbAgent.Items.Add('Coder');
  cmbAgent.Items.Add('Reviewer');
  cmbAgent.ItemIndex := 0;

  cmbContext.Items.Clear;
  cmbContext.Items.Add('Workspace NATIA');
  cmbContext.Items.Add('NEMO docs');
  cmbContext.Items.Add('Sin contexto');
  cmbContext.ItemIndex := 0;

  memTranscript.Clear;
  memTranscript.Lines.Add('Usuario  11:02');
  memTranscript.Lines.Add('Necesitamos un mockup visual que parezca un IDE, no un chat.');
  memTranscript.Lines.Add('');
  memTranscript.Lines.Add('Architect  11:03  ·  842 tokens  ·  1.8s');
  memTranscript.Lines.Add('De acuerdo. El shell debe priorizar navegación, explorer,');
  memTranscript.Lines.Add('workspace con pestañas e inspector contextual. El chat');
  memTranscript.Lines.Add('es solo un módulo más.');
  memTranscript.Lines.Add('');
  memTranscript.Lines.Add('Usuario  11:05');
  memTranscript.Lines.Add('Incluye NEMO, proyectos Git y una consola inferior.');
  memTranscript.Lines.Add('');
  memTranscript.Lines.Add('Architect  11:05  ·  1.2k tokens  ·  2.1s');
  memTranscript.Lines.Add('Propuesta: cinco zonas + docking preparado. Datos mock.');

  memPrompt.Text := 'Escribe aquí… (mock — sin envío real)';
  memPrompt.Font.Color := TNatiaTheme.TextSecondary;
  btnSend.Caption := 'Enviar';
  btnAttach.Caption := 'Adjuntar';
  btnTools.Caption := 'Herramientas';
  lblTokens.Caption := 'Tokens: 2.0k · presupuesto 32k';
  lblLatency.Caption := 'Última respuesta: 2.1s';
  btnQASummarize.Caption := 'Resumir';
  btnQAPromote.Caption := 'Promover a NEMO';
  btnQAExport.Caption := 'Exportar';
end;

end.
