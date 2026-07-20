unit Natia.Domain.Exceptions;

interface

uses
  System.SysUtils;

type
  ENatiaDomainError = class(Exception);

  ENatiaNotFound = class(Exception);

  ENatiaConflict = class(Exception);

implementation

end.
