unit Natia.Domain.Knowledge;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Natia.Domain.Identifiers,
  Natia.Domain.Exceptions;

type
  TKnowledgeKind = (kkFact, kkDecision, kkScratch);

  TKnowledgeStatus = (ksDraft, ksAccepted, ksRejected, ksSuperseded);

  TKnowledgeProvenance = (
    kpAuthored,
    kpImported,
    kpPromotedFromConversation,
    kpDerivedFromTool,
    kpImportedFromRepository
  );

  TDecisionShape = record
    Context: string;
    Decision: string;
    Alternatives: TArray<string>;
    Rationale: string;
    Consequences: TArray<string>;
    Supersedes: string;
    ExternalReference: string;
    class function Empty: TDecisionShape; static;
    procedure ValidateRequired;
  end;

  TKnowledgeProvenanceInfo = record
    Kind: TKnowledgeProvenance;
    ConversationId: TConversationId;
    MessageId: TMessageId;
    HasConversationRef: Boolean;
    class function Authored: TKnowledgeProvenanceInfo; static;
    class function Promoted(
      const AConversationId: TConversationId;
      const AMessageId: TMessageId
    ): TKnowledgeProvenanceInfo; static;
  end;

  TKnowledgeEntry = class
  private
    FId: TKnowledgeEntryId;
    FWorkspaceId: TWorkspaceId;
    FKind: TKnowledgeKind;
    FStatus: TKnowledgeStatus;
    FTitle: string;
    FBody: string;
    FProvenance: TKnowledgeProvenanceInfo;
    FDecision: TDecisionShape;
    FCreatedAt: TDateTime;
    constructor CreateInternal(
      const AId: TKnowledgeEntryId;
      const AWorkspaceId: TWorkspaceId;
      const AKind: TKnowledgeKind;
      const ATitle: string;
      const ABody: string;
      const AProvenance: TKnowledgeProvenanceInfo;
      const ADecision: TDecisionShape;
      const ACreatedAt: TDateTime
    );
  public
    class function CreateFact(
      const AId: TKnowledgeEntryId;
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ABody: string;
      const AProvenance: TKnowledgeProvenanceInfo;
      const ACreatedAt: TDateTime
    ): TKnowledgeEntry; static;
    class function CreateScratch(
      const AId: TKnowledgeEntryId;
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ABody: string;
      const AProvenance: TKnowledgeProvenanceInfo;
      const ACreatedAt: TDateTime
    ): TKnowledgeEntry; static;
    class function CreateDecision(
      const AId: TKnowledgeEntryId;
      const AWorkspaceId: TWorkspaceId;
      const ATitle: string;
      const ADecision: TDecisionShape;
      const AProvenance: TKnowledgeProvenanceInfo;
      const ACreatedAt: TDateTime
    ): TKnowledgeEntry; static;

    procedure Accept;
    procedure Reject;
    procedure Supersede;
    procedure ConvertToFact;
    procedure ConvertToDecision(const ADecision: TDecisionShape);

    property Id: TKnowledgeEntryId read FId;
    property WorkspaceId: TWorkspaceId read FWorkspaceId;
    property Kind: TKnowledgeKind read FKind;
    property Status: TKnowledgeStatus read FStatus;
    property Title: string read FTitle;
    property Body: string read FBody;
    property Provenance: TKnowledgeProvenanceInfo read FProvenance;
    property Decision: TDecisionShape read FDecision;
    property CreatedAt: TDateTime read FCreatedAt;
  end;

function KnowledgeKindToString(const AKind: TKnowledgeKind): string;
function KnowledgeStatusToString(const AStatus: TKnowledgeStatus): string;
function KnowledgeProvenanceToString(const AProv: TKnowledgeProvenance): string;

implementation

function KnowledgeKindToString(const AKind: TKnowledgeKind): string;
begin
  case AKind of
    kkFact: Result := 'Fact';
    kkDecision: Result := 'Decision';
    kkScratch: Result := 'Scratch';
  else
    Result := 'Unknown';
  end;
end;

function KnowledgeStatusToString(const AStatus: TKnowledgeStatus): string;
begin
  case AStatus of
    ksDraft: Result := 'Draft';
    ksAccepted: Result := 'Accepted';
    ksRejected: Result := 'Rejected';
    ksSuperseded: Result := 'Superseded';
  else
    Result := 'Unknown';
  end;
end;

function KnowledgeProvenanceToString(const AProv: TKnowledgeProvenance): string;
begin
  case AProv of
    kpAuthored: Result := 'Authored';
    kpImported: Result := 'Imported';
    kpPromotedFromConversation: Result := 'PromotedFromConversation';
    kpDerivedFromTool: Result := 'DerivedFromTool';
    kpImportedFromRepository: Result := 'ImportedFromRepository';
  else
    Result := 'Unknown';
  end;
end;

{ TDecisionShape }

class function TDecisionShape.Empty: TDecisionShape;
begin
  Result.Context := '';
  Result.Decision := '';
  SetLength(Result.Alternatives, 0);
  Result.Rationale := '';
  SetLength(Result.Consequences, 0);
  Result.Supersedes := '';
  Result.ExternalReference := '';
end;

procedure TDecisionShape.ValidateRequired;
begin
  if Trim(Context) = '' then
    raise ENatiaDomainError.Create('Decision context is required');
  if Trim(Decision) = '' then
    raise ENatiaDomainError.Create('Decision text is required');
  if Trim(Rationale) = '' then
    raise ENatiaDomainError.Create('Decision rationale is required');
end;

{ TKnowledgeProvenanceInfo }

class function TKnowledgeProvenanceInfo.Authored: TKnowledgeProvenanceInfo;
begin
  Result.Kind := kpAuthored;
  Result.HasConversationRef := False;
end;

class function TKnowledgeProvenanceInfo.Promoted(
  const AConversationId: TConversationId;
  const AMessageId: TMessageId
): TKnowledgeProvenanceInfo;
begin
  Result.Kind := kpPromotedFromConversation;
  Result.ConversationId := AConversationId;
  Result.MessageId := AMessageId;
  Result.HasConversationRef := True;
end;

{ TKnowledgeEntry }

constructor TKnowledgeEntry.CreateInternal(
  const AId: TKnowledgeEntryId;
  const AWorkspaceId: TWorkspaceId;
  const AKind: TKnowledgeKind;
  const ATitle: string;
  const ABody: string;
  const AProvenance: TKnowledgeProvenanceInfo;
  const ADecision: TDecisionShape;
  const ACreatedAt: TDateTime
);
begin
  inherited Create;
  FId := AId;
  FWorkspaceId := AWorkspaceId;
  FKind := AKind;
  FStatus := ksDraft;
  FTitle := ATitle;
  FBody := ABody;
  FProvenance := AProvenance;
  FDecision := ADecision;
  FCreatedAt := ACreatedAt;
end;

class function TKnowledgeEntry.CreateFact(
  const AId: TKnowledgeEntryId;
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ABody: string;
  const AProvenance: TKnowledgeProvenanceInfo;
  const ACreatedAt: TDateTime
): TKnowledgeEntry;
begin
  Result := TKnowledgeEntry.CreateInternal(
    AId, AWorkspaceId, kkFact, ATitle, ABody, AProvenance, TDecisionShape.Empty, ACreatedAt);
end;

class function TKnowledgeEntry.CreateScratch(
  const AId: TKnowledgeEntryId;
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ABody: string;
  const AProvenance: TKnowledgeProvenanceInfo;
  const ACreatedAt: TDateTime
): TKnowledgeEntry;
begin
  Result := TKnowledgeEntry.CreateInternal(
    AId, AWorkspaceId, kkScratch, ATitle, ABody, AProvenance, TDecisionShape.Empty, ACreatedAt);
end;

class function TKnowledgeEntry.CreateDecision(
  const AId: TKnowledgeEntryId;
  const AWorkspaceId: TWorkspaceId;
  const ATitle: string;
  const ADecision: TDecisionShape;
  const AProvenance: TKnowledgeProvenanceInfo;
  const ACreatedAt: TDateTime
): TKnowledgeEntry;
begin
  ADecision.ValidateRequired;
  Result := TKnowledgeEntry.CreateInternal(
    AId, AWorkspaceId, kkDecision, ATitle, ADecision.Decision, AProvenance, ADecision, ACreatedAt);
  if Length(Result.FDecision.Alternatives) = 0 then
    SetLength(Result.FDecision.Alternatives, 0);
  if Length(Result.FDecision.Consequences) = 0 then
    SetLength(Result.FDecision.Consequences, 0);
end;

procedure TKnowledgeEntry.Accept;
begin
  if FKind = kkScratch then
    raise ENatiaDomainError.Create('Scratch cannot be accepted; convert to Fact or Decision first');
  if FStatus <> ksDraft then
    raise ENatiaDomainError.Create('Only Draft knowledge can be accepted');
  if FKind = kkDecision then
    FDecision.ValidateRequired;
  FStatus := ksAccepted;
end;

procedure TKnowledgeEntry.Reject;
begin
  if FStatus <> ksDraft then
    raise ENatiaDomainError.Create('Only Draft knowledge can be rejected');
  FStatus := ksRejected;
end;

procedure TKnowledgeEntry.Supersede;
begin
  if FStatus <> ksAccepted then
    raise ENatiaDomainError.Create('Only Accepted knowledge can be superseded');
  FStatus := ksSuperseded;
end;

procedure TKnowledgeEntry.ConvertToFact;
begin
  if FKind <> kkScratch then
    raise ENatiaDomainError.Create('Only Scratch can convert to Fact');
  if FStatus <> ksDraft then
    raise ENatiaDomainError.Create('Only Draft Scratch can convert');
  FKind := kkFact;
end;

procedure TKnowledgeEntry.ConvertToDecision(const ADecision: TDecisionShape);
begin
  if FKind <> kkScratch then
    raise ENatiaDomainError.Create('Only Scratch can convert to Decision');
  if FStatus <> ksDraft then
    raise ENatiaDomainError.Create('Only Draft Scratch can convert');
  ADecision.ValidateRequired;
  FKind := kkDecision;
  FDecision := ADecision;
  FBody := ADecision.Decision;
end;

end.
