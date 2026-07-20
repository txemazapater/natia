unit Natia.Tests.DependencyGuard;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Types;

type
  [TestFixture]
  TDependencyGuardTests = class
  public
    [Test]
    procedure CoreSources_DoNotReference_ForbiddenUnits;
  end;

implementation

function SourceRoot: string;
begin
  Result := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\..\src\core'));
  if not TDirectory.Exists(Result) then
    Result := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\src\core'));
  if not TDirectory.Exists(Result) then
    Result := TPath.GetFullPath(TPath.Combine(GetCurrentDir, 'src\core'));
end;

procedure TDependencyGuardTests.CoreSources_DoNotReference_ForbiddenUnits;
var
  Root: string;
  Files: TStringDynArray;
  FileName: string;
  Content: string;
  Forbidden: TArray<string>;
  Token: string;
begin
  Root := SourceRoot;
  Assert.IsTrue(TDirectory.Exists(Root), 'Core source root not found: ' + Root);

  Forbidden := TArray<string>.Create(
    'Vcl.',
    'FMX.',
    'FireDAC',
    'Data.DB',
    'IdHTTP',
    'IdTCP',
    'REST.',
    'System.Win.Registry',
    'Winapi.Windows',
    'SQLite',
    'MCP',
    'Docker',
    'DUnitX'
  );

  Files := TDirectory.GetFiles(Root, '*.pas', TSearchOption.soAllDirectories);
  Assert.IsTrue(Length(Files) > 0, 'No .pas files under core');

  for FileName in Files do
  begin
    Content := TFile.ReadAllText(FileName);
    for Token in Forbidden do
      Assert.IsFalse(
        Content.Contains(Token),
        Format('Forbidden reference "%s" in %s', [Token, FileName])
      );
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TDependencyGuardTests);

end.
