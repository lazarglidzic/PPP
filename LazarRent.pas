 unit LazarRent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, Unit2;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    Započni: TTabItem;
    Logovanje: TTabItem;
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    Image2: TImage;
    Image3: TImage;
    Label2: TLabel;
    edtUsername: TEdit;
    Lozinka: TEdit;
    Button2: TButton;
    Image4: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure ProveriLogin;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses uDM, uMain;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // prelazak na tab za logovanje
  TabControl1.TabIndex := 1;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ProveriLogin;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  // isto kao Button1 - ide na login tab
  TabControl1.TabIndex := 1;
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  ProveriLogin;
end;

procedure TForm1.ProveriLogin;
begin
  dm.QTemp.Close;
  dm.QTemp.SQL.Text :=
    'SELECT * FROM Users WHERE username = :u AND password = :p';
  dm.QTemp.ParamByName('u').AsString := edtUsername.Text;
  dm.QTemp.ParamByName('p').AsString := Lozinka.Text;
  dm.QTemp.Open;

  if not dm.QTemp.IsEmpty then
  begin
    ShowMessage('Uspešno ste logovani!');
    // otvori glavnu formu
    Form2.Show;
    Form1.Hide;
  end
  else
    ShowMessage('Pogrešan username ili lozinka!');
end;

end.



