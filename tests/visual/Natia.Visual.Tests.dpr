program Natia.Visual.Tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.ActiveX,
  DUnitX.Loggers.Console,
  DUnitX.TestFramework,
  Natia.Visual.Types in '..\..\src\visual\Natia.Visual.Types.pas',
  Natia.Visual.Logging in '..\..\src\visual\Natia.Visual.Logging.pas',
  Natia.Visual.Paths in '..\..\src\visual\Natia.Visual.Paths.pas',
  Natia.Visual.Provider in '..\..\src\visual\Natia.Visual.Provider.pas',
  Natia.Visual.Cache in '..\..\src\visual\Natia.Visual.Cache.pas',
  Natia.Visual.SvgRasterizer in '..\..\src\visual\Natia.Visual.SvgRasterizer.pas',
  Natia.Visual.Registry in '..\..\src\visual\Natia.Visual.Registry.pas',
  Natia.Visual.Provider.Phosphor in '..\..\src\visual\providers\Natia.Visual.Provider.Phosphor.pas',
  Natia.Tests.Visual.Registry in 'Natia.Tests.Visual.Registry.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  ExitCodeValue: Integer;
begin
  ExitCodeValue := 0;
  CoInitialize(nil);
  try
    try
      TDUnitX.CheckCommandLine;
      Runner := TDUnitX.CreateRunner;
      Runner.UseRTTI := True;
      Logger := TDUnitXConsoleLogger.Create(True);
      Runner.AddLogger(Logger);
      Results := Runner.Execute;
      if not Results.AllPassed then
        ExitCodeValue := 1;
    except
      on E: Exception do
      begin
        Writeln(E.ClassName, ': ', E.Message);
        ExitCodeValue := 2;
      end;
    end;
  finally
    CoUninitialize;
  end;
  Halt(ExitCodeValue);
end.
