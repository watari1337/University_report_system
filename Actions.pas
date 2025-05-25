unit Actions;

interface

type
  MyActions = class
    class procedure ActDeleteData(Sender: TObject);
    class procedure ActAddData(Senser: TObject);
    class procedure ActEditData(Sender: TObject);
    class procedure ActShowExtraData(Sender: TObject);
    class procedure CheckData(Sender: TObject);
    class procedure ChooseDataClick(Sender: TObject);
  end;

implementation

uses mainCodeForm, Vcl.Dialogs, DataBase, system.SysUtils, AddEdit,
     Vcl.StdCtrls, Vcl.Samples.Spin, Controls, WorkWithData, Vcl.ComCtrls,
     Vcl.Graphics, pattern;

function checkDataEdit(edit: TEdit): boolean;
begin
  result:= true;
  if (edit.text = '') then result:= false
  else begin

  end;

end;

function checkDataSpin(spin: TSpinEdit): boolean;
begin
  result:= true;
  //if (spin.Value = 0) then result:= false

  if (workObjNow = Student) and (spin.Tag = 2) //enter group in list of group
  and (objTGroup.CheckAny(spin.Value, 0) = false)
    then result:= false

  else if (workObjNow = Group) and (MainForm.LVShowData.Tag = -1)  //проверка кода группы
  and (spin.Tag = 0)
  and( (objTFaculty.CheckAny( GetIdFromGroup(1, spin.Value), 0) = false)
  or (objTSpecialty.CheckAny( GetIdFromGroup(2, spin.Value), 0) = false)
  or (objTLearntForm.CheckAny( GetIdFromGroup(3, spin.Value), 0) = false))
    then result:= false

  else if (workObjNow = Group) and (MainForm.LVShowData.Tag <> -1)  //предмет в рассписании группы существует
  and (spin.Tag = 1) and (objTLearntSubject.CheckAny( spin.Value, 0) = false)
    then result:= false

  else if (workObjNow = Group) and (MainForm.LVShowData.Tag <> -1)  //препод в рассписании группы существует
  and (spin.Tag = 2) and (objTTeacher.CheckAny( spin.Value, 0) = false)
    then result:= false

  else if (workObjNow = Specialty) and (spin.Tag = 1)
  and (objTFaculty.CheckAny(spin.Value, 0) = false)
    then result:= false
end;

class procedure MyActions.CheckData(Sender: TObject);
var
  btn: TButton;
  edit: TEdit;
  spin: TSpinEdit;
  ans: boolean;
begin
  ans:= true;
  for var i:= 0 to FrmAddEditElement.PnEdit.ControlCount - 1 do begin
    if (FrmAddEditElement.PnEdit.Controls[i] is TEdit) then begin
      edit:= (FrmAddEditElement.PnEdit.Controls[i] as TEdit);
      if (checkDataEdit(edit)) then begin
        edit.Color:= clWebMediumSpringGreen;
      end
      else begin
        edit.Color:= $005858FF;
        ans:= false;
      end;
    end
    else if (FrmAddEditElement.PnEdit.Controls[i] is TSpinEdit) then begin
      spin:= (FrmAddEditElement.PnEdit.Controls[i] as TSpinEdit);
      if (checkDataSpin(spin)) then begin
        spin.Color:= clWebMediumSpringGreen;
      end
      else begin
        spin.Color:= $005858FF;
        ans:= false;
      end;
    end;
  end;

  if (ans) then FrmAddEditElement.ModalResult:= mrOk;

end;

class procedure MyActions.ActDeleteData(Sender: TObject);
var
  selected: integer;
begin
  if (MainForm.PageControl1.ActivePageIndex = 3) and
  (assigned(MainForm.LVShowData.Selected)) then begin
    if (MainForm.LVShowData.tag = -1) then begin
      selected:= strToInt(MainForm.LVShowData.Selected.Caption);
      case workObjNow of
        Teacher: objTTeacher.deleteNode( selected);
        LearntSubject: objTLearntSubject.deleteNode( selected);
        Student: objTStudent.deleteNode( selected);
        Group: objTGroup.deleteNode( selected);
        Specialty: objTSpecialty.deleteNode( selected);
        LearntForm: objTLearntForm.deleteNode( selected);
        Faculty: objTFaculty.deleteNode( selected);
      end;
    end
    else begin
      selected:= MainForm.LVShowData.Selected.Index;
      DeleteGroupArrAny(MainForm.LVShowData.Tag, selected);
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
  //free Form
  for var I := (FrmAddEditElement.PnEdit.ComponentCount-1) downto 0 do
    FrmAddEditElement.PnEdit.Components[i].Free;
  for var I := (FrmAddEditElement.PnExit.ComponentCount-1) downto 0 do
    FrmAddEditElement.PnExit.Components[i].Free;

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

    if (controlCode[i] <> 0) then begin
      maxHeight:= heightNow;
      inc(widthNow, baseWidth + shiftWidth2);
      if (widthNow >  FrmAddEditElement.Width - baseWidth - shiftWidth1) then begin
        widthNow:= shiftWidth1;
        inc(HeightNow, shiftHeight);
      end;
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
    //btn.ModalResult:= mrOk;
    if (i = 0) then btn.OnClick:= MyActions.CheckData;
    if (i = 1) then btn.ModalResult:= mrCancel;
    inc(widthNow, baseWidth + shiftWidth2);
  end;
  inc(maxHeight, HeightNow);

  FrmAddEditElement.Height:= maxHeight + 2*shiftHeight + 35; //150 кнопки добавить или отменить
end;

function FromFrameToVarArr(): varArr;
var
  control: TControl;
  controlArr: Iarr;
  hint: Sarr;
begin
  GenerCodeHint(controlArr, hint);
  with FrmAddEditElement.PnEdit do begin
    setLength(result, Length(controlArr));
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
  arr: varArr;
begin
  GenerCodeHint(controlCode, hint);
  //just zero arr при создании ничего не должно быть
  setLength(firstText, MainForm.LVShowData.Columns.Count);
  createAskForm(controlCode, hint, firstText);

  modalAns:= FrmAddEditElement.ShowModal;
  if (modalAns = mrOk) then begin

    arr:= FromFrameToVarArr();
    if (MainForm.LVShowData.tag = -1) then begin //add ID and another
      case workObjNow of
        Teacher: arr[0]:= objTTeacher.LastId +1; //only id
        LearntSubject: arr[0]:= objTLearntSubject.LastId +1; //only id
        Student: begin
          arr[0]:= (arr[2] div 10) * 1000 + objTGroup.FindAny(arr[2], 0, 1)+1; //only id
        end;
        Group: begin
          arr[1]:= 0; arr[2]:= 0;
        end;
        Specialty: arr[0]:= objTSpecialty.FreeId; //only id
        LearntForm: arr[0]:= objTLearntForm.FreeId; //only id
        Faculty: arr[0]:= objTFaculty.FreeId; //only id
      end;
    end;
    //else реализовано непосредственно в добавлении

    if (MainForm.LVShowData.tag = -1) then PushListT(arr)
    else pushGroupArr(MainForm.LVShowData.Tag, arr);
  end
end;

class procedure MyActions.ActEditData(Sender: TObject);
var
  controlCode: Iarr;
  hint: SArr;
  firstText: VarArr;
  index: integer;
  modalAns: TModalresult;
  arr: varArr;
begin
  GenerCodeHint(controlCode, hint);

  with MainForm.LVShowData do begin
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

    arr:= FromFrameToVarArr();
    if (MainForm.LVShowData.tag = -1) then begin //add ID and another
      case workObjNow of
        Teacher: arr[0]:= firstText[0]; //only id
        LearntSubject: arr[0]:= firstText[0]; //only id
        Student: arr[0]:= firstText[0]; //only id
        Group: begin
          arr[1]:= firstText[1]; arr[2]:= firstText[2];
        end;
        Specialty: arr[0]:= firstText[0]; //only id
        LearntForm: arr[0]:= firstText[0]; //only id
        Faculty: arr[0]:= firstText[0]; //only id
      end;
    end;
    //else реализовано непосредственно в добавлении

    if MainForm.LVShowData.tag = -1 then begin
      index:= strToint(MainForm.LVShowData.Selected.caption);
      case workObjNow of
        Teacher: objTTeacher.ChangeT(index, arr);
        LearntSubject: objTLearntSubject.ChangeT(index, arr);
        Student: objTStudent.ChangeT(index, arr);
        Group: objTGroup.ChangeT(index, arr);
        Specialty: objTSpecialty.ChangeT(index, arr);
        LearntForm: objTLearntForm.ChangeT(index, arr);
        Faculty: objTFaculty.ChangeT(index, arr);
      end;
    end
    else begin
      EditData(MainForm.LVShowData.Tag, MainForm.LVShowData.Selected.Index, arr);
    end;
  end
end;

class procedure MyActions.ActShowExtraData(Sender: TObject);
var
  titles: Sarr;
  widths: IArr;
  col: TListColumn;
begin
  with MainForm.LVShowData do begin
    if (tag = -1) then begin
      MainForm.MoreData.Caption:= 'Группы';
      Tag:= strtoInt(items[ItemIndex].Caption);
      Items.Count:= objTGroup.ReadT( objTGroup.Find(tag))[2];

      titles:= makeTitle(workObjNow);
      widths:= [90, 90, 90, 90, 90];
      Columns.Clear;
      for var i:= 0 to length(titles)-1 do begin
        col:= Columns.Add;
        col.Caption:= titles[i];
        col.Width:= widths[i];
      end;
      col.Width:= -2;
    end
    else begin
      MainForm.MoreData.Caption:= 'расписание';
      tag:= -1;
      objTGroup.createPageShowList;
    end;

    Selected:= nil;
    Invalidate;
  end;
end;

class procedure MyActions.ChooseDataClick(Sender: TObject);
begin
  with MainForm do begin
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
end;

end.

