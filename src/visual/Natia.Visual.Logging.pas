unit Natia.Visual.Logging;

interface

type
  TVisualLogLevel = (vllDebug, vllInfo, vllWarn, vllError);

  TVisualLogProc = reference to procedure(ALevel: TVisualLogLevel; const AMessage: string);

procedure VisualLogSetHandler(const AHandler: TVisualLogProc);
procedure VisualLog(ALevel: TVisualLogLevel; const AMessage: string);
procedure VisualLogFmt(ALevel: TVisualLogLevel; const AFmt: string; const AArgs: array of const);

implementation

uses
  System.SysUtils;

var
  GHandler: TVisualLogProc;

procedure VisualLogSetHandler(const AHandler: TVisualLogProc);
begin
  GHandler := AHandler;
end;

procedure VisualLog(ALevel: TVisualLogLevel; const AMessage: string);
begin
  if Assigned(GHandler) then
    GHandler(ALevel, AMessage);
end;

procedure VisualLogFmt(ALevel: TVisualLogLevel; const AFmt: string; const AArgs: array of const);
begin
  VisualLog(ALevel, Format(AFmt, AArgs));
end;

end.
