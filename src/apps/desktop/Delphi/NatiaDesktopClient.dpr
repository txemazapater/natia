program NatiaDesktopClient;

uses
  Vcl.Forms,
  Natia.Theme in 'units\Natia.Theme.pas',
  FrameDashboard in 'units\frames\FrameDashboard.pas' {FrameDashboard: TFrame},
  FrameChat in 'units\frames\FrameChat.pas' {FrameChat: TFrame},
  FrameNemo in 'units\frames\FrameNemo.pas' {FrameNemo: TFrame},
  FrameProject in 'units\frames\FrameProject.pas' {FrameProject: TFrame},
  FrameTools in 'units\frames\FrameTools.pas' {FrameTools: TFrame},
  FrameMarketplace in 'units\frames\FrameMarketplace.pas' {FrameMarketplace: TFrame},
  FrameDevices in 'units\frames\FrameDevices.pas' {FrameDevices: TFrame},
  FrameAutomations in 'units\frames\FrameAutomations.pas' {FrameAutomations: TFrame},
  MainForm in 'units\MainForm.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'NATIA';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
