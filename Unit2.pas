unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls,
  uDM, FMX.DateTimeCtrls, FMX.ListBox;

type
  TForm2 = class(TForm)
    TabControl1: TTabControl;

    // Tab 1: Unos korisnika
    TabItem1: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    edtIme: TEdit;
    edtPrezime: TEdit;
    edtJMBG: TEdit;
    edtBrojDozvole: TEdit;
    btnDalje: TButton;

    // Tab 2: Rezervacija vozila
    TabItem2: TTabItem;
    Layout2: TLayout;
    Image2: TImage;
    ComboBox1: TComboBox;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    Button1: TButton; // Dugme za potvrdu rezervacije

    procedure FormCreate(Sender: TObject);
    procedure btnDaljeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    function VratiCenuPoDanu(const Vozilo: string): Double;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.FormCreate(Sender: TObject);
begin
  // Popuni ComboBox sa tvojim vozilima
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('VW GOLF 7 20$');
  ComboBox1.Items.Add('Audi A3 40$');
  ComboBox1.Items.Add('BMW M3 60$');
  ComboBox1.Items.Add('Mercedes G-dass 100$');
  ComboBox1.Items.Add('Opel Astra 100$');
  ComboBox1.Items.Add('Golf 5 50$');
  ComboBox1.Items.Add('BMW 320d 50$');
  ComboBox1.Items.Add('Audi A5 50$');
  ComboBox1.Items.Add('VW POLO 30$');
  ComboBox1.Items.Add('Ford Focus 20$');

  // Setuj današnji datum
  DateEdit1.Date := Date;
  DateEdit2.Date := Date;
end;

procedure TForm2.btnDaljeClick(Sender: TObject);
begin
  // Validacija unosa korisnika
  if (Trim(edtIme.Text) = '') or (Trim(edtPrezime.Text) = '') or
     (Trim(edtJMBG.Text) = '') or (Trim(edtBrojDozvole.Text) = '') then
  begin
    ShowMessage('Molimo popunite sva polja!');
    Exit;
  end;

  // Provera da li korisnik već postoji po JMBG
  dm.QTemp.Close;
  dm.QTemp.SQL.Text := 'SELECT * FROM Korisnici WHERE jmbg = :j';
  dm.QTemp.ParamByName('j').AsString := edtJMBG.Text;
  dm.QTemp.Open;

  if not dm.QTemp.IsEmpty then
  begin
    ShowMessage('Korisnik sa ovim JMBG već postoji!');
    Exit;
  end;

  // Ubacivanje novog korisnika u tabelu Korisnici
  dm.QTemp.Close;
  dm.QTemp.SQL.Text :=
    'INSERT INTO Korisnici (ime, prezime, jmbg, broj_dozvole) ' +
    'VALUES (:ime, :prezime, :jmbg, :broj)';
  dm.QTemp.ParamByName('ime').AsString := edtIme.Text;
  dm.QTemp.ParamByName('prezime').AsString := edtPrezime.Text;
  dm.QTemp.ParamByName('jmbg').AsString := edtJMBG.Text;
  dm.QTemp.ParamByName('broj').AsString := edtBrojDozvole.Text;
  dm.QTemp.ExecSQL;

  ShowMessage('Korisnik je uspešno sačuvan!');

  // Očisti polja
  edtIme.Text := '';
  edtPrezime.Text := '';
  edtJMBG.Text := '';
  edtBrojDozvole.Text := '';

  // Prelazak na drugi TabItem
  TabControl1.TabIndex := 1;
end;

function TForm2.VratiCenuPoDanu(const Vozilo: string): Double;
begin
  if Vozilo = 'VW GOLF 7 20$' then
    Result := 20
  else if Vozilo = 'Audi A3 40$' then
    Result := 40
  else if Vozilo = 'BMW M3 60$' then
    Result := 60
  else if Vozilo = 'Mercedes G-dass 100$' then
    Result := 100
  else if Vozilo = 'Opel Astra 100$' then
    Result := 100
  else if Vozilo = 'Golf 5 50$' then
    Result := 50
  else if Vozilo = 'BMW 320d 50$' then
    Result := 50
  else if Vozilo = 'Audi A5 50$' then
    Result := 50
  else if Vozilo = 'VW POLO 30$' then
    Result := 30
  else if Vozilo = 'Ford Focus 20$' then
    Result := 20
  else
    Result := 0;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  DatumOd, DatumDo: TDate;
  BrojDana: Integer;
  CenaPoDanu, UkupnaCena: Double;
  IzabranoVozilo: string;
  IdKorisnika: Integer;
  Odgovor: TModalResult;
begin
  // Validacija datuma i vozila
  if ComboBox1.ItemIndex = -1 then
  begin
    ShowMessage('Molimo izaberite vozilo!');
    Exit;
  end;

  DatumOd := DateEdit1.Date;
  DatumDo := DateEdit2.Date;

  if DatumDo < DatumOd then
  begin
    ShowMessage('Datum kraja ne može biti pre datuma početka!');
    Exit;
  end;

  BrojDana := Trunc(DatumDo - DatumOd) + 1;
  IzabranoVozilo := ComboBox1.Selected.Text;
  CenaPoDanu := VratiCenuPoDanu(IzabranoVozilo);
  UkupnaCena := BrojDana * CenaPoDanu;

  // Prikaži ukupnu cenu i pitaj korisnika da potvrdi ili otkaže
  Odgovor := MessageDlg(
    Format('Ukupna cena: %.2f $ (%d dana x %.2f $)', [UkupnaCena, BrojDana, CenaPoDanu]),
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    0
  );

  if Odgovor = mrNo then
    Exit; // Ako korisnik klikne "Otkaži", prekini proceduru

  // Pronađi ID poslednje unetog korisnika po JMBG
  dm.QTemp.Close;
  dm.QTemp.SQL.Text := 'SELECT id FROM Korisnici ORDER BY id DESC LIMIT 1';
  dm.QTemp.Open;

  if dm.QTemp.IsEmpty then
  begin
    ShowMessage('Korisnik nije pronađen!');
    Exit;
  end;

  IdKorisnika := dm.QTemp.FieldByName('id').AsInteger;

  // Ubacivanje u tabelu Rezervacije
  dm.QTemp.Close;
  dm.QTemp.SQL.Text :=
    'INSERT INTO Rezervacije (korisnik_id, vozilo, datum_od, datum_do, ukupna_cena) ' +
    'VALUES (:id, :voz, :od, :do, :cena)';
  dm.QTemp.ParamByName('id').AsInteger := IdKorisnika;
  dm.QTemp.ParamByName('voz').AsString := IzabranoVozilo;
  dm.QTemp.ParamByName('od').AsDate := DatumOd;
  dm.QTemp.ParamByName('do').AsDate := DatumDo;
  dm.QTemp.ParamByName('cena').AsFloat := UkupnaCena;
  dm.QTemp.ExecSQL;

  ShowMessage('Rezervacija je uspešno sačuvana!');
end;

end.










