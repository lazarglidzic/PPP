unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  Tdm = class(TDataModule)
    dbLibrary: TFDConnection;
    QTemp: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  dbLibrary.Connected := True;

  // 1️⃣ Tabela za login korisnike (admin)
  QTemp.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Users (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'username TEXT NOT NULL UNIQUE, ' +
    'password TEXT NOT NULL);';
  QTemp.ExecSQL;

  QTemp.Close;
  QTemp.SQL.Text := 'SELECT COUNT(*) AS cnt FROM Users';
  QTemp.Open;

  if QTemp.FieldByName('cnt').AsInteger = 0 then
  begin
    QTemp.Close;
    QTemp.SQL.Text :=
      'INSERT INTO Users (username, password) VALUES (:u, :p)';
    QTemp.ParamByName('u').AsString := 'admin';
    QTemp.ParamByName('p').AsString := '1234';
    QTemp.ExecSQL;
  end;

  // 2️⃣ Tabela za korisnike (Form2)
  QTemp.Close;
  QTemp.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Korisnici (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'ime TEXT NOT NULL, ' +
    'prezime TEXT NOT NULL, ' +
    'jmbg TEXT NOT NULL UNIQUE, ' +
    'broj_dozvole TEXT NOT NULL UNIQUE);';
  QTemp.ExecSQL;

  // 3️⃣ Tabela za rezervacije
  QTemp.Close;
  QTemp.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS Rezervacije (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'korisnik_id INTEGER NOT NULL, ' +
    'vozilo TEXT NOT NULL, ' +
    'datum_od DATE NOT NULL, ' +
    'datum_do DATE NOT NULL, ' +
    'ukupna_cena REAL NOT NULL, ' +
    'FOREIGN KEY (korisnik_id) REFERENCES Korisnici(id));';
  QTemp.ExecSQL;
end;

end.



