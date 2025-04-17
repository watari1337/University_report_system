unit Pattern;

interface

type SArr = array of string;

procedure CreateObjectPattern();
function ListOfWords(fileName: string): SArr;

implementation

uses System.SysUtils, BasicFunction, mainCodeForm,
     Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls, DataBase;


//по файлу создаёт возвращает массив из всех нужных слов в долларах
function ListOfWords(fileName: string): SArr;
const
  goodWords: array[0..18] of string = ('фио','деканд','допфио','группафио',
  'группа','семестр','факульт','спец','спецфакультета','предмет','пфио',
  'дата','моядата','формаобучения','пересдач','телефон','печать',
  'местопредъявления','видзанятий');
var
  startPos, endPos, wordNow, i: integer;
  findDollar, find2Dollar, isGoodWord, stop: boolean;
  word, str: string;
  myFile: textFile;
begin
  AssignFile(myFile, '.\Pattern\' + fileName);
  ReSet(myFile);

  setLength(result, 4);
  wordNow := 0;
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
          result[wordNow] := word;
          inc(wordNow);
        end;

        find2Dollar:= false;
        startPos:= endPos+2;
      end;
    end;
  end;
  //обрезаем массив только до нужных значений
  stop:= false;
  i:= 0;
  while (i < length(result)) and (stop = false) do begin
    if (result[i] = '') then begin
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
  i: integer;
begin

  lbl:= TLabel.Create(MainForm.ScrollBoxPattern);
  lbl.Parent:= MainForm.ScrollBoxPattern;
  lbl.Caption:= 'Выберите 1 из сохранённых шаблонов:';
  lbl.Font.Size:= 14;
  lbl.Left:= Round((MainForm.ScrollBoxPattern.ClientWidth - lbl.Canvas.TextWidth(lbl.Caption)) / 2) ;
  lbl.Top:= 10;
  lbl.Height:= 40;

  i:= 0;
  while (arrPattern[i] <> '') do
  begin
    Btn := TButton.Create(MainForm.ScrollBoxPattern);
    Btn.Parent := MainForm.ScrollBoxPattern;
    Btn.Left := 20;
    Btn.Top := I * 45 + 60;
    Btn.Width := MainForm.ScrollBoxPattern.ClientWidth - 20;
    Btn.Height := 40;
    Btn.Caption := arrPattern[i];
    Btn.OnClick:= MainForm.PatternButtonAction;
    inc(i);
  end;
end;

end.
