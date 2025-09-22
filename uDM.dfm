object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 246
  Width = 266
  object dbLibrary: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=C:\Users\Jovana\Desktop\RentaCar\myshopdb.db3')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 48
  end
  object QTemp: TFDQuery
    Connection = dbLibrary
    Left = 56
    Top = 136
  end
end
