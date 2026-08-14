program Welcome_p;

uses
  Forms,
  Welcome_u in 'Welcome_u.pas' {FrmWelcome};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmWelcome, FrmWelcome);
  Application.Run;
end.
