unit WorkWithData;

interface

uses DataBase;

function makeTitle(listType: TAllType): Sarr;
procedure GenerCodeHint(var controlCode: Iarr; var hint: SArr);
procedure PushListT(element: VarArr);
function findGroupByName(FirstName, SecondName, ThirdName: string): integer;
function GetArrDataFromGroup(id: integer): PArrSbjTch;
function takeFromArrGroup(num, id, collum, group: integer): integer;
procedure pushGroupArr(group: integer; inf: varArr);
procedure DeleteGroupArrAny(group, id: integer);
function findGroupArr(id: variant; collum: integer): IPairArr;
procedure EditData(group, index: integer; inf: varArr);

implementation

uses mainCodeForm, BasicFunction;

//среди всех групп ищет элемент равный id в колонце collume
function findGroupArr(id: variant; collum: integer): IPairArr;
var
  node: BaseClass<TGroup>.AdrNode;
  arr: TArrSbjTch;
  fastCase: VarArr;
  index: integer;
begin
  result:= nil;
  SetLength(result, 10);
  index:= 0;
  node:= objTGroup.headList^.Next;
  while (node <> nil) do begin
    arr:= node^.inf.arrSbj;
    for var i := node^.inf.numSBJ downto 0 do begin   //important from last to first
      fastCase:= [arr[i].id, arr[i].sbj, arr[i].teacher, arr[i].hour, arr[i].credits];
      if (id = fastCase[collum]) then begin 
        if (index >= length(result)) then SetLength(result, Length(result)*2);        
        result[index].first:= node^.inf.id;
        result[index].second:= arr[i].id;
        inc(index);
      end;   
    end;
    node:= node^.Next;
  end;
  SetLength(result, index);
end;

procedure EditData(group, index: integer; inf: varArr);
var
  arr: PArrSbjTch;
  item: TSbjTeacher;
begin
  arr:= GetArrDataFromGroup(group);
  item.id:= index+1;
  item.sbj:= inf[1];
  item.teacher:= inf[2];
  item.hour:= inf[3];
  item.credits:= inf[4];
  arr^[index]:= item;

  MainForm.LVShowData.SetFocus;
  MainForm.LVShowData.Invalidate;
end;

//допущение, код группы в MainForm.LVShowData.tag
procedure pushGroupArr(group: integer; inf: varArr);
var
  arr: PArrSbjTch;
  item: TSbjTeacher;
  elements: integer;
begin
  arr:= GetArrDataFromGroup(group);
  elements:= objTGroup.FindAny(group, 0, 2); //кнопка не рабоатет если элементов слишком много
  item.id:= elements+1;
  item.sbj:= inf[1];
  item.teacher:= inf[2];
  item.hour:= inf[3];
  item.credits:= inf[4];
  arr^[elements]:= item;
  inc(elements);
  objTGroup.WriteAny(group, 0, 2, elements);

  MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count+1;
  MainForm.LVShowData.Invalidate;
end;

procedure DeleteGroupArrAny(group, id: integer);
var
  arr: PArrSbjTch;
  item: TSbjTeacher;
  elements: integer;
begin
  arr:= GetArrDataFromGroup(group);
  elements:= objTGroup.FindAny(group, 0, 2);
  dec(elements);
  for var i := id to elements do begin
    arr^[i+1].id:= arr^[i+1].id-1;
    arr^[i]:= arr^[i+1];
  end;
  objTGroup.WriteAny(group, 0, 2, elements);

  if (MainForm.LVShowData.tag = -1) and (workObjNow = TAllType(3)) then begin
    MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count-1;
    MainForm.LVShowData.SetFocus;
    MainForm.LVShowData.Invalidate;
  end;  
end;

function GetArrDataFromGroup(id: integer): PArrSbjTch;
var
  node: BaseClass<TGroup>.AdrNode;
begin
  node:= objTGroup.headList^.Next;
  while (node <> nil) do begin
    if (id = node^.inf.id) then begin   //0 номер группы
      result:= @node^.inf.arrSbj;
      break;
    end;
    node:= node^.Next;
  end;
end;

{num колонка из которой взять результат, id строчка которая нам нужна,
id это элемент колонки collums, group группа с которой работаем}
function takeFromArrGroup(num, id, collum, group: integer): integer;
var
  arr: TArrSbjTch;
  i: integer;
  notStop: boolean;
begin
  result:= -1;
  arr:= GetArrDataFromGroup(group)^;
  i:= Low(arr);
  notStop:= true;
  while (i < High(arr)) and (notStop) do begin
    case collum of
      1: if (arr[i].sbj = id) then notStop:= false;
      2: if (arr[i].teacher = id) then notStop:= false;
    end;
    inc(i);
  end;
  dec(i);
  if (notStop = false) then begin
    case num of
      0: result:= arr[i].id;
      1: result:= arr[i].sbj;
      2: result:= arr[i].teacher;
      {3: result:= arr[i].typeSbj;}
      3: result:= arr[i].hour;
      4: result:= arr[i].credits;
    end;
  end;
end;

function findGroupByName(FirstName, SecondName, ThirdName: string): integer;
var
  node: BaseClass<TStudent>.AdrNode;
begin
  node:= objTStudent.headList^.Next;
  result:= -1;
  while (node <> nil) do begin
    if  (FLowerRus(FirstName) = FLowerRus(node^.inf.FirstName))
    and (FLowerRus(SecondName) = FLowerRus(node^.inf.SecondName))
    and (FLowerRus(ThirdName) = FLowerRus(node^.inf.ThirdName)) then begin   //3 имя
      result:= node^.inf.group;
      break;
    end;
    node:= node^.Next;
  end;
end;

function makeTitle(listType: TAllType): Sarr;
begin
  if (MainForm.LVShowData.tag = -1) then begin
    case listType of
      Teacher: result:= ['Id', 'Должность', 'имя', 'фамилия', 'отчество'];
      LearntSubject: result:= ['Id', 'Название предмета'];
      Student: result:= ['Id студента', 'год поступления', 'группа', 'имя', 'фамилия', 'отчество'];
      Group: result:= ['Номер группы', 'студентов в группе', 'предметов изучают'];
      Specialty: result:= ['Id спец.', 'id факультета', 'Имя специальности'];
      LearntForm: result:= ['Id', 'Форма обучения'];
      Faculty: result:= ['Id', 'Факультет', 'имя декана', 'фамилия декана', 'отчество декана'];
    end;
  end
  else begin
    case listType of
      Group: result:= ['номер', 'id предмета','id учителя','часов', 'credits'];
    end;
  end;
end;

procedure GenerCodeHint(var controlCode: Iarr; var hint: SArr);
begin
  if (MainForm.LVShowData.tag = -1) then begin
    case workObjNow of  //0 nothing, 1 numberInput, 2 stringInput
      Teacher: controlCode:= [0, 2, 2, 2, 2];
      LearntSubject: controlCode:= [0, 2];
      Student: controlCode:= [0, 1, 1, 2, 2, 2];
      Group: controlCode:= [1, 0, 0];
      Specialty: controlCode:= [0, 1, 2];
      LearntForm: controlCode:= [0, 2];
      Faculty: controlCode:= [0, 2, 2, 2, 2];
    end;
  end
  else begin
    case workObjNow of
      Group: controlCode:= [0, 1, 1, 1, 1];
    end;
  end;
  hint:= makeTitle(workObjNow);
end;


procedure PushListT(element: VarArr);
var
  nowTeacher: TTeacher;
  nowLearntSubject: TLearntSubject;
  nowStudent: TStudent;
  nowGroup: TGroup;
  nowSpecialty: TSpecialty;
  nowLearntForm: TLearntForm;
  nowFaculty: TFaculty;
begin
  case workObjNow of
    Teacher: begin
      objTTeacher.WriteT(element, nowTeacher);
      objTTeacher.pushList(nowTeacher);
    end;
    LearntSubject: begin
      objTLearntSubject.WriteT(element, nowLearntSubject);
      objTLearntSubject.pushList(nowLearntSubject);
    end;
    Student: begin
      objTStudent.WriteT(element, nowStudent);
      objTStudent.pushList(nowStudent);
    end;
    Group: begin
      objTGroup.WriteT(element, nowGroup);
      objTGroup.pushList(nowGroup);
    end;
    Specialty: begin
      objTSpecialty.WriteT(element, nowSpecialty);
      objTSpecialty.pushList(nowSpecialty);
    end;
    LearntForm: begin
      objTLearntForm.WriteT(element, nowLearntForm);
      objTLearntForm.pushList(nowLearntForm);
    end;
    Faculty: begin
      objTFaculty.WriteT(element, nowFaculty);
      objTFaculty.pushList(nowFaculty);
    end;
  end;
end;

end.
