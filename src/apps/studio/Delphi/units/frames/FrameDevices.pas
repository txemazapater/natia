unit FrameDevices;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrameDevices = class(TFrame)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    lstDevices: TListView;
    pnlDetail: TPanel;
    lblDetailTitle: TLabel;
    memDetail: TMemo;
  public
    procedure ApplyMockData;
  end;

implementation

{$R *.dfm}

uses
  Natia.Theme;

procedure TFrameDevices.ApplyMockData;
var
  Item: TListItem;
begin
  Color := TNatiaTheme.AppBack;
  ParentBackground := False;
  pnlHeader.Color := TNatiaTheme.Surface;
  pnlHeader.ParentBackground := False;
  pnlDetail.Color := TNatiaTheme.SurfaceAlt;
  pnlDetail.ParentBackground := False;

  lblTitle.Caption := 'Device Manager';
  lblTitle.Font.Size := 16;
  lblTitle.Font.Style := [fsBold];
  lblSubtitle.Caption := 'PCs · servidores · IoT · PLCs (datos simulados)';
  lblSubtitle.Font.Color := TNatiaTheme.TextSecondary;

  lstDevices.Items.Clear;
  Item := lstDevices.Items.Add;
  Item.Caption := 'DEV-WS-01';
  Item.SubItems.Add('PC');
  Item.SubItems.Add('Online');
  Item.SubItems.Add('Win11 · 32 GB');
  Item := lstDevices.Items.Add;
  Item.Caption := 'SRV-NATIA-01';
  Item.SubItems.Add('Servidor');
  Item.SubItems.Add('Online');
  Item.SubItems.Add('Ubuntu · Docker host');
  Item := lstDevices.Items.Add;
  Item.Caption := 'RPi-LAB-03';
  Item.SubItems.Add('Raspberry');
  Item.SubItems.Add('Idle');
  Item.SubItems.Add('HA edge');
  Item := lstDevices.Items.Add;
  Item.Caption := 'ARDUINO-CNC';
  Item.SubItems.Add('Arduino');
  Item.SubItems.Add('Offline');
  Item.SubItems.Add('Serial mock');
  Item := lstDevices.Items.Add;
  Item.Caption := 'PLC-LINE-A';
  Item.SubItems.Add('PLC');
  Item.SubItems.Add('Degraded');
  Item.SubItems.Add('Modbus reserved');
  Item := lstDevices.Items.Add;
  Item.Caption := 'PRN-FLOOR-2';
  Item.SubItems.Add('Impresora');
  Item.SubItems.Add('Online');
  Item.SubItems.Add('IPP');

  lblDetailTitle.Caption := 'Detalle · DEV-WS-01';
  lblDetailTitle.Font.Style := [fsBold];
  memDetail.Lines.Clear;
  memDetail.Lines.Add('Tipo: PC de desarrollo');
  memDetail.Lines.Add('Último heartbeat: hace 12 s (mock)');
  memDetail.Lines.Add('Agentes locales: 2');
  memDetail.Lines.Add('Ollama: disponible (simulado)');
  memDetail.Lines.Add('Sesiones remotas: 0');
end;

end.
