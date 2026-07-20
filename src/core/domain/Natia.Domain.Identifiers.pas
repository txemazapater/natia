unit Natia.Domain.Identifiers;

interface

uses
  System.SysUtils;

type
  TWorkspaceId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TWorkspaceId; static;
    class function FromGuid(const AValue: TGUID): TWorkspaceId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TWorkspaceId): Boolean;
    class operator NotEqual(const A, B: TWorkspaceId): Boolean;
  end;

  TRuntimeId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TRuntimeId; static;
    class function FromGuid(const AValue: TGUID): TRuntimeId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TRuntimeId): Boolean;
    class operator NotEqual(const A, B: TRuntimeId): Boolean;
  end;

  TBindingId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TBindingId; static;
    class function FromGuid(const AValue: TGUID): TBindingId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TBindingId): Boolean;
    class operator NotEqual(const A, B: TBindingId): Boolean;
  end;

  TConversationId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TConversationId; static;
    class function FromGuid(const AValue: TGUID): TConversationId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TConversationId): Boolean;
    class operator NotEqual(const A, B: TConversationId): Boolean;
  end;

  TMessageId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TMessageId; static;
    class function FromGuid(const AValue: TGUID): TMessageId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TMessageId): Boolean;
    class operator NotEqual(const A, B: TMessageId): Boolean;
  end;

  TKnowledgeEntryId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TKnowledgeEntryId; static;
    class function FromGuid(const AValue: TGUID): TKnowledgeEntryId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TKnowledgeEntryId): Boolean;
    class operator NotEqual(const A, B: TKnowledgeEntryId): Boolean;
  end;

  TEventId = record
    Value: TGUID;
    class function CreateNew(const AGenerator: TGUID): TEventId; static;
    class function FromGuid(const AValue: TGUID): TEventId; static;
    function IsEmpty: Boolean;
    function ToString: string;
    class operator Equal(const A, B: TEventId): Boolean;
    class operator NotEqual(const A, B: TEventId): Boolean;
  end;

implementation

function GuidToPlain(const G: TGUID): string;
begin
  Result := GUIDToString(G);
end;

{ TWorkspaceId }

class function TWorkspaceId.CreateNew(const AGenerator: TGUID): TWorkspaceId;
begin
  Result.Value := AGenerator;
end;

class function TWorkspaceId.FromGuid(const AValue: TGUID): TWorkspaceId;
begin
  Result.Value := AValue;
end;

function TWorkspaceId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TWorkspaceId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TWorkspaceId.Equal(const A, B: TWorkspaceId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TWorkspaceId.NotEqual(const A, B: TWorkspaceId): Boolean;
begin
  Result := not (A = B);
end;

{ TRuntimeId }

class function TRuntimeId.CreateNew(const AGenerator: TGUID): TRuntimeId;
begin
  Result.Value := AGenerator;
end;

class function TRuntimeId.FromGuid(const AValue: TGUID): TRuntimeId;
begin
  Result.Value := AValue;
end;

function TRuntimeId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TRuntimeId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TRuntimeId.Equal(const A, B: TRuntimeId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TRuntimeId.NotEqual(const A, B: TRuntimeId): Boolean;
begin
  Result := not (A = B);
end;

{ TBindingId }

class function TBindingId.CreateNew(const AGenerator: TGUID): TBindingId;
begin
  Result.Value := AGenerator;
end;

class function TBindingId.FromGuid(const AValue: TGUID): TBindingId;
begin
  Result.Value := AValue;
end;

function TBindingId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TBindingId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TBindingId.Equal(const A, B: TBindingId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TBindingId.NotEqual(const A, B: TBindingId): Boolean;
begin
  Result := not (A = B);
end;

{ TConversationId }

class function TConversationId.CreateNew(const AGenerator: TGUID): TConversationId;
begin
  Result.Value := AGenerator;
end;

class function TConversationId.FromGuid(const AValue: TGUID): TConversationId;
begin
  Result.Value := AValue;
end;

function TConversationId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TConversationId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TConversationId.Equal(const A, B: TConversationId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TConversationId.NotEqual(const A, B: TConversationId): Boolean;
begin
  Result := not (A = B);
end;

{ TMessageId }

class function TMessageId.CreateNew(const AGenerator: TGUID): TMessageId;
begin
  Result.Value := AGenerator;
end;

class function TMessageId.FromGuid(const AValue: TGUID): TMessageId;
begin
  Result.Value := AValue;
end;

function TMessageId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TMessageId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TMessageId.Equal(const A, B: TMessageId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TMessageId.NotEqual(const A, B: TMessageId): Boolean;
begin
  Result := not (A = B);
end;

{ TKnowledgeEntryId }

class function TKnowledgeEntryId.CreateNew(const AGenerator: TGUID): TKnowledgeEntryId;
begin
  Result.Value := AGenerator;
end;

class function TKnowledgeEntryId.FromGuid(const AValue: TGUID): TKnowledgeEntryId;
begin
  Result.Value := AValue;
end;

function TKnowledgeEntryId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TKnowledgeEntryId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TKnowledgeEntryId.Equal(const A, B: TKnowledgeEntryId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TKnowledgeEntryId.NotEqual(const A, B: TKnowledgeEntryId): Boolean;
begin
  Result := not (A = B);
end;

{ TEventId }

class function TEventId.CreateNew(const AGenerator: TGUID): TEventId;
begin
  Result.Value := AGenerator;
end;

class function TEventId.FromGuid(const AValue: TGUID): TEventId;
begin
  Result.Value := AValue;
end;

function TEventId.IsEmpty: Boolean;
begin
  Result := Value = TGUID.Empty;
end;

function TEventId.ToString: string;
begin
  Result := GuidToPlain(Value);
end;

class operator TEventId.Equal(const A, B: TEventId): Boolean;
begin
  Result := A.Value = B.Value;
end;

class operator TEventId.NotEqual(const A, B: TEventId): Boolean;
begin
  Result := not (A = B);
end;

end.
