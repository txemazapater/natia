unit Natia.Visual.Paths;

interface

uses
  System.SysUtils;

/// <summary>Locate repository/distribution assets root (folder that contains icons/).</summary>
function FindNatiaAssetsRoot: string;

/// <summary>Locate repository root (folder that contains assets/ and config/).</summary>
function FindNatiaRepoRoot: string;

/// <summary>Resolve a path relative to the repo root (e.g. config\visual\var-demo.json).</summary>
function FindNatiaRepoFile(const ARelativePath: string): string;

implementation

uses
  System.IOUtils;

function CandidateHasPhosphor(const ARoot: string): Boolean;
begin
  Result := TDirectory.Exists(TPath.Combine(ARoot, 'icons\phosphor'))
    or TDirectory.Exists(TPath.Combine(ARoot, 'icons\phosphor\regular'));
end;

function FindNatiaAssetsRoot: string;
var
  ExeDir, Probe, Parent, Env: string;
  I: Integer;
begin
  Env := GetEnvironmentVariable('NATIA_ASSETS_ROOT');
  if Env <> '' then
  begin
    Env := ExcludeTrailingPathDelimiter(TPath.GetFullPath(Env));
    if CandidateHasPhosphor(Env) then
      Exit(Env);
  end;

  ExeDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  Probe := TPath.Combine(ExeDir, 'assets');
  if CandidateHasPhosphor(Probe) then
    Exit(ExcludeTrailingPathDelimiter(TPath.GetFullPath(Probe)));

  // Win64\Debug → … → repo root (up to 8 levels), then assets\
  Probe := ExeDir;
  for I := 1 to 8 do
  begin
    Probe := ExcludeTrailingPathDelimiter(Probe);
    Parent := ExcludeTrailingPathDelimiter(ExtractFilePath(Probe));
    if (Parent = '') or SameText(Parent, Probe) then
      Break;
    Probe := Parent;
    if CandidateHasPhosphor(TPath.Combine(Probe, 'assets')) then
      Exit(ExcludeTrailingPathDelimiter(TPath.GetFullPath(TPath.Combine(Probe, 'assets'))));
  end;

  Result := ExcludeTrailingPathDelimiter(TPath.GetFullPath(TPath.Combine(ExeDir, 'assets')));
end;

function FindNatiaRepoRoot: string;
var
  Assets: string;
begin
  Assets := FindNatiaAssetsRoot;
  Result := ExcludeTrailingPathDelimiter(ExtractFilePath(Assets + '\'));
end;

function FindNatiaRepoFile(const ARelativePath: string): string;
begin
  Result := TPath.Combine(FindNatiaRepoRoot, ARelativePath);
end;

end.
