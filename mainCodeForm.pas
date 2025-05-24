unit mainCodeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction, Pattern, DataCreate,
  Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.Samples.Spin, ULoadData, SaveData, WorkWithData,
  PatternShow;

type
  TMainForm = class(TForm)
    createFile: TButton;
    ChangeData: TButton;
    btnExit: TButton;
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
    ExitSave: TButton;
    ODPattern: TOpenDialog;
    MoreData: TButton;
    actShowExtraInfo: TAction;
    BtnSaveAsOrAdd: TButton;
    BtnDelOrSave: TButton;
    procedure ReadyButtonClick(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure createFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoBackMenuClick(Sender: TObject);
    procedure PatternButtonAction(sender: TObject);
    procedure ChooseDataClick(Sender: TObject);
    procedure ChangeDataClick(Sender: TObject);
    procedure LVShowDataData(Sender: TObject; Item: TListItem);
    procedure changePatternClick(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
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

procedure TMainForm.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
var
  status: boolean;
begin
  if (PageControl1.ActivePageIndex = 3) then begin

    if (LVShowData.Tag = -1) then begin
      status:= (LVShowData.ItemIndex <> -1);
      if (workObjNow = TAllType(3)) then status:= false;
      editData.Enabled:= status;

      if (workObjNow = TAllType(4)) or (workObjNow = TAllType(5)) or
      (workObjNow = TAllType(6)) then begin
        deleteData.Enabled:= false;
        status:= false;
        if (workObjNow = TAllType(4)) and (objTSpecialty.Count < 100) then status:= true;
        AddData.Enabled:= status;
      end
      else begin
        AddData.Enabled:= true;
        deleteData.Enabled:= (LVShowData.ItemIndex <> -1);
        actShowExtraInfo.Enabled:= (LVShowData.ItemIndex <> -1);
      end;
    end
    else begin
      editData.Enabled:= (LVShowData.ItemIndex <> -1);
      deleteData.Enabled:= (LVShowData.ItemIndex <> -1);
      AddData.Enabled:= objTGroup.FindAny(LVShowData.Tag, 0, 2) < NArrSbjTch;
      actShowExtraInfo.Enabled:= true;
    end;
  end;

  Handled:= true; //обработка сделана мной, дальше не надо
end;

procedure TMainForm.ChangeDataClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 4;
end;

procedure ClearScrolBox(myBox: TScrollBox);
begin
  for var i:= 0 to myBox.ControlCount-1 do begin
    myBox.Controls[0].Free;
  end;
end;

procedure TMainForm.changePatternClick(Sender: TObject);
var
  sourc, dest: string;
begin
  if ODPattern.Execute() then begin
    sourc:= ODPattern.FileName;
    dest:= ExtractFilePath(ParamStr(0));
    dest:= dest + 'Pattern\' + ExtractFileName(sourc);
    //false перезаписать если такой файл уже есть true не перезаписывать 
    if CopyFile(PChar(sourc), PChar(dest), true) then begin
      showMessage('Файл успешно скопирован!');
      reLoadPattern();
    end
    else showMessage(SysErrorMessage(GetLastError));
  end;
end;

procedure TMainForm.ChooseDataClick(Sender: TObject);
begin
  MoreData.Visible:= false;
  LVShowData.Tag:= -1;
  case (Sender as TButton).TabOrder of
    0: objTLearntSubject.createPageShowList;
    1: objTTeacher.createPageShowList;
    2: objTStudent.createPageShowList;
    3: begin
      objTGroup.createPageShowList;
      MoreData.Visible:= true;
      MoreData.Caption:= 'расписание';
    end;
    4: objTSpecialty.createPageShowList;
    5: objTFaculty.createPageShowList;
    6: objTLearntForm.createPageShowList;
  end;
  workObjNow:= TallType((Sender as TButton).TabOrder);
  PageControl1.ActivePageIndex:= 3;  //Data changes/show
end;

procedure TurnOnForm(formNow: TForm);
begin
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

procedure TMainForm.btnExitClick(Sender: TObject);
begin
  if (Sender is TButton) then begin
    if (Sender as TButton).tag = 1 then SaveDataFile; //save and exit
  end;

  objTTeacher.Free;
  objTLearntSubject.Free;
  objTStudent.Free;
  objTGroup.Free;
  objTSpecialty.Free;
  objTLearntForm.Free;
  objTFaculty.Free;

  MainForm.Close;
end;

procedure TMainForm.GoBackMenuClick(Sender: TObject);
begin
  MainForm.LVShowData.Selected:= nil;
  PageControl1.ActivePageIndex:= 0;
  //if (Sender as TButton).Tag = 1 then ClearScrolBox(ScrollBoxInfo);
  if (Sender as TButton).Tag = 2 then ClearScrolBox(ScrollBoxPattern);
end;

procedure TMainForm.LVShowDataData(Sender: TObject; Item: TListItem);
var
  element: VarArr;
  arrGroup: TArrSbjTch;
  arrElement: TSbjTeacher;
begin
  if (sender is TListview) then begin
    if (sender as TListview).Tag = -1 then begin //show list

      case workObjNow of
        TAllType(1): element:= objTTeacher.ReadT( objTTeacher.GetByIndex(item.Index));
        TAllType(0): element:= objTLearntSubject.ReadT( objTLearntSubject.GetByIndex(item.Index));
        TAllType(2): element:= objTStudent.ReadT( objTStudent.GetByIndex(item.Index));
        TAllType(3): element:= objTGroup.ReadT( objTGroup.GetByIndex(item.Index));
        TAllType(4): element:= objTSpecialty.ReadT( objTSpecialty.GetByIndex(item.Index));
        TAllType(6): element:= objTLearntForm.ReadT( objTLearntForm.GetByIndex(item.Index));
        TAllType(5): element:= objTFaculty.ReadT( objTFaculty.GetByIndex(item.Index));
      end;

      item.Caption:= element[0];
      for var i := 1 to High(element) do begin
        item.SubItems.Add(element[i]);
      end;

    end
    //show array from type now only from group
    else if (workObjNow = TAllType(3)) then begin
      arrGroup:= GetArrDataFromGroup((sender as TListview).Tag)^;
      arrElement:= arrGroup[item.Index];

      item.Caption:= intToStr(arrElement.id);
      item.SubItems.Add(intToStr(arrElement.sbj));
      item.SubItems.Add(intToStr(arrElement.teacher));
      //item.SubItems.Add(intToStr(arrElement.typeSbj));
      item.SubItems.Add(intToStr(arrElement.hour));
      item.SubItems.Add(intToStr(arrElement.credits));
    end;
  end;
end;

//from your choose pattern create page with ask words for pattern
procedure TMainForm.PatternButtonAction(sender: TObject);
begin
  fileNameNow:= (sender as Tbutton).Caption;
  findWords:= ListOfWords(fileNameNow);
  ClearScrolBox(ScrollBoxPattern);
  if (length(findWords) > 0) then CreateAskTexBox(findWords)
  else begin
    ClearScrolBox(ScrollBoxPattern);
    createOutFile(findWords);
  end;

end;

procedure TMainForm.ReadyButtonClick(Sender: TObject);
begin
  getWords:= ReadAnswer();
  FindGroup();
  if (checkEdit()) then begin

    MakeWords(findWords, getWords);
    ClearScrolBox(ScrollBoxPattern);
    createOutFile(findWords);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if (DirectoryExists('Data\') = false) then CreateDir('Data\');
  if (DirectoryExists('Pattern\') = false) then CreateDir('Pattern\');
  

  PageControl1.ActivePageIndex:= 0;
  loadDataFile();

  //connect actions from another unit
  deleteData.OnExecute:= Actions.MyActions.ActDeleteData;
  addData.OnExecute:= Actions.MyActions.ActAddData;
  editData.OnExecute:= Actions.MyActions.ActEditData;
  actShowExtraInfo.OnExecute:= Actions.MyActions.ActShowExtraData;
end;

end.
