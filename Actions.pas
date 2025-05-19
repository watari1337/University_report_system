unit Actions;

interface

type
  MyActions = class
    class procedure ActDeleteData(Sender: TObject);
    class procedure ActAddData(Senser: TObject);
    class procedure ActEditData(Sender: TObject);
    class procedure ActShowExtraData(Sender: TObject);
  end;

implementation

uses mainCodeForm, Vcl.Dialogs, DataBase, system.SysUtils, AddEdit,
     Vcl.StdCtrls, Vcl.Samples.Spin, Controls, WorkWithData, Vcl.ComCtrls;

class procedure MyActions.ActDeleteData(Sender: TObject);
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
  case workObjNow of  //1 numberInput, 2 stringInput
    Teacher: controlCode:= [1, 2, 2];
    LearntSubject: controlCode:= [1, 2];
    Student: controlCode:= [1, 1, 1, 2];
    Group: controlCode:= [1, 1, 1];
    Specialty: controlCode:= [1, 1, 2];
    LearntForm: controlCode:= [1, 2];
    Faculty: controlCode:= [1, 2, 2];
  end;
  hint:= makeTitle(workObjNow);
end;

function FromFrameToVarArr(): varArr;
var
  control: TControl;
begin
  with FrmAddEditElement.PnEdit do begin
    setLength(result, ControlCount);
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
  modalAns: TModalresult;
begin
  GenerCodeHint(controlCode, hint);
  setLength(firstText, MainForm.LVShowData.Columns.Count);
  createAskForm(controlCode, hint, firstText);

  modalAns:= FrmAddEditElement.ShowModal;
  if (modalAns = mrOk) then begin
    PushListT(FromFrameToVarArr());
  end
end;

class procedure MyActions.ActEditData(Sender: TObject);
var
  controlCode: Iarr;
  hint: SArr;
  firstText: VarArr;
  index: integer;
  modalAns: TModalresult;
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

    modalAns:= FrmAddEditElement.ShowModal;
    if (modalAns = mrOk) then begin
      index:= strToint(MainForm.LVShowData.Selected.caption);
      case workObjNow of
        Teacher: objTTeacher.ChangeT(index, FromFrameToVarArr());
        LearntSubject: objTLearntSubject.ChangeT(index, FromFrameToVarArr());
        Student: objTStudent.ChangeT(index, FromFrameToVarArr());
        Group: objTGroup.ChangeT(index, FromFrameToVarArr());
        Specialty: objTSpecialty.ChangeT(index, FromFrameToVarArr());
        LearntForm: objTLearntForm.ChangeT(index, FromFrameToVarArr());
        Faculty: objTFaculty.ChangeT(index, FromFrameToVarArr());
      end;
    end
  end;
end;

class procedure MyActions.ActShowExtraData(Sender: TObject);
var
  titles: Sarr;
  widths: IArr;
  col: TListColumn;
begin
  if (MainForm.PageControl1.ActivePageIndex = 3) and
  (assigned(MainForm.LVShowData.Selected)) then begin
    with MainForm.LVShowData do begin
      Tag:= strtoInt(items[ItemIndex].Caption);
      Items.Count:= objTGroup.ReadT( objTGroup.Find(tag))[2];
      
      titles:= ['id', 'id предмета','id учителя','часов', 'credits'];
      widths:= [90, 90, 90, 90, 90];
      Columns.Clear;
      for var i:= 0 to length(titles)-1 do begin
        col:= Columns.Add;
        col.Caption:= titles[i];
        col.Width:= widths[i];
      end;
      col.Width:= -2;
      Invalidate;
    end;
  end;
end;

end.

