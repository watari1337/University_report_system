unit Pattern;

interface

type
    Pair = Record
      index: integer;
      text: string;
    End;

    str2 = Record
      fileWord: string;
      userWord: string;
    End;

    SPArr = array of Pair;
    StrArr = array of string;
    InputArr = array of str2;

var
  findWords: SPArr;  //words from pattern
  getWords: InputArr; //user input words
  groupId: integer;
  fileNameNow: string;

function ListOfWords(fileName: string): SPArr;
function checkEdit(): boolean;
function ReadAnswer: InputArr;
procedure MakeWords(var Words: SPArr; userWords: InputArr);
procedure FindGroup();

implementation

uses System.SysUtils, BasicFunction, mainCodeForm,
     Vcl.StdCtrls, Vcl.ExtCtrls, DataBase, Vcl.Buttons, Vcl.Graphics,
     WorkWithData, DateUtils;
     
const
  goodWords: array[0..20] of string = ('фио','деканд','допфио','группафио',
  'группа','семестр','факульт','спец','спецфакультета','предмет','пфио',
  'дата','моядата','формаобучения','пересдач','телефон','печать',
  'местопредъявления','видзанятий', 'курс', 'год');
     
//по файлу создаёт возвращает массив из всех нужных слов в долларах, в виде
//записи где есть сама строка и новер символа где это слово в строке
function ListOfWords(fileName: string): SPArr;
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
          result[wordNow].index:= startPos + maxIndex; //
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

procedure FindGroup();
var
  groupFind: boolean;
  index: integer;
begin
  groupFind:= false;
  for var i := Low(getWords) to High(getWords) do begin
    if (getWords[i].fileWord = 'группа') then begin
      groupFind:= true;
      groupId:= strToInt(getWords[i].userWord);
    end;
  end;
  if (groupFind = false) then begin     //если нет группы тогда точно есть фио
    index:= 0;
    while (index < length(getWords)) and (getWords[index].fileWord <> 'фио') do inc(index);
    if (index < length(getWords)) then groupId:= findGroupByName(getWords[index].userWord);
    //если среди запрашиваемых есть группа надо добавить
    index:= 0;
    while (index < length(findWords)) and (findWords[index].text <> 'группа') do inc(index);
    if (index < length(getWords)) then findWords[index].text:= intToStr(groupId);
  end;
end;

function ReadAnswer: InputArr;
var
  myEdit: TEdit;
  index: integer;
begin
  setLength(result, MainForm.ScrollBoxPattern.ControlCount);
  index:= 0;
  for var i:= 0 to MainForm.ScrollBoxPattern.ControlCount - 1 do begin
    if (MainForm.ScrollBoxPattern.Controls[i] is TEdit) then begin
      myEdit:= (MainForm.ScrollBoxPattern.Controls[i] as TEdit);
      result[index].fileWord:= myEdit.Name;
      result[index].userWord:= myEdit.Text;
      inc(index);
    end;
  end;
  setLength(result, index);
end;

function checkInputWord(Edit: TEdit): boolean;
begin
  result:= false;
  {'фио','допфио','предмет','моядата',
  'пересдач','телефон','печать', 'местопредъявления','видзанятий'}
  if (edit.Name = 'фио') and (findGroupByName(edit.Text) <> -1) then result:= true
  else if (edit.Name = 'допфио') or (edit.Name = 'телефон') then result:= true
  else if (edit.Name = 'допфио') then result:= true     
end;

function checkEdit(): boolean;
var
  myEdit: TEdit;
begin
  result:= true;
  for var i:= 0 to MainForm.ScrollBoxPattern.ControlCount - 1 do begin
    if (MainForm.ScrollBoxPattern.Controls[i] is TEdit) then begin
      myEdit:= (MainForm.ScrollBoxPattern.Controls[i] as TEdit);
      if (checkInputWord(myEdit)) then begin //and (myEdit.tag <> 0)
        myEdit.Color:= clWebMediumSpringGreen;
      end
      else begin
        myEdit.Color:= $005858FF;
        result:= false;
      end;
    end;
  end;
end;

//в группе много чего зашифрованно указав число получим нужное число из группы
function GetIdFromGroup(value, group: integer): integer;
begin 
  case value of
    0: result:= group div 100000;   //год поступления
    1: result:= group div 10000 mod 10; //facult
    2: result:= group div 100 mod 100; //spesiality
    3: result:= group div 10 mod 10;  //learnt form
    4: result:= group mod 10;  //group number
  end;
end;

function GetElementUserWords(id: string; words: InputArr): string;
var
  i: integer;
begin
  result:= '';
  I := Low(words);
  while i <= High(words) do begin
    if (words[i].fileWord = id) then begin 
      result:= words[i].userWord;
      break;
    end;
    inc(i);
  end;                                                         
end;

procedure MakeWords(var Words: SPArr; userWords: InputArr);
var
  find: boolean;
  j, num, num1: integer;
  str: string;
begin
  for var i := Low(words) to High(words) do begin
    //check words from input
    str:= GetElementUserWords(words[i].text, userWords);
    if (str <> '') then begin
      words[i].text:= str;
    end
    else begin
      //group
      if words[i].text = 'факульт' then 
        str:= objTFaculty.Read1(GetIdFromGroup(1, groupId), 1)
      else if words[i].text = 'спец' then
        str:= objTSpecialty.Read1(GetIdFromGroup(2, groupId), 2)
      else if words[i].text = 'деканд' then
        str:= objTFaculty.Read1(GetIdFromGroup(1, groupId), 2)
      else if words[i].text = 'формаобучения' then
        str:= objTLearntForm.Read1(GetIdFromGroup(3, groupId), 1)
      //подсчёт зная группу
      else if words[i].text = 'курс' then begin
        num:= yearOf(Date()) mod 10;
        num1:= GetIdFromGroup(0, groupId);
        if (num >= num1) and (monthOf(Date) >= 7) then str:= intToStr(num - num1+1)
        else if (num >= num1) and (monthOf(Date) < 7) then str:= intToStr(num - num1)
        else if (num < num1) and (monthOf(Date) >= 7) then str:= intToStr(num + 10 - num1+1)
        else if (num < num1) and (monthOf(Date) < 7) then str:= intToStr(num + 10 - num1)
      end        
      else if words[i].text = 'семестр' then begin
        num:= yearOf(Date()) mod 10;
        num1:= GetIdFromGroup(0, groupId);
        if (num >= num1) and (monthOf(Date) >= 7) then str:= intToStr((num - num1+1)*2-1)
        else if (num >= num1) and (monthOf(Date) < 7) then str:= intToStr((num - num1)*2)
        else if (num < num1) and (monthOf(Date) >= 7) then str:= intToStr((num + 10 - num1+1)*2-1)
        else if (num < num1) and (monthOf(Date) < 7) then str:= intToStr((num + 10 - num1)*2-1)
      end        
      //data
      else if words[i].text = 'дата' then str:= DateTostr(Date())
      else if words[i].text = 'год' then str:= intToStr(yearOf(Date()))
      //массив группы                                       //ищем предмет тогда знаем пфио
      else if words[i].text = 'пфио' then begin //ищем пфио тогда знаем предмет
        num:= objTLearntSubject.FindAny( GetElementUserWords('предмет', userWords), 1, 0);
        num:= takeFromArrGroup(2, num, 1, groupId);
        str:= objTTeacher.Read1(num, 1);
        str:= str + ' ' + objTTeacher.Read1(num, 2);
      end
      else if words[i].text = 'предмет' then begin
        num:= objTTeacher.FindAny( GetElementUserWords('пфио', userWords), 2, 0);
        num:= takeFromArrGroup(1, num, 2, groupId);
        str:= objTLearntSubject.Read1(num, 1);
      end;
      
      words[i].text:= str;
    end;
    
         
  end;
end;

end.
