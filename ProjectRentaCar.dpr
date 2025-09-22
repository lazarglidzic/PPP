program ProjectRentaCar;

uses
  System.StartUpCopy,
  FMX.Forms,
  LazarRent in 'LazarRent.pas' {Form1},
  uMain in 'uMain.pas' {FrmMain},
  uDM in 'uDM.pas' {dm: TDataModule},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
