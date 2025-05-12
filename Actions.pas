unit Actions;

interface

type
  MyActions = class
    class procedure ActDeleteData(Sender: TObject);
    class procedure ActAddData(Senser: TObject);
    class procedure ActEditData(Sender: TObject);
//    class procedure Confirm(Sender: TObject);
//    class procedure Cancel(Sender: TObject);
  end;

implementation

uses mainCodeForm, Vcl.Dialogs, DataBase, system.SysUtils, AddEdit,
     Vcl.StdCtrls, Vcl.Samples.Spin, Controls;

class procedure MyActions.ActDeleteData(Sender: TObject);
{var
  nowTeacher: TTeacher;
  nowLearntSubject: TLearntSubject;
  nowStudent: TStudent;
  nowGroup: TGroup;
  nowSpecialty: TSpecialty;
  nowLearntForm: TLearntForm;
  nowFaculty: TFaculty;}
begin
  if (MainForm.PageControl1.ActivePageIndex = 3) and
  (assigned(MainForm.LVShowData.Selected)) then begin
    case workObjNow of
      Teacher: objTTeacher.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      LearntSubject: objTLearntSubject.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      Student: objTStudent.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      Group: objTGroup.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      Specialty: objTSpecialty.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      LearntForm: objTLearntForm.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
      Faculty: objTFaculty.deleteNode(strToInt(MainForm.LVShowData.Selected.Caption));
    end;
  end;
end;

procedure createAskForm(controlCode: Iarr; hint: SArr; firstText: VarArr);
var
  btn: TButton;
  spin: TSpinEdit;
  edit: TEdit;
  captions: SArr;
  baseWidth, baseHeight, widthNow, HeightNow, shiftWidth1, shiftWidth2,
  shiftHeight, maxWidth, maxHeight: integer;
begin

  baseWidth:= 250;
  baseHeight:= 60;
  shiftWidth1:= 30;
  shiftWidth2:= 60;
  shiftHeight:= baseHeight + 20;
  widthNow:= shiftWidth1;
  HeightNow:= 20;
  FrmAddEditElement.Width:= 2*(baseWidth + shiftWidth1) + shiftWidth2;

  for var i:= Low(controlCode) to High(controlCode) do begin
    if (controlCode[i] = 1) then begin
      spin:= TSpinEdit.Create(FrmAddEditElement.PnEdit);
      spin.parent:= FrmAddEditElement.PnEdit;
      spin.AutoSize:= false;
      spin.Left:= widthNow;
      spin.Top:= heightNow;
      spin.Width:= baseWidth;
      spin.Height:= baseHeight;
      spin.Font.Size:= 18;
      spin.Hint:= hint[i];
      spin.ShowHint:= true;
      spin.Value:= firstText[i];
      spin.MinValue:= 0;
      spin.MaxValue:= 999999;
      spin.tag:= i;
    end
    else if (controlCode[i] = 2) then begin
      edit:= TEdit.Create(FrmAddEditElement.PnEdit);
      edit.parent:= FrmAddEditElement.PnEdit;
      edit.AutoSize:= false;
      edit.Left:= widthNow;
      edit.Top:= heightNow;
      edit.Width:= baseWidth;
      edit.Height:= baseHeight;
      edit.Font.Size:= 14;
      edit.TextHint:= hint[i];
      edit.Hint:= hint[i];
      edit.ShowHint:= true;
      edit.Text:= firstText[i];
      edit.tag:= i;
    end;

    maxHeight:= heightNow;
    inc(widthNow, baseWidth + shiftWidth2);
    if (widthNow >  FrmAddEditElement.Width - baseWidth - shiftWidth1) then begin
      widthNow:= shiftWidth1;
      inc(HeightNow, shiftHeight);
    end;
  end;

  //create btn confirm and close
  widthNow:= shiftWidth1;
  HeightNow:= 10;
  captions:= ['Подтвердить', 'Отменить'];

  for var i:= 0 to 1 do begin
    btn:= TButton.Create(FrmAddEditElement.PnExit);
    btn.parent:= FrmAddEditElement.PnExit;
    btn.Caption:= captions[i];
    btn.Left:= widthNow;
    btn.Top:= heightNow;
    btn.Width:= baseWidth;
    btn.Height:= baseHeight;
    btn.Font.Size:= 16;
    btn.ModalResult:= mrOk;
    if (i = 1) then btn.ModalResult:= mrCancel;
    inc(widthNow, baseWidth + shiftWidth2);
  end;
  inc(maxHeight, HeightNow);

  FrmAddEditElement.Height:= maxHeight + 2*shiftHeight + 35; //150 кнопки добавить или отменить
end;

procedure GenerCodeHint(var controlCode: Iarr; var hint: SArr);
begin
  case workObjNow of
    Teacher: begin
      controlCode:= [1, 2]; //1 numberInput, 2 stringInput
      hint:= objTTeacher.makeTitle;
    end;
    LearntSubject: begin
      controlCode:= [1, 2];
      hint:= objTLearntSubject.makeTitle;
    end;
    Student: begin
      controlCode:= [1, 1, 2];
      hint:= objTStudent.makeTitle;
    end;
    Group: begin
      controlCode:= [1, 1];
      hint:= objTGroup.makeTitle;
    end;
    Specialty: begin
      controlCode:= [1, 1, 2];
      hint:= objTSpecialty.makeTitle;
    end;
    LearntForm: begin
      controlCode:= [1, 2];
      hint:= objTLearntForm.makeTitle;
    end;
    Faculty: begin
      controlCode:= [1, 2, 2];
      objTFaculty.makeTitle;
    end;
  end;
end;

function FromFrameToVarArr(): varArr;
var
  control: TControl;
begin
  with FrmAddEditElement.PnEdit do begin
    for var i:= 0 to ControlCount-1 do begin
      control:= Controls[i];
      if (control is TEdit) then
        result[control.Tag]:= (control as TEdit).Text;
      if (control is TSpinEdit) then
        result[control.Tag]:= (control as TSpinEdit).Value;
    end;
  end;
end;

class procedure MyActions.ActAddData(Senser: TObject);
var
  controlCode: Iarr;
  hint: SArr;
  firstText: VarArr;
begin
  if (MainForm.PageControl1.ActivePageIndex = 3) and
  (assigned(MainForm.LVShowData.Selected)) then begin
    GenerCodeHint(controlCode, hint);
    setLength(firstText, MainForm.LVShowData.Columns.Count);
    createAskForm(controlCode, hint, firstText);

    FrmAddEditElement.ShowModal;
  end;
end;

class procedure MyActions.ActEditData(Sender: TObject);
var
  controlCode: Iarr;
  hint: SArr;
  firstText: VarArr;
  index: integer;
begin
  if (MainForm.PageControl1.ActivePageIndex = 3) and
  (assigned(MainForm.LVShowData.Selected)) then begin
    GenerCodeHint(controlCode, hint);

    with MainForm.LVShowData do
    begin
      index:= 0;
      setLength(firstText, Columns.Count);
      firstText[index]:= Selected.caption;
      inc(index);
      for var i:= 0 to Columns.Count-2 do begin
        firstText[index]:= Selected.SubItems[i];
        inc(index);
      end;
    end;
    createAskForm(controlCode, hint, firstText);

    FrmAddEditElement.ShowModal;
  end;
end;

end.
