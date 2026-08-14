program Consumer_p;

uses
  Forms,
  Consumer_u in 'Consumer_u.pas' {FrmConsumer};

{$R *.res}








begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmConsumer, FrmConsumer);
  Application.Run;
end.
