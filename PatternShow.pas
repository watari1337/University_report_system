unit PatternShow;

interface

uses Pattern;

procedure CreateObjectPattern();
procedure CreateAskTexBox(arr: SPArr);
procedure createOutFile(words: SPArr);

implementation

uses Vcl.StdCtrls, mainCodeForm, Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls,
     DataBase, ActionsPattern, Vcl.ComCtrls, Classes, Windows;

procedure CreateObjectPattern();
const
  basicColorPanel: TColor = clCream;
  LVS_NOCOLUMNHEADER = $4000;
var
  btn: TButton;
  lbl: TLabel;
  i, width: integer;
  LV: TListView;
  item: TListItem;
  collum: TListColumn;
  Style: LongInt;
begin
  lbl:= TLabel.Create(MainForm.ScrollBoxPattern);
  lbl.Parent:= MainForm.ScrollBoxPattern;
  lbl.Caption:= 'Выберите 1 из сохранённых шаблонов:';
  lbl.Font.Size:= 14;
  lbl.Left:= Round((MainForm.ScrollBoxPattern.ClientWidth - lbl.Canvas.TextWidth(lbl.Caption)) / 2) ;
  lbl.Top:= 10;
  lbl.Height:= 40;

  LV:= TlistView.Create(MainForm.ScrollBoxPattern);
  with LV do begin
    name:= 'LVPattern';
    Parent:= MainForm.ScrollBoxPattern;
    Left:= 0;
    Top:= 60;
    Width:= MainForm.ScrollBoxPattern.ClientWidth;
    Height:= MainForm.ScrollBoxPattern.ClientHeight-60;
    ViewStyle := vsReport;
    RowSelect := True;
    GridLines:= true;
    Font.Size:= 14;
    collum:= columns.Add;
    collum.Alignment:= taCenter;
    collum.Width:= -2;
    collum.Caption:= '';

    for I := Low(arrPattern) to High(arrPattern) do begin
      item:= Items.Add();
      item.Caption:= Copy(arrPattern[i], 0, Length(arrPattern[i]) - 4);
    end;
  end;

  // Скрыть заголовок
  Style := GetWindowLong(LV.Handle, GWL_STYLE);
  SetWindowLong(LV.Handle, GWL_STYLE, Style or LVS_NOCOLUMNHEADER);

  {i:= 0;
  width:= MainForm.ScrollBoxPattern.ClientWidth - 40;
  while (arrPattern[i] <> '') do
  begin
    Btn:= TButton.Create(MainForm.ScrollBoxPattern);
    Btn.Parent:= MainForm.ScrollBoxPattern;
    Btn.Left:= 20;
    Btn.Top:= I * 45 + 60;
    Btn.Width:= width;
    Btn.Height:= 40;
    Btn.Caption:= arrPattern[i];
    Btn.OnClick:= PatternActions.ActChoosePattern;
    inc(i);
  end;}
end;

procedure createEditPattern(var Top, Width: integer; hint: string);
var
  myEdit: TEdit;
begin
  myEdit:= TEdit.Create(MainForm.ScrollBoxPattern);
  myEdit.Parent:= MainForm.ScrollBoxPattern;
  myEdit.Left:= 20;
  myEdit.Top:= top;
  myEdit.Width:= width;
  myEdit.Height:= 40;
  myEdit.TextHint:= 'Введите ' + hint;
  //myEdit.Name:= hint;
  myEdit.Text:= '';
  inc(top, 45);
end;

const
  ngw2 = 1;
  WordsFirst: array[0..8] of string = ('фио','допфио','предмет','моядата',
  'пересдач','телефон','печать', 'местопредъявления','видзанятий');
  WordsSecond: array[0..ngw2] of string = ('группа','пфио');

procedure CreateAskTexBox(arr: SPArr);
var
  btn: TButton;
  panel: TPanel;
  top, width: integer;
  neadHourCredits, neadInitzial: boolean;
  NeadString: array[0..ngw2] of boolean;
begin
  Btn:= TButton.Create(MainForm.ScrollBoxPattern);
  Btn.Parent:= MainForm.ScrollBoxPattern;
  Btn.Left:= MainForm.ScrollBoxPattern.ClientWidth - 220;
  Btn.Top:= 10;
  Btn.Width:= 200;
  Btn.Height:= 40;
  btn.Caption:= 'готово';
  btn.OnClick:= PatternActions.ReadyButtonClick;

  for var i := Low(NeadString) to High(NeadString) do NeadString[i]:= true;

  top:= 65;
  width:= MainForm.ScrollBoxPattern.ClientWidth - 40;
  neadHourCredits:= false;
  neadInitzial:= false;
  for var i:= Low(arr) to High(arr) do begin
    for var j:= Low(WordsFirst) to High(WordsFirst) do begin
      if (arr[i].text = WordsFirst[j]) then begin
        if (WordsFirst[j] = 'фио') then begin
          NeadString[0]:= false;
          createEditPattern(Top, Width, 'имя');
          createEditPattern(Top, Width, 'фамилия');
          createEditPattern(Top, Width, 'отчество');
        end
        else begin
          createEditPattern(Top, Width, arr[i].text);
          if (WordsFirst[j] = 'предмет') then NeadString[1]:= false;
        end;
      end;
    end;

    if (arr[i].text = 'часов') or (arr[i].text = 'зачедин') then
      neadHourCredits:= true;
    if (arr[i].text = 'инициалы') then neadInitzial:= true;

  end;
                          //тогда есть фио
  if (neadInitzial) and (NeadString[0]) then begin
    NeadString[0]:= false;
    createEditPattern(Top, Width, 'имя');
    createEditPattern(Top, Width, 'фамилия');
    createEditPattern(Top, Width, 'отчество');
  end;

  for var i:= Low(arr) to High(arr) do begin
    for var j:= Low(WordsSecond) to High(WordsSecond) do begin
      if (arr[i].text = WordsSecond[j]) and (NeadString[j]) then begin
        createEditPattern(Top, Width, arr[i].text);
        NeadString[j]:= false;
      end;
    end;
  end;

  if (NeadString[0]) then createEditPattern(Top, Width, 'группа');
  if (NeadString[1]) and (neadHourCredits) then
    createEditPattern(Top, Width, 'предмет');

end;

procedure createOutFile(words: SPArr);
var
  fileNow: TextFile;
  text, str: string;
  memo: TMemo;
  placeNow, differens, indexArr, temp: integer;
begin

  //readFile
  assignFile(fileNow, '.\Pattern\' + fileNameNow);
  reSet(fileNow);
  try
    text:= '';
    differens:= 0;
    indexArr:= 0;
    while (not EOF(fileNow)) do begin
      Readln(fileNow, str);
      text:= text + str;
      while (indexArr < length(words)) and
      (length(text) > words[indexArr].index + differens) do begin
        temp:= words[indexArr].index + differens;
        placeNow:= temp;
        while (text[placeNow] <> '$') do inc(placeNow);

        delete(text, temp-1, placeNow-temp+2);
        dec(differens, placeNow-temp+2);
        insert(words[indexArr].text, text, temp-1);
        inc(differens, length(words[indexArr].text));
        inc(indexArr);
      end;

      inc(differens, length(sLineBreak));
      length(text);
      text:= text + sLineBreak;
      length(text);
    end;
  finally
    close(fileNow);
  end;

  //create TEdit
  memo:= TMemo.Create(MainForm.ScrollBoxPattern);
  memo.parent:= MainForm.ScrollBoxPattern;
  memo.Name:= 'UserMemoFile';
  memo.TextHint:= fileNameNow;
  memo.Text:= text;
  memo.Align:= alClient;
  memo.ScrollBars:= TScrollStyle.ssVertical;
end;

end.
