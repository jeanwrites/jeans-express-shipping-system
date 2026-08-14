unit Dmshipment_u;

interface

uses
  SysUtils, Classes, DB, ADODB   ;

type
  TDmShipment = class(TDataModule)
    TblCargo: TADOTable;
    AdoConPat: TADOConnection;
    DataSourceCargo: TDataSource;
    TblFlights: TADOTable;
    DataSourceFlight: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmShipment: TDmShipment;

implementation

{$R *.dfm}

end.
