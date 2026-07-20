unit Natia.Tests.Acceptance;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Natia.Tests.Fixtures,
  Natia.Domain.Workspace,
  Natia.Domain.WorkspaceRuntime,
  Natia.Domain.Conversation,
  Natia.Domain.Knowledge,
  Natia.Domain.Events,
  Natia.Domain.Exceptions,
  Natia.Domain.Identifiers,
  Natia.Contracts.Export;

type
  [TestFixture]
  TAcceptanceTests = class
  private
    FCtx: TCoreTestContext;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure CreateWorkspace_AndRetrieveFromRepository;
    [Test]
    procedure RenameWorkspace_UpdatesState_AndEmitsFactEvent;
    [Test]
    procedure ArchiveWorkspace_BlocksRename;
    [Test]
    procedure TwoRuntimes_CanExist_ForSameWorkspaceId;
    [Test]
    procedure ActivateWorkspace_DoesNotConnectBindingsAutomatically;
    [Test]
    procedure EnsureConnected_CanSucceed;
    [Test]
    procedure EnsureConnected_CanDegradeRuntime_WithoutDestroyingIt;
    [Test]
    procedure UnrequestedBindingFailure_DoesNotBlockActivation;
    [Test]
    procedure TenThousandMessages_DoNotCreateTenThousandFactEvents;
    [Test]
    procedure PromoteMessage_CreatesDraft_WithFullProvenance;
    [Test]
    procedure Scratch_CannotAcceptDirectly;
    [Test]
    procedure Scratch_CanConvertToFact_ThenAccept;
    [Test]
    procedure Scratch_CanConvertToDecision_WhenShapeValid;
    [Test]
    procedure Decision_WithoutContext_IsRejected;
    [Test]
    procedure Decision_WithoutDecisionText_IsRejected;
    [Test]
    procedure Decision_WithoutRationale_IsRejected;
    [Test]
    procedure Journal_ContainsFactEvents;
    [Test]
    procedure Journal_DoesNotContainSessionEvents;
    [Test]
    procedure Journal_DoesNotContainSignalEvents;
    [Test]
    procedure Exporter_RepresentsWorkspace_WithoutFilesystemOrSqlite;
  end;

implementation

{ TAcceptanceTests }

procedure TAcceptanceTests.Setup;
begin
  FCtx := TCoreTestContext.Create;
end;

procedure TAcceptanceTests.TearDown;
begin
  FCtx.Free;
  FCtx := nil;
end;

procedure TAcceptanceTests.CreateWorkspace_AndRetrieveFromRepository;
var
  Created, Loaded: TWorkspace;
begin
  Created := FCtx.WorkspaceApp.CreateWorkspace('Alpha', 'Instructions');
  Loaded := FCtx.Workspaces.FindById(Created.Id);
  Assert.IsNotNull(Loaded);
  Assert.AreEqual('Alpha', Loaded.Name);
  Assert.AreEqual(Ord(lsDraft), Ord(Loaded.LifecycleStatus));
end;

procedure TAcceptanceTests.RenameWorkspace_UpdatesState_AndEmitsFactEvent;
var
  Ws: TWorkspace;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Old');
  FCtx.WorkspaceApp.RenameWorkspace(Ws.Id, 'New');
  Assert.AreEqual('New', Ws.Name);
  Assert.IsTrue(FCtx.Journal.ContainsEventType(fetWorkspaceRenamed));
end;

procedure TAcceptanceTests.ArchiveWorkspace_BlocksRename;
var
  Ws: TWorkspace;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Archivable');
  FCtx.WorkspaceApp.ArchiveWorkspace(Ws.Id);
  Assert.WillRaise(
    procedure
    begin
      FCtx.WorkspaceApp.RenameWorkspace(Ws.Id, 'Nope');
    end,
    ENatiaDomainError
  );
end;

procedure TAcceptanceTests.TwoRuntimes_CanExist_ForSameWorkspaceId;
var
  Ws: TWorkspace;
  R1, R2: TWorkspaceRuntime;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('MultiRuntime');
  FCtx.WorkspaceApp.ActivateWorkspaceAdministratively(Ws.Id);
  R1 := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  R2 := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Assert.AreEqual(Ws.Id.ToString, R1.WorkspaceId.ToString);
    Assert.AreEqual(Ws.Id.ToString, R2.WorkspaceId.ToString);
    Assert.AreNotEqual(R1.RuntimeId.ToString, R2.RuntimeId.ToString);
  finally
    R2.Free;
    R1.Free;
  end;
end;

procedure TAcceptanceTests.ActivateWorkspace_DoesNotConnectBindingsAutomatically;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  Runtime: TWorkspaceRuntime;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Lazy');
  FCtx.WorkspaceApp.ActivateWorkspaceAdministratively(Ws.Id);
  Binding := FCtx.WorkspaceApp.AddFileLocationBinding(Ws.Id, 'Files', 'C:\proj');
  Runtime := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Assert.AreEqual(Ord(rsReady), Ord(Runtime.Readiness));
    Assert.AreEqual(0, Runtime.ConnectionCount);
    Assert.IsFalse(Runtime.HasConnection(Binding.Id));
  finally
    Runtime.Free;
  end;
end;

procedure TAcceptanceTests.EnsureConnected_CanSucceed;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  Runtime: TWorkspaceRuntime;
  Outcome: TConnectionOutcome;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('ConnectOk');
  Binding := FCtx.WorkspaceApp.AddFileLocationBinding(Ws.Id, 'Files', 'C:\ok');
  FCtx.Connector.SetOutcome(Binding.Id, coSuccess);
  Runtime := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Outcome := FCtx.WorkspaceApp.EnsureConnected(Runtime, Binding.Id);
    Assert.AreEqual(Ord(coSuccess), Ord(Outcome));
    Assert.AreEqual(Ord(rsReady), Ord(Runtime.Readiness));
    Assert.IsTrue(Runtime.HasConnection(Binding.Id));
  finally
    Runtime.Free;
  end;
end;

procedure TAcceptanceTests.EnsureConnected_CanDegradeRuntime_WithoutDestroyingIt;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  Runtime: TWorkspaceRuntime;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Degrade');
  Binding := FCtx.WorkspaceApp.AddGenericEndpointBinding(Ws.Id, 'API', 'http://local');
  FCtx.Connector.SetOutcome(Binding.Id, coFailure);
  Runtime := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Assert.AreEqual(Ord(rsReady), Ord(Runtime.Readiness));
    FCtx.WorkspaceApp.EnsureConnected(Runtime, Binding.Id);
    Assert.AreEqual(Ord(rsDegraded), Ord(Runtime.Readiness));
    Assert.IsTrue(Runtime.HasConnection(Binding.Id));
  finally
    Runtime.Free;
  end;
end;

procedure TAcceptanceTests.UnrequestedBindingFailure_DoesNotBlockActivation;
var
  Ws: TWorkspace;
  Binding: TWorkspaceBinding;
  Runtime: TWorkspaceRuntime;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('NoAutoFail');
  Binding := FCtx.WorkspaceApp.AddFileLocationBinding(Ws.Id, 'Files', 'C:\x', True);
  FCtx.Connector.SetOutcome(Binding.Id, coFailure);
  Runtime := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Assert.AreEqual(Ord(rsReady), Ord(Runtime.Readiness));
    Assert.AreEqual(0, Runtime.ConnectionCount);
  finally
    Runtime.Free;
  end;
end;

procedure TAcceptanceTests.TenThousandMessages_DoNotCreateTenThousandFactEvents;
var
  Ws: TWorkspace;
  Conv: TConversation;
  I: Integer;
  FactsBefore, FactsAfter: Integer;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Chatty');
  Conv := FCtx.ConversationApp.CreateConversation(Ws.Id, 'Main');
  FactsBefore := FCtx.Journal.Count;
  for I := 1 to 10000 do
    FCtx.ConversationApp.AppendMessage(Conv.Id, mrUser, 'msg ' + IntToStr(I));
  FactsAfter := FCtx.Journal.Count;
  Assert.AreEqual(10000, Conv.MessageCount);
  Assert.AreEqual(FactsBefore, FactsAfter);
end;

procedure TAcceptanceTests.PromoteMessage_CreatesDraft_WithFullProvenance;
var
  Ws: TWorkspace;
  Conv: TConversation;
  Msg: TMessage;
  Entry: TKnowledgeEntry;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Promote');
  Conv := FCtx.ConversationApp.CreateConversation(Ws.Id, 'C1');
  Msg := FCtx.ConversationApp.AppendMessage(Conv.Id, mrUser, 'We chose SQLite later');
  Entry := FCtx.KnowledgeApp.PromoteMessageToKnowledge(Conv.Id, Msg.Id, 'Choice');
  Assert.AreEqual(Ord(ksDraft), Ord(Entry.Status));
  Assert.AreEqual(Ord(kkFact), Ord(Entry.Kind));
  Assert.AreEqual(Ord(kpPromotedFromConversation), Ord(Entry.Provenance.Kind));
  Assert.IsTrue(Entry.Provenance.HasConversationRef);
  Assert.AreEqual(Conv.Id.ToString, Entry.Provenance.ConversationId.ToString);
  Assert.AreEqual(Msg.Id.ToString, Entry.Provenance.MessageId.ToString);
  Assert.AreEqual(Ws.Id.ToString, Entry.WorkspaceId.ToString);
end;

procedure TAcceptanceTests.Scratch_CannotAcceptDirectly;
var
  Ws: TWorkspace;
  Entry: TKnowledgeEntry;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('ScratchBlock');
  Entry := FCtx.KnowledgeApp.CreateScratch(Ws.Id, 'Note', 'wip');
  Assert.WillRaise(
    procedure
    begin
      FCtx.KnowledgeApp.AcceptKnowledge(Entry.Id);
    end,
    ENatiaDomainError
  );
end;

procedure TAcceptanceTests.Scratch_CanConvertToFact_ThenAccept;
var
  Ws: TWorkspace;
  Entry: TKnowledgeEntry;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('ScratchFact');
  Entry := FCtx.KnowledgeApp.CreateScratch(Ws.Id, 'Note', 'wip');
  FCtx.KnowledgeApp.ConvertScratchToFact(Entry.Id);
  FCtx.KnowledgeApp.AcceptKnowledge(Entry.Id);
  Assert.AreEqual(Ord(kkFact), Ord(Entry.Kind));
  Assert.AreEqual(Ord(ksAccepted), Ord(Entry.Status));
  Assert.IsTrue(FCtx.Journal.ContainsEventType(fetKnowledgeAccepted));
end;

procedure TAcceptanceTests.Scratch_CanConvertToDecision_WhenShapeValid;
var
  Ws: TWorkspace;
  Entry: TKnowledgeEntry;
  Shape: TDecisionShape;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('ScratchDec');
  Entry := FCtx.KnowledgeApp.CreateScratch(Ws.Id, 'Note', 'wip');
  Shape := TDecisionShape.Empty;
  Shape.Context := 'Need persistence';
  Shape.Decision := 'Use operational store';
  Shape.Rationale := 'Integrity over dual-write';
  FCtx.KnowledgeApp.ConvertScratchToDecision(Entry.Id, Shape);
  Assert.AreEqual(Ord(kkDecision), Ord(Entry.Kind));
  FCtx.KnowledgeApp.AcceptKnowledge(Entry.Id);
  Assert.AreEqual(Ord(ksAccepted), Ord(Entry.Status));
end;

procedure TAcceptanceTests.Decision_WithoutContext_IsRejected;
var
  Ws: TWorkspace;
  Shape: TDecisionShape;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('DecCtx');
  Shape := TDecisionShape.Empty;
  Shape.Decision := 'X';
  Shape.Rationale := 'Y';
  Assert.WillRaise(
    procedure
    begin
      FCtx.KnowledgeApp.CreateDecision(Ws.Id, 'D', Shape);
    end,
    ENatiaDomainError
  );
end;

procedure TAcceptanceTests.Decision_WithoutDecisionText_IsRejected;
var
  Ws: TWorkspace;
  Shape: TDecisionShape;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('DecTxt');
  Shape := TDecisionShape.Empty;
  Shape.Context := 'C';
  Shape.Rationale := 'R';
  Assert.WillRaise(
    procedure
    begin
      FCtx.KnowledgeApp.CreateDecision(Ws.Id, 'D', Shape);
    end,
    ENatiaDomainError
  );
end;

procedure TAcceptanceTests.Decision_WithoutRationale_IsRejected;
var
  Ws: TWorkspace;
  Shape: TDecisionShape;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('DecRat');
  Shape := TDecisionShape.Empty;
  Shape.Context := 'C';
  Shape.Decision := 'D';
  Assert.WillRaise(
    procedure
    begin
      FCtx.KnowledgeApp.CreateDecision(Ws.Id, 'D', Shape);
    end,
    ENatiaDomainError
  );
end;

procedure TAcceptanceTests.Journal_ContainsFactEvents;
var
  Ws: TWorkspace;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Facts');
  Assert.IsTrue(FCtx.Journal.ContainsEventType(fetWorkspaceCreated));
  Assert.IsTrue(FCtx.Journal.CountForWorkspace(Ws.Id) >= 1);
end;

procedure TAcceptanceTests.Journal_DoesNotContainSessionEvents;
var
  Ws: TWorkspace;
  Runtime: TWorkspaceRuntime;
  Ev: TFactEvent;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Sessions');
  Runtime := FCtx.WorkspaceApp.ActivateRuntime(Ws.Id);
  try
    Assert.IsTrue(FCtx.Sessions.Count > 0);
    for Ev in FCtx.Journal.GetAll do
      Assert.AreNotEqual('RuntimeActivationCompleted', FactEventTypeToString(Ev.EventType));
  finally
    Runtime.Free;
  end;
end;

procedure TAcceptanceTests.Journal_DoesNotContainSignalEvents;
var
  Ws: TWorkspace;
  Ev: TFactEvent;
  Name: string;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('Signals');
  Assert.IsNotNull(Ws);
  for Ev in FCtx.Journal.GetAll do
  begin
    Name := FactEventTypeToString(Ev.EventType);
    Assert.AreNotEqual('TokenReceived', Name);
    Assert.AreNotEqual('StreamingChunk', Name);
    Assert.AreNotEqual('ToolProgress', Name);
    Assert.AreNotEqual('WorkerHeartbeat', Name);
  end;
end;

procedure TAcceptanceTests.Exporter_RepresentsWorkspace_WithoutFilesystemOrSqlite;
var
  Ws: TWorkspace;
  Doc: TWorkspaceExportDocument;
begin
  Ws := FCtx.WorkspaceApp.CreateWorkspace('ExportMe', 'Do things', 'prov-1', 'model-1');
  FCtx.WorkspaceApp.AddFileLocationBinding(Ws.Id, 'Files', 'C:\data');
  FCtx.KnowledgeApp.CreateScratch(Ws.Id, 'S', 'body');
  FCtx.ConversationApp.CreateConversation(Ws.Id, 'Talk');
  Doc := FCtx.Exporter.ExportWorkspace(Ws.Id);
  Assert.AreEqual('ExportMe', Doc.Name);
  Assert.AreEqual(1, Doc.BindingCount);
  Assert.AreEqual(1, Doc.KnowledgeCount);
  Assert.AreEqual(1, Doc.ConversationCount);
  Assert.IsTrue(Pos('NATIA Workspace Export', Doc.Text) > 0);
  Assert.IsTrue(Pos('ProviderId=prov-1', Doc.Text) > 0);
  Assert.IsTrue(Pos('SQLite', Doc.Text) = 0);
end;

initialization
  TDUnitX.RegisterTestFixture(TAcceptanceTests);

end.
