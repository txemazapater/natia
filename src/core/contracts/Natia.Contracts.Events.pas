unit Natia.Contracts.Events;

interface

uses
  System.Generics.Collections,
  Natia.Domain.Events,
  Natia.Domain.Identifiers;

type
  IEventJournal = interface
    ['{B1C2D3E4-F5A6-4789-B012-3456789ABC10}']
    procedure Append(AEvent: TFactEvent);
    function Count: Integer;
    function CountForWorkspace(const AWorkspaceId: TWorkspaceId): Integer;
    function GetAll: TArray<TFactEvent>;
    function ContainsEventType(const AType: TFactEventType): Boolean;
  end;

  ISessionEventSink = interface
    ['{B1C2D3E4-F5A6-4789-B012-3456789ABC11}']
    procedure Append(AEvent: TSessionEvent);
    function Count: Integer;
    function GetAll: TArray<TSessionEvent>;
  end;

implementation

end.
