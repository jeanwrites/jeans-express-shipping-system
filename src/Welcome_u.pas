unit Welcome_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GIFImg, StdCtrls, Buttons, pngimage, Consumer_u,  Admin_u;

type
  TFrmWelcome = class(TForm)
    ImgPlane: TImage;
    PnlCaption: TPanel;
    PnLButtons: TPanel;
    BitBtnConsumer: TBitBtn;
    BitBtnAdmin: TBitBtn;
    BitBtnHelp: TBitBtn;
    ImgBack: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnHelpClick(Sender: TObject);
    procedure BitBtnConsumerClick(Sender: TObject);
    procedure BitBtnAdminClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmWelcome: TFrmWelcome;

implementation

{$R *.dfm}

procedure TFrmWelcome.BitBtnConsumerClick(Sender: TObject);      //DISPLAY CONSUMER FORM
begin
   IF NOT Assigned(FrmConsumer) Then
           Application.CreateForm(Tfrmconsumer, Frmconsumer);

 //CODE FROM : https://docwiki.embarcadero.com/Libraries/Athens/en/Vcl.Forms.TApplication.CreateForm   AND
         //  https://docwiki.embarcadero.com/CodeExamples/Athens/en/TAppCreateForm_(Delphi)
               FrmConsumer.Show;
end;




procedure TFrmWelcome.BitBtnAdminClick(Sender: TObject);
begin
    IF NOT Assigned(FrmAdmin) Then                           //DISPLAY ADMIN FORM
                Application.CreateForm(Tfrmadmin, Frmadmin);

     FrmAdmin.Show;
end;




procedure TFrmWelcome.BitBtnHelpClick(Sender: TObject);          //  HELP BUTTON MESSAGE
begin
ShowMessage('Welcome to Jean''s Express! To help us serve you better, ' +
'please select your user type: Consumer or Administrator.');
end;




procedure TFrmWelcome.FormCreate(Sender: TObject);
begin
         //  CONSUMER    ICON FROM : https://icons8.com/icons/set/consumer
         //  ADMIN       ICON FROM : https://icons8.com/icons/set/admin

    (Imgplane.Picture.Graphic as TGIFImage).Animate := True;
    (Imgplane.Picture.Graphic as TGIFImage).AnimationSpeed := 75;
                //  GIF FROM : https://pixabay.com/gifs/airline-airplane-plane-revolving-185/
                // CODE FROM  YOUTUBE : https://youtu.be/eHw7SvimazM?si=ejFoPMax_u4E0nmo
end;

end.
