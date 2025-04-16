unit mainCodeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction;

type
  TMainForm = class(TForm)
    BG: TImage;
    createFile: TButton;
    ChangeData: TButton;
    Exit: TButton;
    Test: TButton;
    changePattern: TButton;
    procedure TestClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure StartText();
begin
//    Writeln('Введите номер желаемого действия');
//    Writeln('[0] Выйти из программы');
//    Writeln('[1] Создать файл по готовому шаблону');
//    Writeln('[2] Изменить элементы базы данных');
//    Writeln('[3] Добавить новый шаблон');
    //Writeln('[4] Выйти из программы');
end;

procedure TMainForm.TestClick(Sender: TObject);
begin
  createData();
end;

procedure TMainForm.ExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

end.
