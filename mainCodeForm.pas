unit mainCodeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  DataBase, BasicFunction, Pattern, DataCreate,
  Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.Samples.Spin, ULoadData, SaveData, WorkWithData,
  PatternShow, ActionsPattern;

type
  TMainForm = class(TForm)
    createFile: TButton;
    ChangeData: TButton;
    btnExit: TButton;
    Test: TButton;
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
    btnChoose: TButton;
    ChoosePattern: TAction;
    ActSavePattern: TAction;
    ActSaveAs: TAction;
    ActAddPattern: TAction;
    ActDelPattern: TAction;
    FileODPattern: TFileOpenDialog;
    procedure TestClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure createFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoBackMenuClick(Sender: TObject);
    procedure LVShowDataData(Sender: TObject; Item: TListItem);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
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

procedure TMainForm.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
var
  status: boolean;
  LV: TListView;
  obj: TObject;
begin
  if (statusPattern = 1) then begin //выбор паттерна
    obj:= MainForm.ScrollBoxPattern.FindComponent('LVPattern');
    ActDelPattern.Enabled:= Assigned(obj) and (obj is TListView) and ((obj as TListView).ItemIndex <> -1);
    ChoosePattern.Enabled:= ActDelPattern.Enabled;

    BtnSaveAsOrAdd.Action:= ActAddPattern;
    BtnDelOrSave.Action:= ActDelPattern;
    btnChoose.action:= ChoosePattern;
  end
  else if (statusPattern = 2) then begin

    BtnSaveAsOrAdd.Action:= ActSaveAs;
    BtnDelOrSave.Action:= ActSavePattern;
  end
  else begin
    BtnSaveAsOrAdd.Visible:= false;
    BtnDelOrSave.Visible:= false;
    btnChoose.Visible:= false;
  end;


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

procedure TMainForm.TestClick(Sender: TObject);
begin
  createData();
end;

procedure TMainForm.createFileClick(Sender: TObject);
begin
  CreateObjectPattern();
  PageControl1.ActivePageIndex:= 1;
  statusPattern:= 1;
  ActionList1.UpdateAction(ChoosePattern);
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

procedure TMainForm.ChangeDataClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex:= 4;
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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if (DirectoryExists('Data\') = false) then CreateDir('Data\');
  if (DirectoryExists('Pattern\') = false) then CreateDir('Pattern\');
  if (DirectoryExists('Pattern\Delete\') = false) then CreateDir('Pattern\Delete\');
  if (DirectoryExists('Pattern\Result\') = false) then CreateDir('Pattern\Result\');

  FileODPattern.DefaultFolder:= ExtractFilePath(ParamStr(0));

  statusPattern:= 0;
  PageControl1.ActivePageIndex:= 0;
  loadDataFile();

  //connect actions from another unit
  deleteData.OnExecute:= Actions.MyActions.ActDeleteData;
  addData.OnExecute:= Actions.MyActions.ActAddData;
  editData.OnExecute:= Actions.MyActions.ActEditData;
  actShowExtraInfo.OnExecute:= Actions.MyActions.ActShowExtraData;

  ChoosePattern.OnExecute:= PatternActions.ActChoosePattern;
  ActSavePattern.OnExecute:= PatternActions.ActSave;
  ActSaveAs.OnExecute:= PatternActions.ActSaveAs;
  ActDelPattern.OnExecute:= PatternActions.ActDeletePattern;
  ActAddPattern.OnExecute:= PatternActions.ActAddPattern;

  Teacher.OnClick:= MyActions.ChooseDataClick;
  LearntSubject.OnClick:= MyActions.ChooseDataClick;
  Student.OnClick:= MyActions.ChooseDataClick;
  Group.OnClick:= MyActions.ChooseDataClick;
  Specialty.OnClick:= MyActions.ChooseDataClick;
  LearntForm.OnClick:= MyActions.ChooseDataClick;
  Faculty.OnClick:= MyActions.ChooseDataClick;
end;

end.
