program Admin_p;

uses
  Forms,
  Admin_u in 'Admin_u.pas' {FrmAdmin};

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmAdmin, FrmAdmin);
  Application.Run;
end.
