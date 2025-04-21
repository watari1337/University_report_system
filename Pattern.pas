unit Pattern;

interface

type
    Pair = Record
      index: integer;
      text: string;
    End;

    SArr = array of Pair;

procedure CreateObjectPattern();
function ListOfWords(fileName: string): SArr;
procedure CreateAskTexBox(arr: SArr);
function checkEdit(): boolean;

implementation

uses System.SysUtils, BasicFunction, mainCodeForm,
     Vcl.StdCtrls, Vcl.ExtCtrls, DataBase, Vcl.Buttons, Vcl.Graphics;


//по файлу создаёт возвращает массив из всех нужных слов в долларах, в виде
//записи где есть сама строка и новер символа где это слово в строке
function ListOfWords(fileName: string): SArr;
const
  goodWords: array[0..18] of string = ('фио','деканд','допфио','группафио',
  'группа','семестр','факульт','спец','спецфакультета','предмет','пфио',
  'дата','моядата','формаобучения','пересдач','телефон','печать',
  'местопредъявления','видзанятий');
var
  startPos, endPos, wordNow, i, maxIndex: integer;
  findDollar, find2Dollar, isGoodWord, stop: boolean;
  word, str: string;
  myFile: textFile;
begin
  AssignFile(myFile, '.\Pattern\' + fileName);
  ReSet(myFile);

  setLength(result, 4);
  wordNow := 0;
  maxIndex:= 0;
  While (not EOf(myFile)) do begin
    Readln(myFile, Str);
    findDollar := False;
    find2Dollar := False;
    for i := 1 to length(str) do
    begin
      if (str[i] = '$') then
      begin
        if (findDollar) then begin
          endPos := i-1;
          find2Dollar:= true;
        end
        else startPos := i + 1;
        findDollar:= true;
      end;
      if (find2Dollar) then
      begin
        word:= copy(str, startPos, endPos - startPos + 1);
        LowerRus(word);
        word:= trim(word);
        isGoodWord:= false;
        //ппроверяем это слово подходит нам
        for var j:= Low(goodWords) to High(goodWords) do begin
          if (goodWords[j] = word) then isGoodWord:= true;
        end;
        if (isGoodWord) then begin
          if (wordNow >= length(result)) then setLength(result, length(result)*2);
          result[wordNow].index:= startPos + maxIndex;
          result[wordNow].text:= word;
          inc(wordNow);
        end;

        find2Dollar:= false;
        startPos:= endPos+2;
      end;
    end;
    inc(maxIndex, length(str));
  end;
  closeFile(myFile);
  //обрезаем массив только до нужных значений
  stop:= false;
  i:= 0;
  while (i < length(result)) and (stop = false) do begin
    if (result[i].text = '') then begin
      SetLength(result, i);
      stop:= true;
    end;
    inc(i);
  end;

end;

procedure CreateObjectPattern();
const
  basicColorPanel: TColor = clCream;
var
  btn: TButton;
  lbl: TLabel;
  i, width: integer;
begin

  lbl:= TLabel.Create(MainForm.ScrollBoxPattern);
  lbl.Parent:= MainForm.ScrollBoxPattern;
  lbl.Caption:= 'Выберите 1 из сохранённых шаблонов:';
  lbl.Font.Size:= 14;
  lbl.Left:= Round((MainForm.ScrollBoxPattern.ClientWidth - lbl.Canvas.TextWidth(lbl.Caption)) / 2) ;
  lbl.Top:= 10;
  lbl.Height:= 40;

  i:= 0;
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
    Btn.OnClick:= MainForm.PatternButtonAction;
    inc(i);
  end;
end;

procedure CreateAskTexBox(arr: SArr);
const
  goodWords: array[0..8] of string = ('фио','допфио','предмет','моядата',
  'пересдач','телефон','печать', 'местопредъявления','видзанятий');
var
  myEdit: TEdit;
  btn: TButton;
  panel: TPanel;
  top, width: integer;
begin
  Btn:= TButton.Create(MainForm.ScrollBoxPattern);
  Btn.Parent:= MainForm.ScrollBoxPattern;
  Btn.Left:= MainForm.ScrollBoxPattern.ClientWidth - 220;
  Btn.Top:= 10;
  Btn.Width:= 200;
  Btn.Height:= 40;
  btn.Caption:= 'готово';
  btn.OnClick:= MainForm.ReadyButtonClick;

  {panel:= TPanel.Create(MainForm.ScrollBoxPattern);
  panel.parent:= MainForm.ScrollBoxPattern;
  panel.Caption:= 'готово';
  panel.Color:= clGreen;
  panel.Left:= MainForm.ScrollBoxPattern.ClientWidth - 220;
  panel.Top:= 10;
  panel.Width:= 200;
  panel.Height:= 40;}

  top:= 65;
  width:= MainForm.ScrollBoxPattern.ClientWidth - 40;
  for var i:= Low(arr) to High(arr) do begin
    for var j:= Low(goodWords) to High(goodWords) do begin
      if (arr[i].text = goodWords[j]) then begin
        myEdit:= TEdit.Create(MainForm.ScrollBoxPattern);
        myEdit.Parent:= MainForm.ScrollBoxPattern;
        myEdit.Left:= 20;
        myEdit.Top:= top;
        myEdit.Width:= width;
        myEdit.Height:= 40;
        myEdit.TextHint:= 'Введите ' + arr[i].text;
        inc(top, 45);
      end;
    end;
  end;
end;

function checkEdit(): boolean;
var
  myEdit: TEdit;
begin
  result:= true;
  for var i:= 0 to MainForm.ScrollBoxPattern.ControlCount - 1 do begin
    if (MainForm.ScrollBoxPattern.Controls[i] is TEdit) then begin
      myEdit:= (MainForm.ScrollBoxPattern.Controls[i] as TEdit);
      if (myEdit.Text = '') then begin //and (myEdit.tag <> 0)
        myEdit.Color:= $005858FF;
        result:= false;
      end
      else myEdit.Color:= clWebMediumSpringGreen;
    end;
  end;
end;


end.
