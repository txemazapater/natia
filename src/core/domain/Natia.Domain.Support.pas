unit Natia.Domain.Support;

interface

uses
  System.SysUtils;

type
  IClock = interface
    ['{A1B2C3D4-E5F6-4789-A012-3456789ABC01}']
    function UtcNow: TDateTime;
  end;

  IIdGenerator = interface
    ['{A1B2C3D4-E5F6-4789-A012-3456789ABC02}']
    function NewGuid: TGUID;
  end;

  TSystemClock = class(TInterfacedObject, IClock)
  public
    function UtcNow: TDateTime;
  end;

  TGuidIdGenerator = class(TInterfacedObject, IIdGenerator)
  public
    function NewGuid: TGUID;
  end;

implementation

uses
  System.DateUtils;

{ TSystemClock }

function TSystemClock.UtcNow: TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(Now);
end;

{ TGuidIdGenerator }

function TGuidIdGenerator.NewGuid: TGUID;
begin
  CreateGUID(Result);
end;

end.
