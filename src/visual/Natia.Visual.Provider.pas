unit Natia.Visual.Provider;

interface

type
  IVisualAssetProvider = interface
    ['{A7B3C1D2-4E5F-6789-A1B2-C3D4E5F60789}']
    function ProviderId: string;
    function CanHandle(const AAssetId: string): Boolean;
    function Exists(const AAssetId: string): Boolean;
    function ResolveSourcePath(const AAssetId: string): string;
    function IconCount: Integer;
  end;

implementation

end.
