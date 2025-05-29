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
  groupId, statusPattern: integer;
  fileNameNow: string;

function ListOfWords(fileName: string): SPArr;
function checkEdit(): boolean;
function ReadAnswer: InputArr;
procedure MakeWords(var Words: SPArr; userWords: InputArr);
procedure FindGroup();
function GetElementUserWords(id: string; words: InputArr): string;
function GetIdFromGroup(value, group: integer): integer;

implementation

uses System.SysUtils, BasicFunction, mainCodeForm,
     Vcl.StdCtrls, Vcl.ExtCtrls, DataBase, Vcl.Buttons, Vcl.Graphics,
     WorkWithData, DateUtils;
     
const
  goodWords: array[0..22] of string = ('фио','деканд','допфио','группафио',
  'группа','семестр','факульт','спец','предмет','пфио',
  'дата','моядата','формаобучения','пересдач','телефон','печать',
  'местопредъявления','видзанятий', 'курс', 'год', 'часов', 'зачедин', 'инициалы');

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
  FirstName, SecondName, ThirdName: string;
  index: integer;
begin
  groupFind:= false;
  for var i := Low(getWords) to High(getWords) do begin
    with getWords[i] do begin
      if (fileWord = 'группа') then begin
        groupFind:= true;
        if (TryStrToInt(userWord, groupId) = false ) then groupId:= -1;
      end
      else if (fileWord = 'имя') then FirstName:= userWord
      else if (fileWord = 'фамилия') then SecondName:= userWord
      else if (fileWord = 'отчество') then ThirdName:= userWord
    end;
  end;
  if (groupFind = false) then begin     //если нет группы тогда точно есть фио
    groupId:= findGroupByName(FirstName, SecondName, ThirdName);
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

//take from user input words word 'id'
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
  num, num1: integer;
  str: string;
  arr1, arr2, arr3: VarArr;
begin
  for var i := Low(words) to High(words) do begin
    //check words from input
    str:= GetElementUserWords(words[i].text, userWords);
    if (str <> '') then begin
      words[i].text:= str;
    end
    else begin
      if words[i].text = 'группа' then str:= intToStr(groupId);
      //group
      if words[i].text = 'факульт' then
        str:= objTFaculty.Read1(GetIdFromGroup(1, groupId), 1)
      else if words[i].text = 'спец' then
        str:= objTSpecialty.Read1(GetIdFromGroup(2, groupId), 2)
      else if words[i].text = 'деканд' then
        str:= objTFaculty.Read1(GetIdFromGroup(1, groupId), 3) +
        ' ' + objTFaculty.Read1(GetIdFromGroup(1, groupId), 2) +
        ' ' + objTFaculty.Read1(GetIdFromGroup(1, groupId), 4)
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
      //массив группы
      else if words[i].text = 'пфио' then begin //ищем пфио тогда знаем предмет
        num:= objTLearntSubject.FindAny( GetElementUserWords('предмет', userWords), 1, 0);
        num:= takeFromArrGroup(2, num, 1, groupId);
        str:= objTTeacher.Read1(num, 1);
        str:= str + ' ' + objTTeacher.Read1(num, 3) +
        ' ' + objTTeacher.Read1(num, 2) +
        ' ' + objTTeacher.Read1(num, 4);
      end
      else if words[i].text = 'предмет' then begin    //ищем предмет тогда знаем пфио
        num:= objTTeacher.FindAny( GetElementUserWords('пфио', userWords), 2, 0);
        num:= takeFromArrGroup(1, num, 2, groupId);
        str:= objTLearntSubject.Read1(num, 1);
      end
      else if words[i].text = 'часов' then begin  //точно есть либо предмет либо пфио {надо доделать}
        if (GetElementUserWords('пфио', userWords) <> '') then begin
          num:= objTTeacher.FindAny( GetElementUserWords('пфио', userWords), 2, 0);
          str:= intToStr(takeFromArrGroup(3, num, 2, groupId));
        end
        else begin
          num:= objTLearntSubject.FindAny( GetElementUserWords('предмет', userWords), 1, 0);
          str:= intToStr(takeFromArrGroup(3, num, 1, groupId));
        end;
      end
      else if words[i].text = 'зачедин' then begin  //точно есть либо предмет либо пфио {надо доделать}
        if (GetElementUserWords('пфио', userWords) <> '') then begin
          num:= objTTeacher.FindAny( GetElementUserWords('пфио', userWords), 2, 0);
          str:= intToStr(takeFromArrGroup(4, num, 2, groupId));
        end
        else begin
          num:= objTLearntSubject.FindAny( GetElementUserWords('предмет', userWords), 1, 0);
          str:= intToStr(takeFromArrGroup(4, num, 1, groupId));
        end;
      end
      else if words[i].text = 'группафио' then begin
        arr1:= objTStudent.FilterAny(groupId, 2, 4); //фамилия
        arr2:= objTStudent.FilterAny(groupId, 2, 3);
        arr3:= objTStudent.FilterAny(groupId, 2, 5);
        for var j := Low(arr1) to High(arr1) do begin
          str:= str + intToStr(j+1) + '         ' + arr2[j] +
          ' ' + String(arr1[j])[1] + '. ' + String(arr3[j])[1] + '.' + sLineBreak;
        end;
      end
      else if words[i].text = 'фио' then begin
        str:= GetElementUserWords('фамилия', userWords) + ' ' +
        GetElementUserWords('имя', userWords) + ' ' +
        GetElementUserWords('отчество', userWords);
      end
      else if words[i].text = 'инициалы' then begin
        str:= GetElementUserWords('фамилия', userWords) + ' ' +
        GetElementUserWords('имя', userWords)[1] + '. ' +
        GetElementUserWords('отчество', userWords)[1] + '.';
      end;


      words[i].text:= str;
    end;
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
      result[index].fileWord:= Copy(myEdit.TextHint, 9, length(myEdit.TextHint)-8);
      result[index].userWord:= trim(myEdit.Text);
      inc(index);
    end;
  end;
  setLength(result, index);
end;

function checkEdit(): boolean;
var
  myEdit: TEdit;
  FirstName, SecondName, ThirdName: string;
  CheckName: boolean;
  arr: array[0..2] of TEdit;

function checkInputWord(Edit: TEdit): boolean;
var
  num: integer;
  strName: string;
begin
  result:= false;
  {'фио','допфио','предмет','моядата',
  'пересдач','телефон','печать', 'местопредъявления','видзанятий', $группа$, $ПФИО$
  }
  strName:= Copy(edit.TextHint, 9, length(edit.TextHint)-8);
  if (strName = 'имя') then begin
    FirstName:= edit.Text;
    result:= true;
    arr[0]:= edit;
    if (findGroupByName(FirstName, SecondName, ThirdName) <> -1) then CheckName:= true;
  end
  else if (strName = 'фамилия') then begin
    SecondName:= edit.Text;
    result:= true;
    arr[1]:= edit;
    if (findGroupByName(FirstName, SecondName, ThirdName) <> -1) then CheckName:= true;
  end
  else if (strName = 'отчество') then begin
    ThirdName:= edit.Text;
    result:= true;
    arr[2]:= edit;
    if (findGroupByName(FirstName, SecondName, ThirdName) <> -1) then CheckName:= true;
  end
  else if ((strName = 'допфио') or (strName = 'телефон') or (strName = 'печать')
  or (strName = 'местопредъявления') or (strName = 'видзанятий') or (strName = 'пересдач')
  or (strName = 'моядата')) and (edit.Text <> '') then result:= true
  else if (strName = 'пфио') and
  (objTTeacher.CheckAny( edit.Text, 2)) and (objTGroup.CheckAny( groupId, 0)) and
  (takeFromArrGroup(2, objTTeacher.FindAny( edit.Text, 2, 0), 2, groupId) <> -1)
    then result:= true
  else if (strName = 'предмет') and
  (objTLearntSubject.CheckAny( edit.Text, 1)) and (objTGroup.CheckAny( groupId, 0)) and
  (takeFromArrGroup(1, objTLearntSubject.FindAny( edit.Text, 1, 0), 1, groupId) <> -1)
    then result:= true
  else if (strName = 'группа') and (TryStrToInt(Trim(edit.Text), num))
  and (objTGroup.CheckAny( edit.Text, 0))
    then result:= true;
end;

begin
  result:= true;
  CheckName:= false;
  FirstName:= '';
  SecondName:= '';
  ThirdName:= '';
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
  //если первый элемент не nil тогда есть все элементы то есть есть фио
  if (CheckName = false) and (assigned(arr[0])) then begin
    for var i := Low(arr) to High(arr) do begin
      arr[i].Color:= $005858FF;
    end;
    result:= false;
  end;
end;



end.
