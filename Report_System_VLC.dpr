program Report_System_VLC;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {Form1},
  DataBase in 'DataBase.pas',
  BasicFunction in 'BasicFunction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
