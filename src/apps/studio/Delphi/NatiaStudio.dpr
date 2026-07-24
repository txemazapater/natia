program NatiaStudio;

uses
  Vcl.Forms,
  Natia.Theme in 'units\Natia.Theme.pas',
  Natia.Visual.Types in '..\..\..\visual\Natia.Visual.Types.pas',
  Natia.Visual.Logging in '..\..\..\visual\Natia.Visual.Logging.pas',
  Natia.Visual.Paths in '..\..\..\visual\Natia.Visual.Paths.pas',
  Natia.Visual.Provider in '..\..\..\visual\Natia.Visual.Provider.pas',
  Natia.Visual.Cache in '..\..\..\visual\Natia.Visual.Cache.pas',
  Natia.Visual.SvgRasterizer in '..\..\..\visual\Natia.Visual.SvgRasterizer.pas',
  Natia.Visual.Registry in '..\..\..\visual\Natia.Visual.Registry.pas',
  Natia.Visual.Provider.Phosphor in '..\..\..\visual\providers\Natia.Visual.Provider.Phosphor.pas',
  Natia.Visual.Bootstrap in '..\..\..\visual\Natia.Visual.Bootstrap.pas',
  FrameDashboard in 'units\frames\FrameDashboard.pas' {FrameDashboard: TFrame},
  FrameChat in 'units\frames\FrameChat.pas' {FrameChat: TFrame},
  FrameNemo in 'units\frames\FrameNemo.pas' {FrameNemo: TFrame},
  FrameProject in 'units\frames\FrameProject.pas' {FrameProject: TFrame},
  FrameTools in 'units\frames\FrameTools.pas' {FrameTools: TFrame},
  FrameMarketplace in 'units\frames\FrameMarketplace.pas' {FrameMarketplace: TFrame},
  FrameDevices in 'units\frames\FrameDevices.pas' {FrameDevices: TFrame},
  FrameAutomations in 'units\frames\FrameAutomations.pas' {FrameAutomations: TFrame},
  FrameVisualAssets in 'units\frames\FrameVisualAssets.pas' {FrameVisualAssets: TFrame},
  MainForm in 'units\MainForm.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'NATIA Studio';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
