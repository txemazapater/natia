unit FrameMarketplace;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrameMarketplace = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pcMarket: TPageControl;
    tsInstalled: TTabSheet;
    tsAvailable: TTabSheet;
    tsUpdates: TTabSheet;
    lstInstalled: TListView;
    lstAvailable: TListView;
    lstUpdates: TListView;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameMarketplace.ApplyMockData;
var
  Item: TListItem;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  lblTitle.Caption := 'Marketplace';
  lblTitle.Font.Size := 16;
  lblTitle.Font.Style := [fsBold];
  lblSubtitle.Caption := 'Extensiones · plugins · actualizaciones (simulado)';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;

  tsInstalled.Caption := 'Instalados';
  tsAvailable.Caption := 'Disponibles';
  tsUpdates.Caption := 'Actualizaciones';

  lstInstalled.Items.Clear;
  Item := lstInstalled.Items.Add;
  Item.Caption := 'NEMO Browser';
  Item.SubItems.Add('1.0.0-dev');
  Item.SubItems.Add('Knowledge');
  Item := lstInstalled.Items.Add;
  Item.Caption := 'Git Overview';
  Item.SubItems.Add('0.1.0');
  Item.SubItems.Add('Projects');

  lstAvailable.Items.Clear;
  Item := lstAvailable.Items.Add;
  Item.Caption := 'MCP Inspector';
  Item.SubItems.Add('0.9.0');
  Item.SubItems.Add('Tools');
  Item := lstAvailable.Items.Add;
  Item.Caption := 'Prompt Library';
  Item.SubItems.Add('0.4.0');
  Item.SubItems.Add('AI');
  Item := lstAvailable.Items.Add;
  Item.Caption := 'Device Monitor';
  Item.SubItems.Add('0.2.0');
  Item.SubItems.Add('Devices');

  lstUpdates.Items.Clear;
  Item := lstUpdates.Items.Add;
  Item.Caption := 'Git Overview';
  Item.SubItems.Add('0.1.0 → 0.1.1');
  Item.SubItems.Add('Pendiente');
end;

end.
