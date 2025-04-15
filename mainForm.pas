unit mainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction;

type
  TForm1 = class(TForm)
    BG: TImage;
    createFile: TButton;
    ChangeData: TButton;
    выход: TButton;
    Test: TButton;
    changePattern: TButton;
    procedure TestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure StartText();
var
    variant: integer;
begin
  Writeln('Введите номер желаемого действия');
  Writeln('[0] Выйти из программы');
  Writeln('[1] Создать файл по готовому шаблону');
  Writeln('[2] Изменить элементы базы данных');
  Writeln('[3] Добавить новый шаблон');
  //Writeln('[4] Выйти из программы');
  variant:= ReadInt(0, 3);
  case variant of
    0:
    begin
      //ничего нет, программа сама закроется
    end;
    1:
    begin

    end;
    2:
    begin

    end;
    3:
    begin

    end;
    4:
    begin

    end;
  end;
end;

procedure TForm1.TestClick(Sender: TObject);
begin
  createFaculty();
end;

end.
