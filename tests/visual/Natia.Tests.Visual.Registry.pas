unit Natia.Tests.Visual.Registry;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.IOUtils,
  Natia.Visual.Types,
  Natia.Visual.Paths,
  Natia.Visual.Provider.Phosphor,
  Natia.Visual.Registry,
  Natia.Visual.Provider;

type
  [TestFixture]
  TVisualRegistryTests = class
  private
    FRegistry: TVisualAssetRegistry;
    FProvider: IVisualAssetProvider;
    function PhosphorRoot: string;
    function IndexPath: string;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure ParsesRobotDuotone;
    [Test]
    procedure RejectsUnknownScheme;
    [Test]
    procedure RejectsThinWeight;
    [Test]
    procedure RejectsPathTraversal;
    [Test]
    procedure NormalizesCase;
    [Test]
    procedure IndexLoads;
    [Test]
    procedure ExistsWorks;
    [Test]
    procedure CacheKeyChangesWithSizeAndDpi;
    [Test]
    procedure SecondResolveUsesCache;
    [Test]
    procedure MissingAssetUsesFallback;
    [Test]
    procedure RasterizeProducesExpectedSize;
  end;

implementation

function TVisualRegistryTests.PhosphorRoot: string;
begin
  Result := TPath.Combine(FindNatiaAssetsRoot, 'icons\phosphor');
end;

function TVisualRegistryTests.IndexPath: string;
begin
  Result := TPath.Combine(PhosphorRoot, 'index.json');
end;

procedure TVisualRegistryTests.SetUp;
begin
  FRegistry := TVisualAssetRegistry.Create;
  FProvider := TPhosphorAssetProvider.Create(PhosphorRoot, IndexPath);
  FRegistry.RegisterProvider(FProvider);
end;

procedure TVisualRegistryTests.TearDown;
begin
  FreeAndNil(FRegistry);
  FProvider := nil;
end;

procedure TVisualRegistryTests.ParsesRobotDuotone;
var
  Path: string;
begin
  Assert.IsTrue(TFile.Exists(IndexPath), 'index missing: ' + IndexPath);
  Assert.IsTrue(FProvider.CanHandle('phosphor://robot/duotone'), 'CanHandle');
  try
    Path := FProvider.ResolveSourcePath('phosphor://robot/duotone');
  except
    on E: Exception do
      Assert.Fail('ResolveSourcePath: ' + E.Message);
  end;
  Assert.IsTrue(TFile.Exists(Path), 'SVG missing: ' + Path);
  Assert.IsTrue(FProvider.Exists('phosphor://robot/duotone'), 'Exists');
end;

procedure TVisualRegistryTests.RejectsUnknownScheme;
begin
  Assert.IsFalse(FProvider.CanHandle('semantic://robot'));
  Assert.IsFalse(FRegistry.Exists('semantic://robot'));
end;

procedure TVisualRegistryTests.RejectsThinWeight;
begin
  Assert.IsFalse(FProvider.Exists('phosphor://robot/thin'));
  Assert.IsFalse(FProvider.Exists('phosphor://robot/light'));
end;

procedure TVisualRegistryTests.RejectsPathTraversal;
begin
  Assert.IsFalse(FProvider.Exists('phosphor://../robot/duotone'));
  Assert.IsFalse(FProvider.Exists('phosphor://robot/../duotone'));
end;

procedure TVisualRegistryTests.NormalizesCase;
begin
  Assert.IsTrue(FProvider.Exists('phosphor://Robot/Duotone'));
  Assert.IsTrue(FProvider.Exists('PHOSPHOR://ROBOT/DUOTONE'));
end;

procedure TVisualRegistryTests.IndexLoads;
begin
  Assert.IsTrue(FProvider.IconCount > 1000);
end;

procedure TVisualRegistryTests.ExistsWorks;
begin
  Assert.IsTrue(FRegistry.Exists('phosphor://question/regular'));
  Assert.IsFalse(FRegistry.Exists('phosphor://this-icon-does-not-exist/regular'));
end;

procedure TVisualRegistryTests.CacheKeyChangesWithSizeAndDpi;
var
  A, B, C: TVisualAssetRequest;
begin
  A := TVisualAssetRequest.Create('phosphor://robot/duotone', 24, 96);
  B := TVisualAssetRequest.Create('phosphor://robot/duotone', 32, 96);
  C := TVisualAssetRequest.Create('phosphor://robot/duotone', 24, 144);
  Assert.AreNotEqual(A.CacheKey, B.CacheKey);
  Assert.AreNotEqual(A.CacheKey, C.CacheKey);
end;

procedure TVisualRegistryTests.SecondResolveUsesCache;
var
  R1, R2: TResolvedVisualAsset;
begin
  R1 := FRegistry.ResolveIcon('phosphor://robot/duotone', 24, 96);
  try
    Assert.IsFalse(R1.FromCache);
  finally
    R1.Free;
  end;
  R2 := FRegistry.ResolveIcon('phosphor://robot/duotone', 24, 96);
  try
    Assert.IsTrue(R2.FromCache);
  finally
    R2.Free;
  end;
end;

procedure TVisualRegistryTests.MissingAssetUsesFallback;
var
  R: TResolvedVisualAsset;
begin
  R := FRegistry.ResolveIcon('phosphor://this-icon-does-not-exist/duotone', 24, 96);
  try
    Assert.IsTrue(R.UsedFallback);
    Assert.IsTrue(R.Bitmap <> nil);
    Assert.IsTrue(R.Bitmap.Width > 0);
  finally
    R.Free;
  end;
end;

procedure TVisualRegistryTests.RasterizeProducesExpectedSize;
var
  R: TResolvedVisualAsset;
begin
  R := FRegistry.ResolveIcon('phosphor://robot/regular', 24, 144);
  try
    Assert.AreEqual(36, R.PhysicalSize, 'physical size field');
    Assert.AreEqual(36, R.Bitmap.Width, 'bitmap width');
    Assert.AreEqual(36, R.Bitmap.Height, 'bitmap height');
    Assert.IsFalse(R.UsedFallback,
      Format('fallback used. resolved=%s requested=%s', [R.ResolvedId, R.RequestedId]));
  finally
    R.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TVisualRegistryTests);

end.
