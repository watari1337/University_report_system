unit ActionsPattern;

interface

uses Vcl.Forms;

type
  PatternActions = class
    class procedure ActChoosePattern(Sender: TObject);
    class procedure ActSave(Sender: TObject);
    class procedure ActSaveAs(Sender: TObject);
    class procedure ActAddPattern(Sender: TObject);
    class procedure ActDeletePattern(Sender: TObject);
    class procedure ReadyButtonClick(Sender: TObject);
  end;

procedure ClearScrolBox(myBox: TScrollBox);

implementation

uses Pattern, Vcl.StdCtrls, MainCodeForm, PatternShow, System.SysUtils,
     windows, Vcl.Dialogs, ULoadData, Vcl.ComCtrls;

procedure ClearScrolBox(myBox: TScrollBox);
begin
  for var i:= 0 to myBox.ControlCount-1 do begin
    myBox.Controls[0].Free;
  end;
end;

{ PatternActions }

class procedure PatternActions.ActAddPattern(Sender: TObject);
var
  sourc, dest: string;
  LV: TListView;
  obj: TObject;
  item: TListItem;
begin
  with MainForm do begin
    if ODPattern.Execute() then begin
      sourc:= ODPattern.FileName;
      dest:= ExtractFilePath(ParamStr(0));
      dest:= dest + 'Pattern\' + ExtractFileName(sourc);
      //false перезаписать если такой файл уже есть true не перезаписывать
      if CopyFile(PChar(sourc), PChar(dest), true) then begin
        showMessage('Файл успешно скопирован!');
        reLoadPattern();
        obj:= MainForm.ScrollBoxPattern.FindComponent('LVPattern');
        if Assigned(obj) and (obj is TListView) then begin
          LV:= (obj as TListView);
          item:= LV.Items.Add;
          item.Caption:= Copy(ExtractFileName(sourc), 0, length(ExtractFileName(sourc)) - 4);
        end;
      end
      else showMessage(SysErrorMessage(GetLastError));
    end;
  end;
end;

//from your choose pattern create page with ask words for pattern
class procedure PatternActions.ActChoosePattern(Sender: TObject);
var
  LV: TListView;
  obj: TObject;
begin
  obj:= MainForm.ScrollBoxPattern.FindComponent('LVPattern');
  if Assigned(obj) and (obj is TListView) then begin
    LV:= (obj as TListView);
    fileNameNow:= LV.Selected.Caption + '.txt';
    findWords:= ListOfWords(fileNameNow);
    ClearScrolBox(MainForm.ScrollBoxPattern);
    if (length(findWords) > 0) then CreateAskTexBox(findWords)
    else begin
      createOutFile(findWords);
    end;
    statusPattern:= 0;
  end;
end;

class procedure PatternActions.ActDeletePattern(Sender: TObject);
var
  LV: TListView;
  obj: TObject;
  sourc, dest: string;
begin
  obj:= MainForm.ScrollBoxPattern.FindComponent('LVPattern');
  if Assigned(obj) and (obj is TListView) then begin
    LV:= (obj as TListView);
    dest:= ExtractFilePath(ParamStr(0));
    sourc:= dest + 'Pattern\' + LV.Selected.Caption + '.txt';
    dest:= dest + 'Pattern\Delete\' + LV.Selected.Caption +
    FormatDateTime(' dd.mm.yyyy hh.nn.ss ', Now) + '.txt';
    if RenameFile(sourc, dest) then begin
      showMessage('Файл удалён!');
      reLoadPattern();
      LV.Selected.Delete;
      //MainForm.LVShowData.SetFocus;
    end
    else showMessage(SysErrorMessage(GetLastError));
  end;
end;

procedure SaveFile(FileAdr: string);
var
  FileName, str: string;
  myFile: TextFile;
  obj: TObject;
  memo: TMemo;
  FindIndex: integer;
begin
  obj:= MainForm.ScrollBoxPattern.FindComponent('UserMemoFile');
  if Assigned(obj) and (obj is TMemo) then begin
    memo:= (obj as TMemo);
    str:= memo.Text;
    FileName:= FileAdr + ChangeFileExt(memo.TextHint, '') +
    FormatDateTime('dd.mm.yyyy hh.nn.ss ', Now) + '.txt';
    try
      AssignFile(myFile, FileName);
      ReWrite(myFile);
      FindIndex:= Pos(sLineBreak, str);
      while (FindIndex <> 0) do begin
        Writeln(myFile, Copy(str, 1, FindIndex));
        Delete(str, 1, FindIndex + Length(sLineBreak)-1);
        FindIndex:= Pos(sLineBreak, str);
      end;
      ShowMessage('Файл сохранён!');
    finally
      Close(myFile);
    end;
  end;
end;


class procedure PatternActions.ActSave(Sender: TObject);
var
  FileName: string;
begin
  SaveFile('Pattern\Result\');
end;

class procedure PatternActions.ActSaveAs(Sender: TObject);
var
  FileName: string;
begin
  if MainForm.FileODPattern.Execute then begin
    SaveFile(MainForm.FileODPattern.FileName + '\');
  end;


end;

class procedure PatternActions.ReadyButtonClick(Sender: TObject);
begin
  getWords:= ReadAnswer();
  FindGroup();
  if (checkEdit()) then begin

    MakeWords(findWords, getWords);
    ClearScrolBox(MainForm.ScrollBoxPattern);
    createOutFile(findWords);

    statusPattern:= 2;
    MainForm.ActionList1.UpdateAction(MainForm.ActSavePattern);
  end;
end;

end.
