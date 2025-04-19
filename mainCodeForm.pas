unit mainCodeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction, Pattern, DataCreate,
  Vcl.ComCtrls, System.Actions,
  Vcl.ActnList;

type
  TMainForm = class(TForm)
    BG: TImage;
    createFile: TButton;
    ChangeData: TButton;
    Exit: TButton;
    Test: TButton;
    changePattern: TButton;
    PageControl1: TPageControl;
    PageMenu: TTabSheet;
    PageCreateByPattern: TTabSheet;
    PanelControlRight: TPanel;
    GoBackMenu: TButton;
    ScrollBoxPattern: TScrollBox;
    FileTextOut: TTabSheet;
    ChangeDataBase: TTabSheet;
    PanelRight: TPanel;
    Menu: TButton;
    PanelAllPage: TPanel;
    ScrollBoxInfo: TScrollBox;
    procedure TestClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure createFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoBackMenuClick(Sender: TObject);
    procedure PatternButtonAction(sender: TObject);
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

procedure TurnOnForm(formNow: TForm);
begin
  //MainForm.Hide;

  formNow.Show;
end;

procedure TMainForm.TestClick(Sender: TObject);
begin
  createData();
end;

procedure TMainForm.createFileClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 1;
end;

procedure TMainForm.ExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.GoBackMenuClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 0;
end;

procedure TMainForm.PatternButtonAction(sender: TObject);
begin
  ListOfWords((sender as Tbutton).Caption);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 0;
  loadData();
  CreateObjectPattern();
end;

end.
