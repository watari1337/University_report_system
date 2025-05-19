unit WorkWithData;

interface

uses DataBase;

function makeTitle(listType: TAllType): Sarr;
procedure PushListT(element: VarArr);
function findGroupByName(realName: string): integer;
function GetArrDataFromGroup(id: integer): TArrSbjTch;
function takeFromArrGroup(num, id, collum, group: integer): integer;

implementation

function GetArrDataFromGroup(id: integer): TArrSbjTch;
var
  node: BaseClass<TGroup>.AdrNode;
begin
  node:= objTGroup.headList^.Next;
  while (node <> nil) do begin
    if (id = node^.inf.id) then begin   //0 номер группы
      result:= node^.inf.arrSbj;
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
  arr:= GetArrDataFromGroup(group);
  i:= Low(arr);
  notStop:= true;
  while (i < High(arr)) and (notStop) do begin
    case collum of
      1: if (arr[i].sbj = id) then notStop:= false;
      2: if (arr[i].teacher = id) then notStop:= false;
    end;
    inc(i);
  end;
  case num of
    0: result:= arr[i].id;
    1: result:= arr[i].sbj;
    2: result:= arr[i].teacher;
    {3: result:= arr[i].typeSbj;}
    3: result:= arr[i].hour;
    4: result:= arr[i].credits;
  end;
end;

function findGroupByName(realName: string): integer;
var
  node: BaseClass<TStudent>.AdrNode;
begin
  node:= objTStudent.headList^.Next;
  result:= -1;
  while (node <> nil) do begin
    if (realName = node^.inf.name) then begin   //3 имя
      result:= node^.inf.group;
      break;
    end;
    node:= node^.Next;
  end;
end;

function makeTitle(listType: TAllType): Sarr;
begin
  case listType of
    Teacher: result:= ['Id', 'Должность', 'ФИО'];
    LearntSubject: result:= ['Id', 'Название предмета'];
    Student: result:= ['Id студента', 'год поступления', 'группа', 'ФИО'];
    Group: result:= ['Номер группы', 'студентов в группе', 'предметов изучают'];
    Specialty: result:= ['Id спец.', 'id факультета', 'Имя специальности'];
    LearntForm: result:= ['Id', 'Форма обучения'];
    Faculty: result:= ['Id', 'Факультет', 'Имя декана'];
  end;
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
