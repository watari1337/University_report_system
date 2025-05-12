unit mainCodeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction, Pattern, DataCreate, funcCompareAndtoString,
  Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.Samples.Spin;

type
  TMainForm = class(TForm)
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
    PageMenuData: TTabSheet;
    PanelRightMenuData: TPanel;
    ButtonMenu: TButton;
    PanelChooseData: TPanel;
    Teacher: TButton;
    LearntSubject: TButton;
    Student: TButton;
    Group: TButton;
    Specialty: TButton;
    LearntForm: TButton;
    Faculty: TButton;
    Image1: TImage;
    LVShowData: TListView;
    BtnDelete: TButton;
    BtnAddElement: TButton;
    BtnEditElement: TButton;
    ActionList1: TActionList;
    deleteData: TAction;
    AddData: TAction;
    editData: TAction;
    procedure ReadyButtonClick(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure createFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoBackMenuClick(Sender: TObject);
    procedure PatternButtonAction(sender: TObject);
    procedure ChooseDataClick(Sender: TObject);
    procedure ChangeDataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses Actions;

procedure TMainForm.ReadyButtonClick(Sender: TObject);
begin
  checkEdit();
end;

procedure TMainForm.ChangeDataClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 4;  //
end;

procedure ClearScrolBox(myBox: TScrollBox);
begin
  for var i:= 0 to myBox.ControlCount-1 do begin
    myBox.Controls[0].Free;
  end;
end;

procedure TMainForm.ChooseDataClick(Sender: TObject);
begin
  case (Sender as TButton).TabOrder of
    0: objTLearntSubject.createPageShowList;
    1: objTTeacher.createPageShowList;
    2: objTStudent.createPageShowList;
    3: objTGroup.createPageShowList;
    4: objTSpecialty.createPageShowList;
    5: objTFaculty.createPageShowList;
    6: objTLearntForm.createPageShowList;
  end;
  workObjNow:= TallType((Sender as TButton).TabOrder);
  PageControl1.ActivePageIndex:= 3;  //Data changes/show
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
  CreateObjectPattern();
  PageControl1.ActivePageIndex:= 1;
end;

procedure TMainForm.ExitClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.GoBackMenuClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 0;
  //if (Sender as TButton).Tag = 1 then ClearScrolBox(ScrollBoxInfo);
  if (Sender as TButton).Tag = 2 then ClearScrolBox(ScrollBoxPattern);
end;

procedure TMainForm.PatternButtonAction(sender: TObject);
var
  findWords: SArr;
begin
  findWords:= ListOfWords((sender as Tbutton).Caption);
  ClearScrolBox(ScrollBoxPattern);
  CreateAskTexBox(findWords);

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 0;
  loadData();

  //connect actions from another unit
  deleteData.OnExecute:= Actions.MyActions.ActDeleteData;
  addData.OnExecute:= Actions.MyActions.ActAddData;
  editData.OnExecute:= Actions.MyActions.ActEditData;
end;

end.
