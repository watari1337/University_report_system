program Report_System_VLC;

uses
  Vcl.Forms,
  mainCodeForm in 'mainCodeForm.pas' {MainForm},
  DataBase in 'DataBase.pas',
  BasicFunction in 'BasicFunction.pas',
  Pattern in 'Pattern.pas',
  DataCreate in 'DataCreate.pas',
  AddEdit in 'AddEdit.pas' {FrmAddEditElement},
  Actions in 'Actions.pas',
  WorkWithData in 'WorkWithData.pas',
  ULoadData in 'ULoadData.pas',
  SaveData in 'SaveData.pas',
  PatternShow in 'PatternShow.pas',
  ActionsPattern in 'ActionsPattern.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFrmAddEditElement, FrmAddEditElement);
  Application.Run;
end.
