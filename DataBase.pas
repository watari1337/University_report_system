unit DataBase;

interface

uses System.SysUtils;

type
    TLearntSubject = Record
      id: integer;
      name: string[100];
    End;

    TTeacher = Record
      id: integer;
      workStatus: string[255]; //должность
      name: string[255]; //ФИО
    End;

    TStudent = Record
      id: integer;  //группа + 3 цифры (номер студента )
      year: integer;
      group: integer;
      name: String[100];
    End;

    TSbjTeacher = Record
      id: integer;
      sbj: integer;
      teacher: integer;
      {typeSbj: integer; //лк пз лб}
      hour: integer; //часов изучения
      credits: integer;
    End;
    TArrSbjTch = array[0..40] of TSbjTeacher;

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
      decanName: string[60];    //в дательном падеже
    End;

    TallType = (LearntSubject, Teacher, Student, Group, Specialty, Faculty, LearntForm);
    TAllClasees = (Lk, Pz, lb);
    Sarr = array of string;
    Iarr = array of integer;
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
      public
        headList: AdrNode;
        listType: TallType;
        last: adrNode;

        constructor Create(listTypeNow: TallType);
        destructor Destroy();
        procedure pushList(inf: T);
        procedure pushEnd(inf: T);
        procedure deleteNode(inf: integer);
        procedure createPageShowList();
        function ReadT(from: T): VarArr;
        function Find(id: integer): T;
        function FindAny(element: variant; collum, num: integer): variant;
        function Read1(id, num: integer): variant;
        procedure WriteT(from: VarArr; var writeTo: T);
        procedure ChangeT(id: integer; from: VarArr);
        function SameId(element1: T; element2ID: integer): boolean;
        function GetByIndex(num: integer): T;
        function Count: integer;
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
      nowTeacher.name:= from[2];
    end;
    LearntSubject: begin
      nowLearntSubject.id:= from[0];
      nowLearntSubject.name:= from[1];
    end;
    Student: begin
      nowStudent.id:= from[0];
      nowStudent.year:= from[1];
      nowStudent.group:= from[2];
      nowStudent.name:= from[3];
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
      nowFaculty.decanName:= from[2];
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
      SetLength(result, 3);
      result[0]:= nowTeacher.id;
      result[1]:= nowTeacher.workStatus;
      result[2]:= nowTeacher.name;
    end;
    LearntSubject: begin
      SetLength(result, 2);
      result[0]:= nowLearntSubject.id;
      result[1]:= nowLearntSubject.name;
    end;
    Student: begin
      SetLength(result, 4);
      result[0]:= nowStudent.id;
      result[1]:= nowStudent.year;
      result[2]:= nowStudent.group;
      result[3]:= nowStudent.name;
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
      SetLength(result, 2);
      result[0]:= nowLearntForm.id;
      result[1]:= nowLearntForm.name;
    end;
    Faculty: begin
      SetLength(result, 3);
      result[0]:= nowFaculty.id;
      result[1]:= nowFaculty.name;
      result[2]:= nowFaculty.decanName;
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

function BaseClass<T>.FindAny(element: variant; collum, num: integer): variant;
var
  Node: AdrNode;
  noStop: boolean;
begin
  Node:= headList^.Next;
  noStop:= true;
  while (Node <> nil) and (noStop) do begin
    if (ReadT(Node^.inf)[collum] = element) then begin
      noStop:= false;
      result:= ReadT(Node^.inf)[num];
    end;
    Node:= Node^.Next;
  end;
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
  MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count+1;
  MainForm.LVShowData.Invalidate;
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

  MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count+1;
  MainForm.LVShowData.Invalidate;
end;

procedure BaseClass<T>.deleteNode(inf: integer);
var
  curNode, preNode, delNode: AdrNode;
begin
  curNode:= headList^.Next;
  preNode:= headList;
  while (curNode <> nil) do begin
    if (SameID(curNode^.inf, inf)) then begin
      preNode^.Next:= curNode^.Next;
      delNode:= curNode;
      curNode:= curNode^.Next;
      if (delNode = last) then last:= preNode;
      dispose(delNode);
    end
    else begin
      preNode:= curNode;
      curNode:= curNode^.Next;
    end;
  end;
  //createPageShowList; //отрисовка заново
  MainForm.LVShowData.Items.Count:= MainForm.LVShowData.Items.Count-1;
  MainForm.LVShowData.SetFocus;
  MainForm.LVShowData.Invalidate;
end;

procedure BaseClass<T>.createPageShowList();
var
  btn: TBitBtn;
  lbl: TLabel;
  LV: TListView;
  col: TListColumn;
  i, width: integer;
  temp: AdrNode;
  titles: SArr;
  widths: Iarr;
  elements: VarArr;
  item: TListItem;
begin
  titles:= makeTitle(listType);
  widths:= [90, 300, 200, 100];
  LV:= MainForm.LVShowData;
  LV.Columns.Clear;
  for i:= 0 to length(titles)-1 do begin
    col:= LV.Columns.Add;
    col.Caption:= titles[i];
    col.Width:= widths[i];
  end;
  col.Width:= -2;

  Lv.Items.Count:= Count;

  {Lv.Items.Clear;
  temp:= headList^.Next;
  while (temp <> nil) do
  begin
    elements:= ReadT(temp^.inf);
    item:= LV.Items.add;
    item.Caption:= elements[0];
    for i := 1 to Length(elements)-1 do begin
      item.SubItems.Add(elements[i]);
    end;
    temp:= temp^.Next;
  end;}
end;

end.
