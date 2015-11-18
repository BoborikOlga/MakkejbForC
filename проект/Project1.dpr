program Project1;

uses
  Forms,
  UnitMetrix in 'UnitMetrix.pas' {FormMetrix};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMetrix, FormMetrix);
  Application.Run;
end.
