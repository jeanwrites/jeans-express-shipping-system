unit Consumer_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Spin, DmShipment_u, Grids,
  DBGrids, ExtCtrls, DBCtrls, pngimage;

  //ICONS FROM:
  //https://icons8.com/icons/set/flight
  //https://icons8.com/icons/set/info
  //https://icons8.com/icons/set/status
  //https://icons8.com/icons/set/activityhistory


  type
  // TFlight represents a flight with key information
  TFlight = class
  private
    sDeparture: string;   // City where the flight departs
    sArrival: string;     // City where the flight arrives
    sFlight: string;      // Unique flight ID/code
    iDistance: Integer;   // Distance between departure and arrival cities (in km )

  public
    // Constructor to initialize the flight's data
    constructor Create(Departure, Arrival, Flight: string; Distance: Integer);


  end;

// Constant representing the maximum number of flights stored in the array
const
  MAX_FLIGHTS = 20;

// Declare an array to hold up to MAX_FLIGHTS flight objects
var
  arrFlights: array[0..MAX_FLIGHTS - 1] of TFlight;

// Procedure to load flight data into arrFlights array
procedure LoadFlights;

// Function to search for a flight by its ID
function FindFlight(const sFlightID: string): Boolean;




type
  TFrmConsumer = class(TForm)
    PgctrCONSUMER: TPageControl;
    TbshtOrder: TTabSheet;
    TbShtVerify: TTabSheet;
    TbShtAbout: TTabSheet;
    BitBtnReset: TBitBtn;
    BitBtnCalculate: TBitBtn;
    BitBtnClose: TBitBtn;
    BitBtnHelp1: TBitBtn;
    redtOrder: TRichEdit;
    CmbbxCargo: TComboBox;
    LblCaption: TLabel;
    LblCargo: TLabel;
    LblWeight: TLabel;
    LblArrival: TLabel;
    LblShipper: TLabel;
    LblReceiver: TLabel;
    Sedtweight: TSpinEdit;
    ChkbxFragile: TCheckBox;
    CmbbxDeparture: TComboBox;
    cmbbxArrival: TComboBox;
    edtshipper: TEdit;
    edtReceiver: TEdit;
    lblDeparture: TLabel;
    PnlVerify: TPanel;
    BitBtnHelp2: TBitBtn;
    BitBtnStatus: TBitBtn;
    redtstatus: TRichEdit;
    edtFlightID: TEdit;
    sedtCargoID: TSpinEdit;
    LblCargoID: TLabel;
    lblFlightID: TLabel;
    Dbgd1: TDBGrid;
    BitBtnConfirm: TBitBtn;
    redtaboutus: TRichEdit;
    cmbbxfaq: TComboBox;
    BitBtnAboutUs: TBitBtn;
    PnlAboutUs: TPanel;
    LblAboutUs: TLabel;
    BitbtnHelpAboutUs: TBitBtn;
    PnlOrder: TPanel;
    BitBtnCloseAboutUs: TBitBtn;
    Img1: TImage;
    Img2: TImage;
    LabelStatus: TLabel;
    BitBtnClose2: TBitBtn;
    BitBtnInfo: TBitBtn;
    Img3: TImage;
    BitBtnResetstatus: TBitBtn;
    procedure BitBtnCalculateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnHelp1Click(Sender: TObject);
    procedure BitBtnResetClick(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnHelp2Click(Sender: TObject);
    procedure BitBtnStatusClick(Sender: TObject);
    procedure BitBtnreset2Click(Sender: TObject);
    procedure BitBtnConfirmClick(Sender: TObject);
    procedure BitBtnAboutUsClick(Sender: TObject);
    procedure BitbtnHelpAboutUsClick(Sender: TObject);
    procedure cmbbxfaqClick(Sender: TObject);
    procedure PgctrCONSUMERChange(Sender: TObject);
    procedure BitBtnSeOrdClick(Sender: TObject);
    procedure BitBtnClose2Click(Sender: TObject);
    procedure BitBtnCloseAboutUsClick(Sender: TObject);
    procedure BitBtnInfoClick(Sender: TObject);
    procedure BitBtnResetstatusClick(Sender: TObject);
    procedure edtFlightIDChange(Sender: TObject);
    procedure sedtCargoIDChange(Sender: TObject);
    procedure SedtweightChange(Sender: TObject);





  private
    { Private declarations }

    btnNextPage: TBitBtn;              //  ==== Make a Button during runtime ====
  procedure CreateRuntimeButton;
  procedure GoToNextPage(Sender: TObject);


  public
    { Public declarations }
  end;




var
  FrmConsumer: TFrmConsumer;


  sfragile, scargo, sDeparture, sArrival, sShipper, sReceiver,sTrip, scost : String;
 iCargo, iDistance, iWeight, i : Integer;
  rCost,rTax,Rtotalcost : Real;
  bValidate,bfragile : Boolean;



implementation


{$R *.dfm}

  procedure TFrmConsumer.CreateRuntimeButton;
begin
  // Make sure to create once
  if Assigned(btnNextPage) then Exit;

  btnNextPage := TBitBtn.Create(Self);
  btnNextPage.Parent := tbshtorder;
  btnNextPage.Kind := bkall;
  btnNextPage.Caption := 'See order status!';
  btnNextPage.Left := 430;
  btnNextPage.Top := 300;
  btnNextPage.Width := 130;
  btnNextPage.Height := 35;

  btnNextPage.OnClick := GoToNextPage;
end;




procedure TFrmConsumer.edtFlightIDChange(Sender: TObject);
begin
if length(edtflightid.text) < 3 then begin edtflightid.Text := 'FL' ;

               edtflightid.SelStart := 2;
               edtflightid.SelLength := 0;

           //https://docwiki.embarcadero.com/Libraries/Athens/en/Vcl.StdCtrls.TCustomEdit.SelStart
           //https://docwiki.embarcadero.com/Libraries/Sydney/en/FMX.Edit.TCustomEdit.SelLength
end;
end;

procedure TFrmConsumer.GoToNextPage(Sender: TObject);
begin
 pgctrConsumer.SelectNextPage(true);           //NEXT PAGE   AND HIDE
 btnnextpage.Hide;
end;












 procedure LoadFlights;
begin                                        //PROCEDURE CONTAINING INFORMATION

 arrFlights[0] := TFlight.Create('Cape Town', 'Dubai', 'FL1', 8000);
arrFlights[1] := TFlight.Create('Cape Town', 'Hong Kong', 'FL2', 13000);
arrFlights[2] := TFlight.Create('Cape Town', 'London', 'FL3', 10000);
arrFlights[3] := TFlight.Create('Cape Town', 'New York', 'FL4', 13000);
arrFlights[4] := TFlight.Create('Dubai', 'Cape Town', 'FL5', 8000);
arrFlights[5] := TFlight.Create('Dubai', 'Hong Kong', 'FL6', 6500);
arrFlights[6] := TFlight.Create('Dubai', 'London', 'FL7', 6000);
arrFlights[7] := TFlight.Create('Dubai', 'New York', 'FL8', 11500);
arrFlights[8] := TFlight.Create('Hong Kong', 'Cape Town', 'FL9', 13000);
arrFlights[9] := TFlight.Create('Hong Kong', 'Dubai', 'FL10', 6500);
arrFlights[10] := TFlight.Create('Hong Kong', 'London', 'FL11', 10000);
arrFlights[11] := TFlight.Create('Hong Kong', 'New York', 'FL12', 13500);
arrFlights[12] := TFlight.Create('London', 'Cape Town', 'FL13', 10000);
arrFlights[13] := TFlight.Create('London', 'Dubai', 'FL14', 6000);
arrFlights[14] := TFlight.Create('London', 'Hong Kong', 'FL15', 10000);
arrFlights[15] := TFlight.Create('London', 'New York', 'FL16', 6000);
arrFlights[16] := TFlight.Create('New York', 'Cape Town', 'FL17', 13000);
arrFlights[17] := TFlight.Create('New York', 'Dubai', 'FL18', 11500);
arrFlights[18] := TFlight.Create('New York', 'Hong Kong', 'FL19', 13500);
arrFlights[19] := TFlight.Create('New York', 'London', 'FL20', 6000);

  end;






 constructor TFlight.Create(Departure, Arrival, Flight: string; Distance: Integer);
begin
  sDeparture := Departure;
  sArrival := Arrival;
  sFlight := Flight;                      //CONSTRUCTOR FOR FLIGHT INFORMATIOM
  iDistance := Distance;
end  ;








 function FindFlight(const sFlightID: string): Boolean;
var
  i: Integer;
begin
  Result := False;                                         //FUNCTION TO LOCATE FLIGHT
  for i := 0 to MAX_FLIGHTS - 1 do
  begin
    if arrFlights[i].sFlight = sFlightID  then
                 Result := true ;

  end;
end;






procedure TFrmConsumer.BitBtnSeOrdClick(Sender: TObject);
begin
pgctrConsumer.SelectNextPage(true);           //NEXT PAGE

end;



procedure TFrmConsumer.BitBtnClose2Click(Sender: TObject);
begin
close ;                             //CLOSE FORM
end;



procedure TFrmConsumer.BitBtnInfoClick(Sender: TObject);
begin
pgctrConsumer.SelectNextPage(true);                //NEXT PAGE
end;





procedure TFrmConsumer.BitBtnAboutUsClick(Sender: TObject);

VAR
Filelinesabout : tStringlist;
myfile:textfile;
iLineabout : byte;

begin
  // Clear the RichEdit content before loading new lines
  redtaboutus.Lines.Clear;

  // Create TStringList to hold file lines
  filelinesabout := TStringList.Create;
      //CODE FROM https://docwiki.embarcadero.com/Libraries/Athens/en/System.Classes.TStringList
      //          https://www.scribd.com/document/74487118/Delphi-Basics-TStringList-Command


    // Load the entire file content into the TStringList
    filelinesabout.LoadFromFile('About_Us.txt');

    // Add lines 26 to 40 (0-based index, so lines 27 to 41 in file)
    for iLineabout := 26 to 40 do
    begin
      // Check to avoid range errors if file has fewer lines
      if iLineabout < filelinesabout.Count then
        redtaboutus.Lines.Add(filelinesabout[iLineabout]);
    end;

    // Show the RichEdit control and adjust appearance
    redtaboutus.Show;
    redtaboutus.Height := 200;
    redtaboutus.Font.Size := 12;

end;








procedure TFrmConsumer.BitbtnHelpAboutUsClick(Sender: TObject);
begin
showmessage('On this page, you can see answers to commonly asked questions, ' +
' as well as a brief history of our Service.');                 //HELP MESSAGE
end;









procedure TFrmConsumer.BitBtnCalculateClick(Sender: TObject);

begin

 bValidate := True;  // Start with the assumption that all inputs are valid

// ===== Cargo Type Validation =====
if cmbbxcargo.ItemIndex = -1 then
begin
  bValidate := False;
  ShowMessage('Please choose a Cargo Type.');
end
else
begin
  // Assign cargo type based on selected index
  case cmbbxcargo.ItemIndex of
    0: begin icargo := 1; scargo := 'Art'; end;
    1: begin icargo := 2; scargo := 'Dangerous Goods'; end;
    2: begin icargo := 3; scargo := 'Electronics'; end;
    3: begin icargo := 4; scargo := 'Machinery'; end;
    4: begin icargo := 5; scargo := 'Pharmaceuticals'; end;
  end;
end;

// ===== Cargo Weight Validation =====
iWeight := sedtweight.Value;
if iWeight <= 0 then
begin
  bValidate := False;
  ShowMessage('Please type in the weight for the cargo.');
end;

// ===== Departure City Validation =====
if cmbbxdeparture.ItemIndex = -1 then
begin
  bValidate := False;
  ShowMessage('Please select a Departure City.');
end
else
begin
  // Assign departure city
  case cmbbxdeparture.ItemIndex of
    0: sDeparture := 'Cape Town';
    1: sDeparture := 'Dubai';
    2: sDeparture := 'Hong Kong';
    3: sDeparture := 'London';
    4: sDeparture := 'New York';
  end;
end;

// ===== Arrival City Validation =====
if cmbbxarrival.ItemIndex = -1 then
begin
  bValidate := False;
  ShowMessage('Please select an Arrival City.');
end
else
begin
  // Assign arrival city
  case cmbbxarrival.ItemIndex of
    0: sArrival := 'Cape Town';
    1: sArrival := 'Dubai';
    2: sArrival := 'Hong Kong';
    3: sArrival := 'London';
    4: sArrival := 'New York';
  end;
end;

// ===== Departure and Arrival City Cannot Be the Same =====
if (sDeparture <> '') and (sDeparture = sArrival) then
begin
  bValidate := False;
  ShowMessage('Arrival and Departure City cannot be the same.');
end;



if bValidate = True then
begin
  // ===== Find Matching Flight =====
  for i := 0 to MAX_FLIGHTS - 1 do
  begin
    if (arrFlights[i].sDeparture = sDeparture) and (arrFlights[i].sArrival = sArrival) then
    begin
      iDistance := arrFlights[i].iDistance;
      sTrip := arrFlights[i].sFlight;
      Break;  // Exit loop once match is found
    end;
  end;

  // ===== Confirm that the flight exists =====
  if not FindFlight(sTrip) then
    bValidate := False;
end;

// ===== Read Shipper and Receiver Details =====
sShipper := trim(edtShipper.Text);
sReceiver := trim(edtReceiver.Text);

// ===== Validate Shipper =====
if sShipper = '' then
begin
  bValidate := False;
  ShowMessage('Please enter the name of the Shipper.');
end;

// ===== Validate Receiver =====
if sReceiver = '' then
begin
  bValidate := False;
  ShowMessage('Please enter the name of the Receiver.');
end;

// ===== Fragile Checkbox Handling =====
if chkbxFragile.Checked then
begin
  bFragile := True;
  sFragile := 'True';
end
else
begin
  bFragile := False;
  sFragile := 'False';
end;

// ===== Cost Calculation =====
rCost := iDistance * 0.1 + iWeight * 10;

// Increase cost by 20% if fragile
if sFragile = 'True' then
  rCost := rCost * 1.2;

// Increase cost based on cargo type
case iCargo of
  1: rCost := rCost * 1.05;  // Art
  2: rCost := rCost * 1.10;  // Dangerous Goods
  3: rCost := rCost * 1.15;  // Electronics
  4: rCost := rCost * 1.20;  // Machinery
  5: rCost := rCost * 1.25;  // Pharmaceuticals
end;

// ===== Tax and Total Calculation =====
rTax := rCost * 0.15;
rTotalCost := rCost + rTax;

// ===== Display Final Order =====
redtOrder.Lines.Clear;

if bValidate = True then
begin
  // Header row
  redtOrder.Lines.Add(
    'Cargo Type' + #9 +
    'Weight' + #9 +
    'Departure' + #9 +
    'Arrival' + #9 +
    'Shipper' + #9 +
    'Receiver' + #9 +
    'Fragile' + #9 +
    'Cost' + #9 +
    'FlightID'
  );

  // Order details row
  redtOrder.Lines.Add(
    sCargo + #9 +
    IntToStr(iWeight) + 'kg' + #9 +
    sDeparture + #9 +
    sArrival + #9 +
    sShipper + #9 +
    sReceiver + #9 +
    sFragile + #9 +
    FloatToStrF(rTotalCost, ffCurrency, 10, 2) + #9 +
    sTrip
  );

  // Notify user
  ShowMessage('If your order is correct, confirm it to book your shipment!');

  // Show relevant UI elements
  redtOrder.Show;
  bitbtnReset.Show;
  bitbtnConfirm.Show;
end;

end;






procedure TFrmConsumer.BitBtnConfirmClick(Sender: TObject);

                   VAR
    inum, ifilterid : integer;
    snum,sdate, sweight,scost,sfragile, scargoid, sfilterid, sconfirm: string;
    FileOrder: TextFile;

begin
            // Hide the calculate button once it's clicked
bitbtnCalculate.Hide;

 if MessageDlg('Confirm Order?', mtInformation, [mbCancel, mbOK],  0) <> mrOk  then  begin
                              showmessage('Order has not been placed.');
                              bitbtncalculate.Show;
 end
             else



if bValidate = True then
begin
  // ===== Get the next cargo number =====
  with dmShipment do
  begin
    iNum := tblCargo.RecordCount;
  end;

  Inc(iNum);
  sNum := IntToStr(iNum);

  // ===== Proceed if validation is still true =====
  if bValidate = True then
  begin
    // Hide the order preview box
    redtOrder.Hide;

                      CreateRuntimeButton;    //Procedure




    // ===== Prepare to filter cargo table by next Cargo_ID =====
    with dmShipment do
    begin
      iFilterID := tblCargo.FieldByName('Cargo_ID').AsInteger + 1;
      sFilterID := IntToStr(iFilterID);
      tblCargo.Filter := 'Cargo_ID = ''' + sFilterID + '''';
      tblCargo.Filtered := True;
    end;

    // Show data grid with filtered record
    dbgd1.Show;

    // ===== Insert new cargo record into database =====
    with dmShipment do
    begin
      tblCargo.Last;
      tblCargo.Insert;
      tblCargo['CargoType']     := sCargo;
      tblCargo['Weight (kg)']   := iWeight;
      tblCargo['Cost']          := floattostrf(rTotalCost,ffcurrency,10,2);
      tblCargo['Fragile']       := bFragile;
      tblCargo['Shipper']       := sShipper;
      tblCargo['Receiver']      := sReceiver;
      tblCargo['Flight_ID']     := sTrip;
      tblCargo.Post;
    end;

    // ===== Prepare values for file writing =====
    sDate    := DateToStr(Date);
    sWeight  := IntToStr(iWeight);
    sCost    := FloatToStrF(rTotalCost, ffCurrency, 10, 2);
    sFragile := BoolToStr(bFragile, True); // 'True' or 'False'

    // ===== Get the Cargo_ID of the last inserted record =====
    with dmShipment do
    begin
      tblCargo.Filtered := False;
      tblCargo.Last;
      sCargoID := tblCargo['Cargo_ID'];
    end;

    // ===== Save order to external text file =====
    AssignFile(FileOrder, 'Orders.txt');
    Append(FileOrder);
    Writeln(FileOrder,
      sDate + ',' + sCargoID + ',' + sCargo + ',' + sWeight + ',' +
      sCost + ',' + sFragile + ',' + sShipper + ',' + sReceiver + ',' + sTrip);
    CloseFile(FileOrder);

    // ===== Confirmation message =====
    sConfirm := 'Please remember the following details about your order, ' +
                'as it contains important information regarding the package.'#13#10 +
                'Cargo ID: ' + sCargoID + #13#10 +
                'Flight ID: ' + sTrip;
    ShowMessage(sConfirm);

    // ===== Show post-confirmation buttons =====
    bitbtnConfirm.Hide;

    bitbtnReset.Show;
  end;
end;



         end;







procedure TFrmConsumer.BitBtnCloseAboutUsClick(Sender: TObject);
begin
close;
end;



procedure TFrmConsumer.BitBtnCloseClick(Sender: TObject);
begin
Close                       //CLOSE FORM
end;




procedure TFrmConsumer.BitBtnHelp1Click(Sender: TObject);
begin
showmessage('Welcome to the order page! '   +
 'Here, you''ll provide all the details about your shipment. ' +
 'Once you''ve entered the required information, '                             +
'the system will display your order''s details.'  );
                                  //HELP MESSAGE FOR ORDER
end;




procedure TFrmConsumer.BitBtnHelp2Click(Sender: TObject);
begin
showmessage('Wondering Where your package is? ' +
'Simply enter the Flight ID and Cargo ID to get your order status!');
                                      //HELP MESSAGE FOR STATUS
end;






procedure TFrmConsumer.BitBtnreset2Click(Sender: TObject);
begin
 redtaboutus.ReadOnly := true;
 redtstatus.ReadOnly := true;

dbgd1.Visible := false;                 //RESET STATUS


     sedtcargoid.Value :=1;
     edtflightid.text := 'FL' ;

redtstatus.Hide;
redtstatus.Lines.Clear;
end;

procedure TFrmConsumer.BitBtnResetClick(Sender: TObject);
begin
// ===== Reset ComboBoxes =====
cmbbxCargo.ItemIndex := -1;         // Reset cargo type selection
cmbbxDeparture.ItemIndex := -1;     // Reset departure city selection
cmbbxArrival.ItemIndex := -1;       // Reset arrival city selection

// ===== Reset Numeric Input =====
sedtWeight.Value := 0;              // Reset cargo weight input

// ===== Reset Text Inputs =====
edtShipper.Text := '';              // Clear shipper name
edtReceiver.Text := '';             // Clear receiver name

// ===== Reset Fragile Checkbox =====
chkbxFragile.Checked := False;

// ===== Hide UI Elements =====
bitbtnReset.Hide;                   // Hide the reset button
bitbtnConfirm.Hide;                 // Hide the confirm button
btnnextpage.Hide;                   //Hide the created button
redtOrder.Clear;                    // Clear the RichEdit order summary
redtOrder.Hide;                     // Hide the RichEdit control
dbgd1.Hide;                         // Hide the data grid

// ===== Clear Cargo Details =====
sCargo := '';
iCargo := 0;
iWeight := 0;
iDistance := 0;

// ===== Clear City Selections =====
sDeparture := '';
sArrival := '';

// ===== Clear Shipper/Receiver Info =====
sShipper := '';
sReceiver := '';

// ===== Reset Fragile State =====
sFragile := 'False';

// ===== Reset Validation Flag =====
bValidate := True;

// ===== Reset Cost Calculation Values =====
rCost := 0;
rTax := 0;
rTotalCost := 0;

// ===== Clear Flight ID =====
sTrip := '';

// ==== Fix Buttons ====
bitbtncalculate.Show;



end;









procedure TFrmConsumer.BitBtnResetstatusClick(Sender: TObject);  //Reset Stauts Page
begin

sedtcargoid.Value := 1;
edtflightid.Text := 'FL';

redtstatus.Hide;
Dbgd1.Hide;
end;




procedure TFrmConsumer.BitBtnStatusClick(Sender: TObject);
var
  sUserCargo, sUserFlight, sUsFlight, sCargoType, sFlight, sName, sStatus, sDestination, splural, sHave: string;
  iCargoMax, iUserCargo, iFlight, iDistance, k: Integer;
  bCargoVal, bFlightVal: Boolean;
begin
  // ===== Hide and Clear UI Elements =====
  dbgd1.Hide;
  redtStatus.Hide;
  redtStatus.Lines.Clear;

  // ===== Initialize Validation Flags =====
  bCargoVal := True;
  bFlightVal := True;



  // ===== Get User Input =====

  if bcargoval then

  iUserCargo := sedtCargoID.value;
  sUserFlight := trim(edtFlightID.Text);

  // ===== Get Max Cargo ID from Table =====
  with dmShipment do
  begin
    tblCargo.Filtered := False;
    tblCargo.Last;
    iCargoMax := tblCargo['Cargo_ID'];
  end;

  // ===== Validate Cargo ID =====


  if (iUserCargo > iCargoMax) OR (iusercargo = 0)then
    bCargoVal := False;





  // ===== Validate Flight ID Format =====
  if Length(sUserFlight) <= 2 then
    bFlightVal := False;

  if (Pos('FL', sUserFlight) <> 1) or (sUserFlight = 'FL') then
    bFlightVal := False;

    if bflightval then

    iFlight := strtoint(Copy(sUserFlight, 3, 2));
   susflight := Copy(sUserFlight, 3, 2);        // Get digits after 'FL'

      if (iFlight = 0) or (iFlight > 20) then
        bFlightVal := False;

  // Check if numeric
    if UpperCase(sUsFlight) <> LowerCase(sUsFlight) then
      bFlightVal := False ;


                               //TWO TABLES CONNECTED

    //    I used Flight_ID as a reference to connect data between tblCargo and tblFlights.
    //    I first filter the tblCargo with the user's Cargo_ID,
    //    and then use that Flight_ID to get additional data from tblFlights
    //    such as distance and destination.


  // ===== Lookup Matching Records if Both IDs Valid =====
  if bCargoVal and bFlightVal then
  begin
    with dmShipment do
    begin
      // ===== Filter Cargo Table by Cargo_ID =====
      tblCargo.Filter := 'Cargo_ID = ' + QuotedStr(IntToStr(iUserCargo));
      tblCargo.Filtered := True;

      sName      := tblCargo['Shipper'];
      sCargoType := tblCargo['CargoType'];
      sFlight    := tblCargo['Flight_ID'];

      if suserflight <> sflight then  bflightval := false else begin


      // ===== Filter Flights Table by Flight_ID from tblCargo =====
      tblFlights.Filter := 'Flight_ID = ' + QuotedStr(sFlight);
      tblFlights.Filtered := True;

      // ===== Retrieve Additional Info =====
      sStatus      := tblFlights['Status'];
      sDestination := tblFlights['Arrival'];
      iDistance    := tblFlights['Distance (km)'];

      // ===== Display Shipment Status =====
      redtStatus.Show;
      dbgd1.Show;
      bitbtnInfo.Show;
      end;

     // ===== Build Message Based on Status =====
if (scargotype = 'Dangerous Goods') OR (scargotype = 'Electronics') OR (scargotype = 'Pharmaceuticals')
 then    begin
  splural := ' are ' ;
   shave := ' have '  ;
 end
else      begin
  splural := ' is ';
  shave := ' has ';
end;


if sStatus = 'Booked' then
  redtStatus.Lines.Add(sName + ', your ' + LowerCase(sCargoType) + splural +
    'booked and will be flown ' + IntToStr(iDistance) + ' km to ' + sDestination + '.')

else if sStatus = 'In transit' then
  redtStatus.Lines.Add(sName + ', your ' + LowerCase(sCargoType) + splural +
    'currently in transit to ' + sDestination + '. (' + IntToStr(iDistance) + ' km)')

else if sStatus = 'Delivered' then
  redtStatus.Lines.Add(sName + ', your ' + LowerCase(sCargoType) +
    shave + 'been delivered to ' + sDestination + ' (' + IntToStr(iDistance) + ' km).');



    end;
  end ;

  begin
    // ===== Show Error Messages =====
    if not bCargoVal and not bFlightVal then
      ShowMessage('Please type in the correct order information.')
    else
    begin
      if not bCargoVal then
        ShowMessage('Please type in the correct Cargo ID.');
      if not bFlightVal then
        ShowMessage('Please type in the correct Flight ID.');
    end;
  end;
end;







procedure TFrmConsumer.cmbbxfaqClick(Sender: TObject);

   var
 MyFile:textfile;
 sLine: string;
 iLine : integer;
 FileLines : Tstringlist;
 bvalfaq : boolean;

begin
// ===== Clear any previous content from the RichEdit =====
redtAboutUs.Lines.Clear;

// Create a string list to hold file lines
fileLines := TStringList.Create;

// ===== Open and load the About Us text file =====
AssignFile(myFile, 'About_Us.txt');
Reset(myFile);
fileLines.LoadFromFile('About_Us.txt');

// ===== Validate dropdown selection =====
if (cmbbxFAQ.ItemIndex < 0) or (cmbbxFAQ.ItemIndex > 4) then
begin
  ShowMessage('Please choose a correct Question.');
end
else
begin
  // ===== Add specific lines based on the selected question =====
  case cmbbxFAQ.ItemIndex of
    0: for iLine := 0 to 2 do
         if iLine < fileLines.Count then
           redtAboutUs.Lines.Add(fileLines[iLine]);

    1: for iLine := 3 to 5 do
         if iLine < fileLines.Count then
           redtAboutUs.Lines.Add(fileLines[iLine]);

    2: for iLine := 6 to 8 do
         if iLine < fileLines.Count then
           redtAboutUs.Lines.Add(fileLines[iLine]);

    3: for iLine := 9 to 11 do
         if iLine < fileLines.Count then
           redtAboutUs.Lines.Add(fileLines[iLine]);

    4: for iLine := 12 to 14 do
         if iLine < fileLines.Count then
           redtAboutUs.Lines.Add(fileLines[iLine]);
  end;

  // ===== Show and format the RichEdit output =====
  redtAboutUs.Show;
  redtAboutUs.Height := 130;
  redtAboutUs.Font.Size := 15;

  // Reset the combo box for future use
  cmbbxFAQ.ItemIndex := -1;
end;

// ===== Close the file and free memory manually =====
CloseFile(myFile);
fileLines.Free;

//CODE FROM https://docwiki.embarcadero.com/Libraries/Alexandria/en/System.Classes.TStringList.Create


end;




procedure TFrmConsumer.FormCreate(Sender: TObject);

begin
// ===== Load flights and reset page control =====
LoadFlights;
PgctrConsumer.ActivePageIndex := 0;

// ===== Configure RichEdit tabs for order display =====
redtOrder.Paragraph.TabCount := 9;
redtOrder.Paragraph.Tab[0] := 75;   // CARGO
redtOrder.Paragraph.Tab[1] := 115;  // WEIGHT
redtOrder.Paragraph.Tab[2] := 175;  // DEPARTURE
redtOrder.Paragraph.Tab[3] := 220;  // ARRIVAL
redtOrder.Paragraph.Tab[4] := 310;  // SHIPPER
redtOrder.Paragraph.Tab[5] := 385;  // RECEIVER
redtOrder.Paragraph.Tab[6] := 430;  // FRAGILE
redtOrder.Paragraph.Tab[7] := 500;  // COST
redtOrder.Paragraph.Tab[8] := 580;  // FLIGHTID

// ===== Hide controls and set default values =====
redtStatus.Hide;
sedtCargoID.Value := 1;

bitbtnInfo.Hide;
bitbtnConfirm.Hide;
bitbtnReset.Hide;
dbgd1.Hide;
redtOrder.Hide;
redtAboutUs.Hide;



// ===== Initialize data module if not already assigned =====
if not Assigned(DmShipment) then
  DmShipment := TdmShipment.Create(Application);

// ===== Setup data source and activate datasets =====
dbgd1.DataSource := DmShipment.DataSourceCargo;
DmShipment.tblCargo.Active := True;
DmShipment.tblFlights.Active := True;
DmShipment.AdoConPat.Connected := True;

// ===== Configure DBGrid =====
dbgd1.ReadOnly := True;
dbgd1.Columns.Clear;

// ===== Add columns with appropriate field names and widths =====
with dbgd1.Columns.Add do
begin
  FieldName := 'Cargo_ID';
  Width := 50;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'CargoType';
  Width := 100;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Weight (kg)';
  Width := 80;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Cost';
  Width := 80;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Fragile';
  Width := 50;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Shipper';
  Width := 150;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Receiver';
  Width := 150;
end;

with dbgd1.Columns.Add do
begin
  FieldName := 'Flight_ID';
  Width := 50;


  end;
end;





procedure TFrmConsumer.PgctrCONSUMERChange(Sender: TObject);
begin
       if pgctrConsumer.ActivePage = tbshtorder then
         dbgd1.Visible := false;

if pgctrConsumer.ActivePage = tbshtverify then             //HIDE DBGRID
         dbgd1.Visible := false;

         if pgctrConsumer.ActivePage = tbshtabout then
         dbgd1.Visible := false;
end;

procedure TFrmConsumer.sedtCargoIDChange(Sender: TObject);
begin
if Trim(sedtCargoID.Text) = '' then begin
  sedtcargoid.Value :=0;
  sedtcargoid.SelStart := 1;
         sedtcargoid.SelLength :=0;
end

end;

procedure TFrmConsumer.SedtweightChange(Sender: TObject);
begin
if trim(sedtweight.Text) = '' then   begin
         sedtweight.Text := '0' ;
         sedtweight.SelStart := 1;
         sedtweight.SelLength :=0;
end;


end;

end.
