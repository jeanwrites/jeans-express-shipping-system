unit Admin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmshipment_u, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DBCtrls,
  ComCtrls, db, adodb, pngimage ;

type
  TFrmAdmin = class(TForm)
    pnladmin: TPanel;
    BitBtnhelp: TBitBtn;
    LblAdmin: TLabel;
    DBGrdCargo: TDBGrid;
    BitBtnSort: TBitBtn;
    BitBtnDelete: TBitBtn;
    BitBtnEdit: TBitBtn;
    BitBtnSelect: TBitBtn;
    BitBtnHigh: TBitBtn;
    BitBtnAvg: TBitBtn;
    DBGrdFlight: TDBGrid;
    BitBtnToday: TBitBtn;
    StrGrd: TStringGrid;
    EdtPassword: TEdit;
    LblPassword: TLabel;
    BitBtnclose: TBitBtn;
    BitBtnreset: TBitBtn;
    Chkart: TCheckBox;
    chkDangerous: TCheckBox;
    chkElectronics: TCheckBox;
    chkMachinery: TCheckBox;
    chkPharma: TCheckBox;
    BitBtnFilterCargo: TBitBtn;
    Img1: TImage;
    BitBtnFragile: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnSortClick(Sender: TObject);
    procedure BitBtnHighClick(Sender: TObject);
    procedure BitBtnAvgClick(Sender: TObject);
    procedure BitBtnSelectClick(Sender: TObject);
    procedure BitBtnDeleteClick(Sender: TObject);
    procedure BitBtnEditClick(Sender: TObject);
    procedure BitBtnTodayClick(Sender: TObject);
    procedure EdtPasswordChange(Sender: TObject);
    procedure BitBtnhelpClick(Sender: TObject);
    procedure BitBtnresetClick(Sender: TObject);
    procedure BitBtnFilterCargoClick(Sender: TObject);
    procedure BitBtnShowPassClick(Sender: TObject);
    procedure BitBtnFragileClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAdmin: TFrmAdmin;
  ravg,rsum,  rsum2,  rcost,rhighestcost : real;
  scost, stblcount, spassword : string;
  itblcount,k : integer;

implementation

{$R *.dfm}

procedure TFrmAdmin.BitBtnresetClick(Sender: TObject);
begin
dmshipment.TblCargo.Filtered := false;   //Remove filter
dmshipment.Tblflights.Filtered := false;




  ShowMessage('Database changes reset successfully.');


DBGrdCargo.Columns[0].Width := 50;  // Set first column width to 50 pixels
DBGrdCargo.Columns[1].Width := 100;
DBGrdCargo.Columns[2].Width := 70;
DBGrdCargo.Columns[3].Width := 80;
DBGrdCargo.Columns[4].Width := 50;
DBGrdCargo.Columns[5].Width := 100;
DBGrdCargo.Columns[6].Width := 100;
DBGrdCargo.Columns[7].Width := 50;

  chkArt.Checked := False;
chkDangerous.Checked := False;
chkElectronics.Checked := False;         //Uncheck CheckBoxes
chkMachinery.Checked := False;
chkPharma.Checked := False;

end;



procedure TFrmAdmin.BitBtnhelpClick(Sender: TObject);  //Message
begin
showmessage('Hello Admin! Please enter the password to begin editing records from the database.');
end;





procedure TFrmAdmin.BitBtnSortClick(Sender: TObject);
begin

dmshipment.Tblcargo.First;

with dmshipment do
begin
  tblcargo.Filtered := False;
  tblcargo.Sort := 'Shipper ASC';          //Sort Alphabetically


if DBGrdCargo.Columns[0].FieldName = 'Shipper' then
  DBGrdCargo.Columns[0].Index := 0
else  // Put Shipper column first if it's not already
  DBGrdCargo.Columns[5].Index := 0;


  ShowMessage
  ('Records have been sorted alphabetically to easily identify duplicates or irregular entries.');
end;







end;

procedure TFrmAdmin.BitBtnDeleteClick(Sender: TObject);
var
  sUserCargo, sShipper, sCost, sFlight, sCargo, sArrival, sWord: string;
  bCanDelete, bWasDeleted: Boolean;
  iCargoDelete, iCargoMax, i, k: Integer;
begin
  // ===== Initialize =====
  bCanDelete := False;
  bWasDeleted := False;
  dmShipment.tblCargo.Filtered := False;
  dmShipment.tblCargo.Last;
  iCargoMax := dmShipment.tblCargo['Cargo_ID'];

  // ===== Setup grid column order  =====
  for k := 0 to DBGrdCargo.Columns.Count - 1 do
  begin
    if DBGrdCargo.Columns[k].FieldName = 'CargoID' then
      DBGrdCargo.Columns[k].Index := 0
    else if DBGrdCargo.Columns[k].FieldName = 'Shipper' then
      DBGrdCargo.Columns[k].Index := 5;
  end;

  // ===== Ask for Cargo ID to delete =====
  sUserCargo := Trim(InputBox('Delete which Cargo_ID?', '1 to ' + IntToStr(iCargoMax), ''));

  // ===== Validate input =====
  for i := 1 to iCargoMax do
    if IntToStr(i) = sUserCargo then
      bCanDelete := True;

  if not bCanDelete then
  begin
    ShowMessage('Please type in a correct Cargo ID.');
    Exit;
  end else

  iCargoDelete := StrToInt(sUserCargo);

  // ===== Check if record still exists =====
  if not dmShipment.tblCargo.Locate('Cargo_ID', sUserCargo, []) then
  begin
    ShowMessage('Cargo ID ' + sUserCargo + ' is already deleted.');
    Exit;
  end;

  // ===== Load related data for confirmation =====
  with dmShipment do
  begin
    tblCargo.Filter := 'Cargo_ID = ' + QuotedStr(sUserCargo);
    tblCargo.Filtered := True;

    sShipper := tblCargo['Shipper'];
    sCost := tblCargo['Cost'];
    sCargo := tblCargo['CargoType'];
    sFlight := tblCargo['Flight_ID'];

    tblFlights.Filtered := False;
    tblFlights.Filter := 'Flight_ID = ' + QuotedStr(sFlight);
    tblFlights.Filtered := True;

    sArrival := tblFlights['Arrival'];

    if (sCargo = 'Art') or (sCargo = 'Machinery') then
      sWord := ' is '
    else
      sWord := ' are ';

    // ===== Confirm Deletion =====
    if MessageDlg('Do you want to delete the record where ' + sShipper + '''s ' +
      sCargo + sWord + 'flown to ' + sArrival + '?',
      mtWarning, [mbOK, mbCancel], 0) = mrOk then
    begin
      ShowMessage('Order: ' + sUserCargo + ' has been cancelled.');

      // ===== Find and Delete Record =====
      tblCargo.First;
      while not tblCargo.Eof do
      begin
        if tblCargo['Cargo_ID'] = sUserCargo then
        begin
          tblCargo.Delete;
          bWasDeleted := True;
          Break;
        end
        else
          tblCargo.Next;
      end;
    end;
  end;

  // ===== Post-Deletion Feedback =====
  if not bWasDeleted then
    ShowMessage('No records deleted.');

  // ===== Re-Filter to Show Nearby Records =====
  with dmShipment.tblCargo do
  begin
    if bWasDeleted then
    begin
      if iCargoDelete > 5 then
      begin
        Filter := Format('Cargo_ID >= %d AND Cargo_ID <= %d', [iCargoDelete - 3, iCargoDelete + 3]);
        Filtered := True;
      end
      else
        Filtered := False;
    end
    else
      Filtered := False;
  end;
end;











procedure TFrmAdmin.BitBtnEditClick(Sender: TObject);
var
  sNewStatus, sFlight, sCurrent, sNormalizedStatus: string;
  b: Byte;
  bValFl, bValSt: Boolean;
  k: Integer;
begin
  // Initialize validation flags
  bValFl := False;
  bValSt := False;
   dmshipment.TblCargo.Filtered := false;

  // Prompt user for flight number
  sFlight := trim(InputBox('Which flight''s status?', '1 to 20', ''));


  // Validate flight number is between 1 and 20
  for b := 1 to 20 do

    if IntToStr(b) = sFlight then   bValFl := True;

     sFlight := 'FL' + sFlight;

  if not bValFl then
  begin
    ShowMessage('Please enter a valid flight number (1 to 20).');
    Exit;
  end;

  // Prompt for new status
  sNewStatus := InputBox('What should the status be?', 'Booked, In Transit, Delivered', '');

  // Normalize input (trim and uppercase)
  sNormalizedStatus := Trim(sNewStatus);
  sNormalizedStatus := UpperCase(sNormalizedStatus);


     for b := Length(sNormalizedStatus) downto 1 do
  if sNormalizedStatus[b] = ' ' then
    Delete(sNormalizedStatus, b, 1);


  // Check valid status values
  if (sNormalizedStatus = 'BOOKED') or (sNormalizedStatus = 'IN TRANSIT')
   or (sNormalizedStatus = 'INTRANSIT')
  or (sNormalizedStatus = 'DELIVERED') then

    bValSt := True;

  if not bValSt then
  begin
    ShowMessage('Please enter a valid status: Booked, In Transit, or Delivered.');
    Exit;
  end;

  // Adjust sNewStatus for consistent capitalization for display and storage
  // Capitalize first letter of each word (simple for these cases):
  if sNormalizedStatus = 'BOOKED' then
    sNewStatus := 'Booked'
  else if (sNormalizedStatus = 'IN TRANSIT') or (sNormalizedStatus = 'INTRANSIT') then
    sNewStatus := 'In Transit'
  else if sNormalizedStatus = 'DELIVERED' then
    sNewStatus := 'Delivered';

  // Apply changes if both inputs are valid
  with dmShipment do
  begin
    TblFlights.Filtered := False;

    // Apply filter for desired flight ID (e.g., 'FL5')
    TblFlights.Filter :=    'Flight_ID = ' + QuotedStr(sFlight);
     //https://docwiki.embarcadero.com/Libraries/Sydney/en/System.SysUtils.Format
    TblFlights.Filtered := True;

    if TblFlights['Flight_ID'] = '' then
    begin
      ShowMessage('Flight with ID FL' + sFlight + ' not found.');
      TblFlights.Filtered := False;
      Exit;
    end;

    sCurrent := TblFlights['Status'];

    if UpperCase(sCurrent) = sNormalizedStatus then
    begin
      ShowMessage('Flight ' + sFlight + '''s status will remain "' + sCurrent + '".');
    end
    else
    begin
      TblFlights.Edit;
      TblFlights['Status'] := sNewStatus;
      TblFlights.Post;

      ShowMessage('Flight ' + sFlight + '''s status has been updated from "' +
                  sCurrent + '" to "' + sNewStatus + '".');
    end;


  end;
end;








procedure TFrmAdmin.BitBtnSelectClick(Sender: TObject);
var
  iUserCargo, iCargoMax, i: Integer;
  sUserCargo: string;
  bValCargo: Boolean;
begin
  // Reorder columns in DBGrdCargo
  for i := 0 to DBGrdCargo.Columns.Count - 1 do
  begin
    if DBGrdCargo.Columns[i].FieldName = 'CargoID' then
      DBGrdCargo.Columns[i].Index := 0
    else if DBGrdCargo.Columns[i].FieldName = 'Shipper' then
      DBGrdCargo.Columns[i].Index := 5;
  end;

  // Clear filters
  dmShipment.TblCargo.Filtered := False;

  // Get max Cargo_ID
  dmShipment.TblCargo.Last;
  iCargoMax := dmShipment.TblCargo['Cargo_ID'];

  // Ask user for input
  sUserCargo := Trim(InputBox('Input Cargo_ID', '1 to ' + IntToStr(iCargoMax), ''));
  bValCargo := False;

  // ===== Validate input using loop =====
  for i := 1 to iCargoMax do
    if IntToStr(i) = sUserCargo then
    begin
      bValCargo := True;
      Break;
    end;

  // Show message and exit if invalid
  if not bValCargo then
  begin
    ShowMessage('Please type in a valid Cargo ID.');
    Exit;
  end;

  // Apply filter
  dmShipment.TblCargo.Filter := 'Cargo_ID = ' + QuotedStr(sUserCargo);
  dmShipment.TblCargo.Filtered := True;

  // Show nearby records if not found
  if not dmShipment.TblCargo.Locate('Cargo_ID', sUserCargo, []) then
  begin
    if StrToInt(sUserCargo) > 5 then
    begin
      dmShipment.TblCargo.Filter := Format('Cargo_ID >= %d AND Cargo_ID <= %d',
        [StrToInt(sUserCargo) - 3, StrToInt(sUserCargo) + 3]);
      dmShipment.TblCargo.Filtered := True;
    end;
    ShowMessage('Cargo ID ' + sUserCargo + ' does not exist.');
  end;
end;






procedure TFrmAdmin.BitBtnShowPassClick(Sender: TObject);
begin
if edtpassword.text = '' then showmessage( 'Please type in a password.' );

end;

procedure TFrmAdmin.BitBtnHighClick(Sender: TObject);

begin


 // Reorder columns in DBGrdCargo
for K := 0 to DBGrdCargo.Columns.Count - 1 do
begin
  if DBGrdCargo.Columns[K].FieldName = 'CargoID' then
    DBGrdCargo.Columns[K].Index := 0
  else if DBGrdCargo.Columns[K].FieldName = 'Shipper' then
    DBGrdCargo.Columns[K].Index := 5;
end;


// Count total cargo records
iTblCount := dmShipment.TblCargo.RecordCount;
sTblCount := IntToStr(iTblCount);

// Prepare and sort cargo table
dmShipment.TblCargo.First;
dmShipment.TblCargo.Filtered := False;
dmShipment.TblCargo.Sort := 'Cargo_ID ASC';

// Find the highest cost
with dmShipment do
begin
  while not TblCargo.Eof do
  begin
    rCost := TblCargo['Cost'];
    rSum := rSum + rCost;
    if rCost > rHighestCost then
      rHighestCost := rCost;
    TblCargo.Next;
  end;
end;

// Filter the cargo table for the highest cost
with dmShipment do
begin
  sCost := FloatToStrF(rHighestCost, ffCurrency, 10, 2);

  TblCargo.Filtered := False;
  TblCargo.Filter := 'Cost = ' + QuotedStr(sCost);
  TblCargo.Filtered := True;
end;

// Show message
ShowMessage('The highest order was ' +
            FloatToStrF(rHighestCost, ffCurrency, 10, 2) +
            ', which means there''s an opportunity to analyze what drove that sale ' +
            'and replicate that strategy for future profits.');


end;









procedure TFrmAdmin.BitBtnFilterCargoClick(Sender: TObject);
var
  sFilter, sMessage: string;
  iCheckCount, iRecordCount, iTotalCount: Integer;
  sCargoWord, sShipmentWord, sVerbWord, sPercent: string;

  iCountArt, iCountDangerous, iCountElectronics, iCountMachinery, iCountPharma: Integer;
  rPercent: Real;
begin
  // Ensure dataset is active and unfiltered
  dmShipment.tblCargo.Filtered := False;
  if not dmShipment.tblCargo.Active then
    dmShipment.tblCargo.Open;

  iTotalCount := dmShipment.tblCargo.RecordCount;

  // Reset all counters
  iCountArt := 0;
  iCountDangerous := 0;
  iCountElectronics := 0;
  iCountMachinery := 0;
  iCountPharma := 0;

  // Count all records by type
  dmShipment.tblCargo.DisableControls;
  dmShipment.tblCargo.First;
  while not dmShipment.tblCargo.Eof do
  begin
    if dmShipment.tblCargo['CargoType'] = 'Art' then Inc(iCountArt);
    if dmShipment.tblCargo['CargoType'] = 'Dangerous Goods' then Inc(iCountDangerous);
    if dmShipment.tblCargo['CargoType'] = 'Electronics' then Inc(iCountElectronics);
    if dmShipment.tblCargo['CargoType'] = 'Machinery' then Inc(iCountMachinery);
    if dmShipment.tblCargo['CargoType'] = 'Pharmaceuticals' then Inc(iCountPharma);
    dmShipment.tblCargo.Next;
  end;
  dmShipment.tblCargo.EnableControls;

  // Build filter from checkboxes
  sFilter := '';
  iCheckCount := 0;

  if chkArt.Checked then
  begin
    sFilter := sFilter + '(CargoType = ''Art'') OR ';
    Inc(iCheckCount);
  end;
  if chkDangerous.Checked then
  begin
    sFilter := sFilter + '(CargoType = ''Dangerous Goods'') OR ';
    Inc(iCheckCount);
  end;
  if chkElectronics.Checked then
  begin
    sFilter := sFilter + '(CargoType = ''Electronics'') OR ';
    Inc(iCheckCount);
  end;
  if chkMachinery.Checked then
  begin
    sFilter := sFilter + '(CargoType = ''Machinery'') OR ';
    Inc(iCheckCount);
  end;
  if chkPharma.Checked then
  begin
    sFilter := sFilter + '(CargoType = ''Pharmaceuticals'') OR ';
    Inc(iCheckCount);
  end;

  if sFilter <> '' then
  begin
    Delete(sFilter, Length(sFilter) - 3, 4); // Remove trailing ' OR '
    dmShipment.tblCargo.Filter := sFilter;
    dmShipment.tblCargo.Filtered := True;
    iRecordCount := dmShipment.tblCargo.RecordCount;

    if iCheckCount = 1 then
      sCargoWord := 'cargo type'
    else
      sCargoWord := 'cargo types';

    if iRecordCount = 1 then
    begin
      sShipmentWord := 'shipment';
      sVerbWord := 'was';

    end
    else
    begin
      sShipmentWord := 'shipments';
      sVerbWord := 'were';

    end;

    sMessage := 'You selected ' + IntToStr(iCheckCount) + ' ' + sCargoWord + '. ' +
IntToStr(iRecordCount) + ' matching ' + sShipmentWord + ' ' + sVerbWord + ' found.' + #13 + #13;

    // Append percentages for selected types only
    if chkArt.Checked and (iCountArt > 0) then
    begin
      rPercent := (iCountArt * 100.0) / iTotalCount;
      sMessage := sMessage + 'Art: ' + FloatToStrF(rPercent, ffFixed, 10, 2) + '%' + #13;
    end;
    if chkDangerous.Checked and (iCountDangerous > 0) then
    begin
      rPercent := (iCountDangerous * 100.0) / iTotalCount;
      sMessage := sMessage + 'Dangerous Goods: ' + FloatToStrF(rPercent, ffFixed, 10, 2) + '%' + #13;
    end;
    if chkElectronics.Checked and (iCountElectronics > 0) then
    begin
      rPercent := (iCountElectronics * 100.0) / iTotalCount;
      sMessage := sMessage + 'Electronics: ' + FloatToStrF(rPercent, ffFixed, 10, 2) + '%' + #13;
    end;
    if chkMachinery.Checked and (iCountMachinery > 0) then
    begin
      rPercent := (iCountMachinery * 100.0) / iTotalCount;
      sMessage := sMessage + 'Machinery: ' + FloatToStrF(rPercent, ffFixed, 10, 2) + '%' + #13;
    end;
    if chkPharma.Checked and (iCountPharma > 0) then
    begin
      rPercent := (iCountPharma * 100.0) / iTotalCount;
      sMessage := sMessage + 'Pharmaceuticals: ' + FloatToStrF(rPercent, ffFixed, 10, 2) + '%' + #13;
    end;

    sMessage := sMessage + #13 + 'The information can be used to identify popular cargo types, '   +
    ' optimize resources and better plan logistics.' ;

    ShowMessage(Trim(sMessage));
  end
  else
    ShowMessage('Please select at least one Cargo Type.');
end;













procedure TFrmAdmin.BitBtnFragileClick(Sender: TObject);

VAR
Ifragile,itotal : integer;
smessage: string;
rpercent : real;
begin


  // Set DBGrid column indexes based on FieldName
for k := 0 to DBGrdCargo.Columns.Count - 1 do
begin
  if DBGrdCargo.Columns[k].FieldName = 'CargoID' then
    DBGrdCargo.Columns[k].Index := 0
  else if DBGrdCargo.Columns[k].FieldName = 'Shipper' then
    DBGrdCargo.Columns[k].Index := 5;
end;




 // Apply the filter
  dmShipment.tblCargo.Filtered := False;
  itotal := dmshipment.TblCargo.RecordCount;

  dmShipment.tblCargo.Filter := 'Fragile = ' + quotedstr('True');
  dmShipment.tblCargo.Filtered := True;
   ifragile := dmshipment.TblCargo.RecordCount;

   rpercent :=     ifragile/itotal*100   ;

   smessage := inttostr(ifragile) + ' out of ' + inttostr(itotal) + ' records were Fragile. '+ #13 ;
   smessage := smessage + 'Which is ' + floattostrf(rpercent,fffixed,10,2) + '% of all orders. ' + #13 + #13 ;

   if rpercent > 50 then
     smessage := smessage + 'Meaning the majority of costumers use this feature.' ELSE
  smessage := smessage + 'Meaning the majority of costumers does not use this feature.';

   showmessage(smessage);
end;









procedure TFrmAdmin.BitBtnAvgClick(Sender: TObject);
begin
 dmshipment.TblCargo.Filtered := false;

 // Reorder columns in DBGrdCargo
for K := 0 to DBGrdCargo.Columns.Count - 1 do
begin
  if DBGrdCargo.Columns[K].FieldName = 'CargoID' then
    DBGrdCargo.Columns[K].Index := 0
  else if DBGrdCargo.Columns[K].FieldName = 'Shipper' then
    DBGrdCargo.Columns[K].Index := 5;
end;

// Sort the cargo table
dmShipment.TblCargo.Sort := 'Cargo_ID ASC';

// Initialize variables
rSum := 0;
rCost := 0;
rAvg := 0;
rHighestCost := 0;

// Get cargo record count
iTblCount := dmShipment.TblCargo.RecordCount;
sTblCount := IntToStr(iTblCount);

// Process cargo records
with dmShipment do
begin
  TblCargo.Filtered := False;
  iTblCount := TblCargo.RecordCount;
  TblCargo.First;

  while not TblCargo.Eof do
  begin
    rCost := TblCargo['Cost'];
    rSum := rSum + rCost;
    TblCargo.Next;
  end;
end;

// Calculate average cost
rAvg := rSum / iTblCount;

// Show average result with interpretation
if rAvg >= 3000 then
  ShowMessage('The average cost for cargo is ' +
              FloatToStrF(rAvg, ffCurrency, 18, 2) +
              ', which means the company is making a profit.')
else
  ShowMessage('The average cost for cargo is ' +
              FloatToStrF(rAvg, ffCurrency, 18, 2) +
              ', which means the company is making a loss.');

    dmshipment.TblCargo.Filtered := false;
end;







   procedure TFrmAdmin.BitBtnTodayClick(Sender: TObject);

var
  FileOrder: TextFile;
  sDate, sID, sCargo, sWeight, sCost,
  sFragile, sShipper, sReceiver, sTrip, sLine, sDateFile: string;
  iPos, iLinesCount, i, iCol, iTotal: Integer;
  ArrOrders: array[1..200, 1..9] of string;
begin


// Reorder columns in DBGrdCargo
for K := 0 to DBGrdCargo.Columns.Count - 1 do
begin
  if DBGrdCargo.Columns[K].FieldName = 'CargoID' then
    DBGrdCargo.Columns[K].Index := 0
  else if DBGrdCargo.Columns[K].FieldName = 'Shipper' then
    DBGrdCargo.Columns[K].Index := 5;
end;



  sDate := DateToStr(Date);
  AssignFile(FileOrder, 'Orders.txt');    //OPEN FILE
  Reset(FileOrder);

  iLinesCount := 0;   //Initiate variables
  iCol := 0;
  iTotal := 0;

  while not Eof(FileOrder) do
  begin
    ReadLn(FileOrder, sLine);
    if Trim(sLine) <> '' then           //CHECK FOR EMPTY SPACE
    begin
      iPos := Pos(',', sLine);
      sDateFile := Copy(sLine, 1, iPos - 1);
      Delete(sLine, 1, iPos);

      if sDate = sDateFile then      //PLACED TODAY
      begin
        Inc(iTotal);
        Strgrd.Show;

        Inc(iCol); // move to next row in array

        // ID
        iPos := Pos(',', sLine);
        sID := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 1] := sID;

        // Cargo
        iPos := Pos(',', sLine);
        sCargo := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 2] := sCargo;

        // Weight
        iPos := Pos(',', sLine);
        sWeight := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 3] := sWeight;

        // Cost (e.g., 123,45 needs two parts)
        iPos := Pos(',', sLine);
        sCost := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        iPos := Pos(',', sLine);
        sCost := sCost + ',' + Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 4] := sCost;

        // Fragile
        iPos := Pos(',', sLine);
        sFragile := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 5] := sFragile;

        // Shipper
        iPos := Pos(',', sLine);
        sShipper := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 6] := sShipper;

        // Receiver
        iPos := Pos(',', sLine);
        sReceiver := Copy(sLine, 1, iPos - 1);
        Delete(sLine, 1, iPos);
        ArrOrders[iCol, 7] := sReceiver;

        // Trip
        sTrip := sLine;
        ArrOrders[iCol, 8] := sTrip;

        arrOrders[iCol, 9] := sDateFile ;
      end;
    end;
  end;

  CloseFile(FileOrder);

  // Update StringGrid
  Strgrd.RowCount := iCol + 1; // +1 for header row

  for i := 1 to iCol do
  begin
    Strgrd.Cells[0, i] := ArrOrders[i, 1];
    Strgrd.Cells[1, i] := ArrOrders[i, 2];
    Strgrd.Cells[2, i] := ArrOrders[i, 3];
    Strgrd.Cells[3, i] := ArrOrders[i, 4];
    Strgrd.Cells[4, i] := ArrOrders[i, 5];
    Strgrd.Cells[5, i] := ArrOrders[i, 6];
    Strgrd.Cells[6, i] := ArrOrders[i, 7];
    Strgrd.Cells[7, i] := ArrOrders[i, 8];
     Strgrd.Cells[8, i] := ArrOrders[i, 9];
  end;

  // Show message if no orders match today's date
  if iTotal = 0 then
    ShowMessage('No orders have been placed today.')
  else if iTotal = 1 then
    ShowMessage('There was one order placed today.')
  else
    ShowMessage('There were ' + IntToStr(iTotal) + ' orders placed today.');

  // Adjust grid appearance
  Strgrd.ColWidths[1] := 200;
  Strgrd.Height := 50 + iTotal * 25;


end;
















procedure TFrmAdmin.EdtPasswordChange(Sender: TObject);


begin
   spassword := edtpassword.Text ;



if spassword = 'Admin' then  begin
         edtpassword.Hide;
         lblpassword.Hide;


         DbgrdCargo.Show;                  //DISPLAY WHEN PASSWORD IS CORRECT
         dbgrdflight.show;

         bitbtnSort.Show;
         bitbtnDelete.Show;
         bitbtnEdit.Show;
         bitbtnSelect.Show;
         bitbtnHigh.Show;
         bitbtnAvg.Show;
         bitbtnToday.Show;
         bitbtnreset.Show;
         frmadmin.Height := 700;

         chkart.show;
 chkdangerous.show;
 chkelectronics.show;
 chkmachinery.show   ;
 chkpharma.show;
 bitbtnfiltercargo.show;



end ;
end;

procedure TFrmAdmin.FormCreate(Sender: TObject);

begin
edtpassword.Text := '';



dbgrdcargo.Hide;
dbgrdFlight.Hide;

 chkart.Hide;
 chkdangerous.Hide;
 chkelectronics.Hide;
 chkmachinery.Hide   ;
 chkpharma.Hide;
 bitbtnfiltercargo.Hide;

bitbtnSort.Hide;
bitbtnDelete.Hide;                             //HIDE EVERYTHING
bitbtnEdit.Hide;
bitbtnSelect.Hide;
bitbtnHigh.Hide;
bitbtnAvg.Hide;
bitbtnToday.Hide;
bitbtnreset.Hide;
strgrd.Hide;
 frmadmin.Height := 300;
 frmadmin.Width := 900;



      if not Assigned(DmShipment) then
DmShipment := tdmshipment.Create(Application);


  dmshipment.Tblcargo.Active := true;
   dmshipment.Tblflights.Active := true;
  dmshipment.AdoConPat.Connected := true;                 //CONNECT DATABASE


    dbgrdcargo.DataSource := dmshipment.DatasourceCargo;
    dbgrdflight.DataSource := dmshipment.DatasourceFlight;


   dmshipment.Tblcargo.Filtered := false;
   dmshipment.Tblcargo.First;


    dmshipment.Tblflights.Filtered := false;
   dmshipment.Tblflights.First;

   strgrd.Cells[0,0] := 'Cost_ID';
   strgrd.Cells[1,0] := 'Cargo Type';                   //SET UP STRINGGRID
   strgrd.Cells[2,0] := 'Weight (kg)' ;
   strgrd.cells[3,0] := 'Cost' ;
   strgrd.Cells[4,0] := 'Fragile' ;
   strgrd.Cells[5,0] := 'Shipper' ;
   strgrd.Cells[6,0] := 'Receiver' ;
   strgrd.Cells[7,0] := 'Flight_ID' ;
   strgrd.Cells[8,0] := 'Date' ;

   strgrd.RowCount :=2;
   strgrd.ColCount:= 9;

 DBGrdCargo.Columns[0].Width := 50;  // Set first column width to 50 pixels
DBGrdCargo.Columns[1].Width := 100;
DBGrdCargo.Columns[2].Width := 70;
DBGrdCargo.Columns[3].Width := 80;
DBGrdCargo.Columns[4].Width := 50;
DBGrdCargo.Columns[5].Width := 100;
DBGrdCargo.Columns[6].Width := 100;
DBGrdCargo.Columns[7].Width := 50;




dbgrdflight.Columns[0].Width := 70;
dbgrdflight.Columns[1].Width := 100;
dbgrdflight.Columns[2].Width := 100;
dbgrdflight.Columns[3].Width := 100;
dbgrdflight.Columns[4].Width := 100;


edtpassword.Show;
lblpassword.Show;

dmshipment.TblCargo.Filtered := false;
end;

end.
