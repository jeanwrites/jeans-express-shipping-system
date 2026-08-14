object DmShipment: TDmShipment
  OldCreateOrder = False
  Height = 299
  Width = 362
  object TblCargo: TADOTable
    Active = True
    Connection = AdoConPat
    CursorType = ctStatic
    TableName = 'TblCargo'
    Left = 136
    Top = 160
  end
  object AdoConPat: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=db_PAT_Shipment.mdb' +
      ';Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:System dat' +
      'abase="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=' +
      '"";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet' +
      ' OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transacti' +
      'ons=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System' +
      ' Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't' +
      ' Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica ' +
      'Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 208
    Top = 88
  end
  object DataSourceCargo: TDataSource
    DataSet = TblCargo
    Left = 120
    Top = 64
  end
  object TblFlights: TADOTable
    Active = True
    Connection = AdoConPat
    CursorType = ctStatic
    TableName = 'TblFlights'
    Left = 208
    Top = 160
  end
  object DataSourceFlight: TDataSource
    DataSet = TblFlights
    Left = 40
    Top = 128
  end
end
