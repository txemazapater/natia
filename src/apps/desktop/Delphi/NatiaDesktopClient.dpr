program NatiaDesktopClient;

uses
  Vcl.Forms,
  MainForm in 'units\MainForm.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
