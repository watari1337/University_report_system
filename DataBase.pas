unit DataBase;

interface

uses System.SysUtils;

const
  NArrSbjTch = 40;

type
    TLearntSubject = Record
      id: integer;
      name: string[100];
    End;

    TTeacher = Record
      id: integer;
      workStatus: string[255]; //должность
      FirstName: string[40];   //ФИО
      SecondName: string[40];
      ThirdName: string[40];
    End;

    TStudent = Record
      id: integer;  //группа + 3 цифры (номер студента )
      year: integer;
      group: integer;
      FirstName: string[40];
      SecondName: string[40];
      ThirdName: string[40];
    End;

    TSbjTeacher = Record
      id: integer;
      sbj: integer;
      teacher: integer;
      hour: integer; //часов изучения
      credits: integer;
      {typeSbj: integer; //лк пз лб}
    End;
    PArrSbjTch = ^TArrSbjTch;
    TArrSbjTch = array[0..NArrSbjTch] of TSbjTeacher;

    TGroup = Record
      id: integer; //номер группы
      numStudent: integer;
      numSBJ: integer;
      arrSbj: TArrSbjTch;
    End;

    TSpecialty = Record
      id: integer;
      facultyId: integer;
      name: string[255];
    End;

    TLearntForm = Record
      id: integer;
      name: string[100];
    End;

    TFaculty = Record
      id: integer;
      name: string[255];
      FirstName: string[40];
      SecondName: string[40];
      ThirdName: string[40];
    End;

    IPair = Record
      first: integer;
      second: integer;
    end;

    TallType = (LearntSubject, Teacher, Student, Group, Specialty, Faculty, LearntForm);
    TAllClasees = (Lk, Pz, lb);
    Sarr = array of string;
    Iarr = array of integer;
    IPairArr = array of IPair;
    VarArr = array of variant;
    TarrPattern = array of string;

    BaseClass<T> = class
      private

      public
        type
          AdrNode = ^ListNode;
          ListNode = Record   //создание узла связного списка для любого указаного при создании типа T
            inf: T;
            Next: AdrNode;
          End;
      private
        procedure DoAfterAdd(inf: T);
        procedure DoAfterDelete(inf: T);
      public
        headList: AdrNode;
        listType: TallType;
        last: adrNode;
        LastId: integer;

        constructor Create(listTypeNow: TallType);
        destructor Destroy();
        procedure pushList(inf: T);
        procedure pushEnd(inf: T);
        procedure deleteNode(id: integer);
        procedure createPageShowList();
        function ReadT(from: T): VarArr;
        function Find(id: integer): T;
        function FindAny(id: variant; collum, num: integer): variant;
        function FilterAny(id: variant; collum, num: integer): VarArr;
        function CheckAny(element: variant; collum: integer): boolean;
        function Read1(id, num: integer): variant;
        procedure WriteT(from: VarArr; var writeTo: T);
        procedure WriteAny(id, collum, num: integer; element: variant);
        procedure ChangeT(id: integer; from: VarArr);
        function SameId(element1: T; element2ID: integer): boolean;
        function GetByIndex(num: integer): T;
        function Count: integer;
        function FreeId: integer;
    end;

    //это для типизированного файла, а в проге ещё в каждом должен быть адрес
    //элемента выше, чтобы зная студента можно было определять его семестр и предметы
    
var
  arrPattern: TArrPattern;
  objTTeacher: BaseClass<TTeacher>;
  objTLearntSubject: BaseClass<TLearntSubject>;
  objTStudent : BaseClass<TStudent>;
  objTGroup: BaseClass<TGroup>;
  objTSpecialty: BaseClass<TSpecialty>;
  objTLearntForm: BaseClass<TLearntForm>;
  objTFaculty: BaseClass<TFaculty>;
  workObjNow: TallType;

implementation

uses mainCodeForm, Vcl.Dialogs, Vcl.Graphics, Vcl.StdCtrls,
     Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, WorkWithData;

function BaseClass<T>.SameId(element1: T; element2ID: integer): boolean;
var
  myElement1: integer absolute element1;
begin
  result:= myElement1 = Element2ID;
end;

procedure BaseClass<T>.WriteAny(id, collum, num: integer; element: variant);
var
  Node: AdrNode;
  noStop: boolean;
  arr: VarArr;
begin
  Node:= headList^.Next;
  noStop:= true;
  while (Node <> nil) and (noStop) do begin
    arr:= ReadT(Node^.inf);
    if (arr[collum] = id) then begin
      noStop:= false;
      arr[num]:= element;
      writeT(arr, Node^.inf);
    end;
    Node:= Node^.Next;
  end;
end;

procedure BaseClass<T>.WriteT(from: VarArr; var writeTo: T);
var
  nowTeacher: TTeacher absolute writeTo;
  nowLearntSubject: TLearntSubject absolute writeTo;
  nowStudent: TStudent absolute writeTo;
  nowGroup: TGroup absolute writeTo;
  nowSpecialty: TSpecialty absolute writeTo;
  nowLearntForm: TLearntForm absolute writeTo;
  nowFaculty: TFaculty absolute writeTo;
begin
  case listType of
    Teacher: begin
      nowTeacher.id:= from[0];
      nowTeacher.workStatus:= from[1];
      nowTeacher.FirstName:= from[2];
      nowTeacher.SecondName:= from[3];
      nowTeacher.ThirdName:= from[4];
    end;
    LearntSubject: begin
      nowLearntSubject.id:= from[0];
      nowLearntSubject.name:= from[1];
    end;
    Student: begin
      nowStudent.id:= from[0];
      nowStudent.year:= from[1];
      nowStudent.group:= from[2];
      nowStudent.FirstName:= from[3];
      nowStudent.SecondName:= from[4];
      nowStudent.ThirdName:= from[5];
    end;
    Group: begin
      nowGroup.id:= from[0];
      nowGroup.numStudent:= from[1];
      nowGroup.numSBJ:= from[2];
    end;
    Specialty: begin
      nowSpecialty.id:= from[0];
      nowSpecialty.facultyId:= from[1];
      nowSpecialty.name:= from[2];
    end;
    LearntForm: begin
      nowLearntForm.id:= from[0];
      nowLearntForm.name:= from[1];
    end;
    Faculty: begin
      nowFaculty.id:= from[0];
      nowFaculty.name:= from[1];
      nowFaculty.FirstName:= from[2];
      nowFaculty.SecondName:= from[3];
      nowFaculty.ThirdName:= from[4];
    end;
  end;
end;

function BaseClass<T>.Read1(id, num: integer): variant;
begin
  result:= ReadT(Find(id))[num];
end;

function BaseClass<T>.ReadT(from: T): VarArr;
var
  nowTeacher: TTeacher absolute from;
  nowLearntSubject: TLearntSubject absolute from;
  nowStudent: TStudent absolute from;
  nowGroup: TGroup absolute from;
  nowSpecialty: TSpecialty absolute from;
  nowLearntForm: TLearntForm absolute from;
  nowFaculty: TFaculty absolute from;
begin
  case listType of
    Teacher: begin
      result:= [nowTeacher.id, nowTeacher.workStatus,
      nowTeacher.FirstName, nowTeacher.SecondName, nowTeacher.ThirdName];
    end;
    LearntSubject: begin
      SetLength(result, 2);
      result[0]:= nowLearntSubject.id;
      result[1]:= nowLearntSubject.name;
    end;
    Student: begin
      SetLength(result, 6);
      result[0]:= nowStudent.id;
      result[1]:= nowStudent.year;
      result[2]:= nowStudent.group;
      result[3]:= nowStudent.FirstName;
      result[4]:= nowStudent.SecondName;
      result[5]:= nowStudent.ThirdName;
    end;
    Group: begin
      SetLength(result, 3);
      result[0]:= nowGroup.id;
      result[1]:= nowGroup.numStudent;
      result[2]:= nowGroup.numSBJ;
    end;
    Specialty: begin
      SetLength(result, 3);
      result[0]:= nowSpecialty.id;
      result[1]:= nowSpecialty.facultyId;
      result[2]:= nowSpecialty.name;
    end;
    LearntForm: begin
      result:= [nowLearntForm.id, nowLearntForm.name];
    end;
    Faculty: begin
      result:= [nowFaculty.id, nowFaculty.name,
      nowFaculty.FirstName, nowFaculty.SecondName, nowFaculty.ThirdName];
    end;
  end;
end;

procedure BaseClass<T>.ChangeT(id: integer; from: VarArr);
var
  temp: AdrNode;
  noStop: boolean;
begin
  temp:= headList^.Next;
  noStop:= true;
  while (temp <> nil) and (noStop) do begin
    if (SameId(temp^.inf, id)) then begin
      noStop:= false;
      writeT(from, temp^.inf);
    end;
    temp:= temp^.Next;
  end;
  MainForm.LVShowData.SetFocus;
  MainForm.LVShowData.Invalidate;
end;

function BaseClass<T>.CheckAny(element: variant; collum: integer): boolean;
var
  Node: AdrNode;
  noStop: boolean;
begin
  result:= false;
  Node:= headList^.Next;
  noStop:= true;
  while (Node <> nil) and (noStop) do begin
    if (ReadT(Node^.inf)[collum] = element) then begin
      noStop:= false;
      result:= true;
    end;
    Node:= Node^.Next;
  end;
end;

function BaseClass<T>.Count: integer;
var
  node: AdrNode;
begin
  node:= headList^.Next;
  result:= 0;
  while node <> nil do begin
    inc(result);
    node:= node^.Next;
  end;
end;

constructor BaseClass<T>.Create(listTypeNow: TallType);
begin
  inherited Create;
  lastId:= 0;
  listType:= listTypeNow;
  if (headList = nil) then begin
    new(headList);
    headList^.Next:= nil;
    last:= headList;
  end;
end;

destructor BaseClass<T>.Destroy();
var
  Node: AdrNode;
begin
  while (headList <> nil) do begin
    Node:= headList;
    headList:= headList^.Next;
    dispose(Node);
  end;
  inherited;
end;

function BaseClass<T>.FilterAny(id: variant; collum, num: integer): VarArr;
var
  Node: AdrNode;
  index: integer;
begin
  Node:= headList^.Next;
  setLength(result, 10);
  index:= 0;
  while (Node <> nil) do begin
    if (ReadT(Node^.inf)[collum] = id) then begin
      if (index >= length(result)) then setLength(result, Length(result)*2);
      result[index]:= ReadT(Node^.inf)[num];
      inc(index);
    end;
    Node:= Node^.Next;
  end;
  setLength(result, index);
end;

function BaseClass<T>.Find(id: integer): T;
var
  Node: AdrNode;
  noStop: boolean;
begin
  Node:= headList^.Next;
  noStop:= true;
  while (Node <> nil) and (noStop) do begin
    if (SameId(Node^.inf, id)) then begin
      noStop:= false;
      result:= Node^.inf;
    end;
    Node:= Node^.Next;
  end;
end;

//элемент, колонка в которой ищет, колонка из которой взять
function BaseClass<T>.FindAny(id: variant; collum, num: integer): variant;
var
  Node: AdrNode;
  noStop: boolean;
begin
  result:= '';
  Node:= headList^.Next;
  noStop:= true;
  while (Node <> nil) and (noStop) do begin
    if (ReadT(Node^.inf)[collum] = id) then begin
      noStop:= false;
      result:= ReadT(Node^.inf)[num];
    end;
    Node:= Node^.Next;
  end;
end;

function BaseClass<T>.FreeId: integer;
var
  arr: array of boolean;
  Node: AdrNode;
  i: integer;
begin
  setLength(arr, lastId+1);
  for i := Low(arr) to High(arr) do arr[i]:= false;
  node:= headList^.Next;
  while (Node <> nil) do begin
    arr[Integer(ReadT(Node^.inf)[0])]:= true;
    Node:= Node^.Next;
  end;
  i:= 0;
  while (arr[i]) do inc(i);
  result:= i;
end;

function BaseClass<T>.GetByIndex(num: integer): T;
var
  Node: AdrNode;
begin
  node:= headList^.Next;
  for var i := 1 to num do begin
    node:= node^.Next;
  end;
  result:= node^.inf;
end;

procedure BaseClass<T>.DoAfterAdd(inf: T);
var
  nowId: integer;
  arr: varArr;
begin
  nowId:= ReadT(inf)[0];
  if (lastId < nowId) then lastId:= nowId;

  if (ListType = Student) then begin
    nowId:= objTGroup.FindAny(ReadT(inf)[2], 0, 1)+1;
    objTGroup.WriteAny(ReadT(inf)[2], 0, 1, nowId);
  end;

  MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count+1;
  MainForm.LVShowData.Selected:= nil;
  MainForm.LVShowData.Invalidate;
end;

procedure BaseClass<T>.pushEnd(inf: T);
var
  Node: AdrNode;
begin
  if (headList <> nil) then begin
    new(Node);
    Node^.inf:= inf;
    last^.Next:= Node;
    Node^.Next:= nil;
    last:= Node;
  end;
  DoAfterAdd(inf);
end;

procedure BaseClass<T>.pushList(inf: T);
var
  Node: AdrNode;
begin
  if (headList <> nil) then begin
    new(Node);
    Node^.inf:= inf;
    Node^.Next:= headList^.Next;
    headList^.Next:= Node;
    if (last = headList) then last:= headList^.Next;
  end;
  DoAfterAdd(inf);
end;

procedure BaseClass<T>.DoAfterDelete(inf: T);
var
  arr: IPairArr;
  anyArr: varArr;
  num, id: integer;
  firstDelete: boolean;
begin
  firstDelete:= false;
  if (workObjNow = LearntSubject) and (listType = LearntSubject) then begin
    firstDelete:= true;
    arr:= findGroupArr(ReadT(inf)[0], 1);
    for var i := Low(arr) to High(arr) do begin
      DeleteGroupArrAny(arr[i].first, arr[i].second-1);
    end;
  end
  else if (workObjNow = Teacher) and (listType = Teacher) then begin
    firstDelete:= true;
    arr:= findGroupArr(ReadT(inf)[0], 2);
    for var i := Low(arr) to High(arr) do begin
      DeleteGroupArrAny(arr[i].first, arr[i].second-1);
    end;
  end
  else if (workObjNow = Student) and (listType = Student) then begin
    firstDelete:= true;
    id:= ReadT(inf)[2]; //group
    num:= objTGroup.FindAny(id, 0, 1);
    objTGroup.WriteAny(id, 0, 1, num-1);
  end
  else if (workObjNow = Group) and (listType = Group) then begin
    firstDelete:= true;
    id:= ReadT(inf)[0]; //group
    anyArr:= objTStudent.FilterAny(id, 2, 0);
    for var i := Low(anyArr) to High(anyArr) do begin
      objTStudent.deleteNode(anyArr[i]);
    end;
  end;

  if (firstDelete) then begin
    //отрисовка заново
    MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count-1;
    MainForm.LVShowData.SetFocus;
    MainForm.LVShowData.Invalidate;
  end;
end;

procedure BaseClass<T>.deleteNode(id: integer);
var
  curNode, preNode, delNode: AdrNode;
  Stop: boolean;
begin
  stop:= false;
  curNode:= headList^.Next;
  preNode:= headList;
  while (curNode <> nil) and (stop = false) do begin
    if (SameID(curNode^.inf, id)) then begin
      preNode^.Next:= curNode^.Next;
      delNode:= curNode;
      curNode:= curNode^.Next;
      if (delNode = last) then last:= preNode;
      DoAfterDelete(delNode^.inf);
      dispose(delNode);
      stop:= true;
    end
    else begin
      preNode:= curNode;
      curNode:= curNode^.Next;
    end;
  end;
end;

procedure BaseClass<T>.createPageShowList();
var
  LV: TListView;
  col: TListColumn;
  i, width: integer;
  titles: SArr;
  widths: Iarr;
begin
  titles:= makeTitle(listType);
  case listType of
    Teacher: widths:= [60, 120, 160, 160, 160];
    LearntSubject: widths:= [60, 200];
    Student: widths:= [90, 70, 90, 160, 160, 160];
    Group: widths:= [140, 160, 160];
    Specialty: widths:= [100, 120, 400];
    LearntForm: widths:= [60, 200];
    Faculty: widths:= [60, 150, 160, 160, 160];
  end;
  LV:= MainForm.LVShowData;
  Lv.Items.Count:= Count;
  LV.Columns.Clear;
  for i:= 0 to length(titles)-1 do begin
    col:= LV.Columns.Add;
    col.Caption:= titles[i];
    col.Width:= widths[i];
  end;
  col.Width:= -2;
end;

end.
