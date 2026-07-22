unit Natia.Theme;

{ NATIA Studio — tokens visuales compartidos. Sin lógica de negocio. }

interface

uses
  Vcl.Graphics;

type
  TNatiaTheme = record
  public
    class function AppBack: TColor; static;
    class function Surface: TColor; static;
    class function SurfaceAlt: TColor; static;
    class function NavBack: TColor; static;
    class function NavSelected: TColor; static;
    class function Border: TColor; static;
    class function Accent: TColor; static;
    class function AccentSoft: TColor; static;
    class function TextPrimary: TColor; static;
    class function TextSecondary: TColor; static;
    class function TextOnNav: TColor; static;
    class function Success: TColor; static;
    class function Warning: TColor; static;
    class function Danger: TColor; static;
    class function CardBack: TColor; static;
  end;

implementation

class function TNatiaTheme.AppBack: TColor;
begin
  Result := $F3F2F1; // cool gray workspace
end;

class function TNatiaTheme.Surface: TColor;
begin
  Result := clWhite;
end;

class function TNatiaTheme.SurfaceAlt: TColor;
begin
  Result := $FAF9F8;
end;

class function TNatiaTheme.NavBack: TColor;
begin
  Result := $2B2B2B;
end;

class function TNatiaTheme.NavSelected: TColor;
begin
  Result := $3F3F3F;
end;

class function TNatiaTheme.Border: TColor;
begin
  Result := $D4D4D4;
end;

class function TNatiaTheme.Accent: TColor;
begin
  Result := $C65D0D; // restrained blue-steel (BGR: professional, not purple)
end;

class function TNatiaTheme.AccentSoft: TColor;
begin
  Result := $F0E6DC;
end;

class function TNatiaTheme.TextPrimary: TColor;
begin
  Result := $1F1F1F;
end;

class function TNatiaTheme.TextSecondary: TColor;
begin
  Result := $666666;
end;

class function TNatiaTheme.TextOnNav: TColor;
begin
  Result := $E8E8E8;
end;

class function TNatiaTheme.Success: TColor;
begin
  Result := $2E7D32;
end;

class function TNatiaTheme.Warning: TColor;
begin
  Result := $0277BD;
end;

class function TNatiaTheme.Danger: TColor;
begin
  Result := $2A2AE0;
end;

class function TNatiaTheme.CardBack: TColor;
begin
  Result := clWhite;
end;

end.
