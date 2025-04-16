program Report_System_VLC;

uses
  Vcl.Forms,
  mainCodeForm in 'mainCodeForm.pas' {MainForm},
  DataBase in 'DataBase.pas',
  BasicFunction in 'BasicFunction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
