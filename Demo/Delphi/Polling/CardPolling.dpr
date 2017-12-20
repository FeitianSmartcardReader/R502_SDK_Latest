program CardPolling;

uses
  Forms,
  Polling in 'Polling.pas' {MainPolling};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainPolling, MainPolling);
  Application.Run;
end.
