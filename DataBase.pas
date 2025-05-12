unit DataBase;

interface

uses System.SysUtils;

procedure loadData();

type
    {Pair<T1, T2> = Record
      id: T1;
      name: T2;
    End;}

    TLearntSubject = Record
      id: integer;
      name: string[100];
//      teacher: string[100];
    End;
    TTeacher = Record
      id: integer;
      name: string[255]; //должность + ФИО
    End;

    {Tpattern = Record
      id: integer;
      name: string[100];
    End;}
    TarrPattern = array of string;

//    TSemester = Record
//      value: integer;
//      group: array[1..40] of string[100]; //ФИО
//    End;

    TStudent = Record
      id: integer;  //группа + 2 цифры (номер студента )
      year: integer;
      //group: integer;
      name: String[100];
    End;

    TPairSabjectTeacher = Record
      sbj: integer;
      teacher: integer;
    End;

    TPairSemestrAndLearntSBJ = Record
      semestr: integer;
      numSBJ: integer;
      arrSbj: array[0..19] of TPairSabjectTeacher
    End;

    TGroup = Record
      id: integer;
      numSemestr: integer;
      arrSemestr: array[0..9] of TPairSemestrAndLearntSBJ;
    End;

    TSpecialty = Record
      id: integer;
      facultyId: integer;
      name: string[255];
//      semester: TSemester; //1-8
//      subjects: array[1..15] of TSubject;
    End;

    TLearntForm = Record
      id: integer;
      name: string[100];
    End;

    TFaculty = Record
      id: integer;
      name: string[255];
      decanName: string[60];    //в дательном падеже
      //spisiality: array[0..10] of TSpisiality;
    End;

    TallType = (LearntSubject, Teacher, Student, Group, Specialty, Faculty, LearntForm);
    Sarr = array of string;
    Iarr = array of integer;
    VarArr = array of variant;

    TCompare<T> = function(first, second: T): boolean;
    TAllToString<T> = function(element: T): string;

    BaseClass<T> = class
      private
        type
          AdrNode = ^ListNode;
          ListNode = Record   //создание узла связного списка для любого указаного при создании типа T
            inf: T;
            Next: AdrNode;
          End;
      private
        headList: AdrNode;
        //textForOut: string;
        listType: TallType;
        listType2: BaseClass<T>;
      public
        constructor Create(listTypeNow: TallType);
        destructor Destroy();
        procedure pushList(inf: T);
        procedure deleteNode(inf: integer{; func: Tcompare<T>});
        procedure createPageShowList({func: TAllToString<T>});
        function makeTitle(): Sarr;
        function ReadT(from: T): VarArr;
        procedure WriteT(from: VarArr; writeTo: T);
        function SameId(element1: T; element2ID: integer): boolean;
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
     Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls;

function BaseClass<T>.SameId(element1: T; element2ID: integer): boolean;
var
  {nowTeacher1: TTeacher absolute element1;
  nowLearntSubject1: TLearntSubject absolute element1;
  nowStudent1: TStudent absolute element1;
  nowGroup1: TGroup absolute element1;
  nowSpecialty1: TSpecialty absolute element1;
  nowLearntForm1: TLearntForm absolute element1;
  nowFaculty1: TFaculty absolute element1;

  nowTeacher2: TTeacher absolute element2;
  nowLearntSubject2: TLearntSubject absolute element2;
  nowStudent2: TStudent absolute element2;
  nowGroup2: TGroup absolute element2;
  nowSpecialty2: TSpecialty absolute element2;
  nowLearntForm2: TLearntForm absolute element2;
  nowFaculty2: TFaculty absolute element2;}

  myElement1: integer absolute element1;
begin
  result:= myElement1 = Element2ID;
end;

procedure BaseClass<T>.WriteT(from: VarArr; writeTo: T);
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
      nowTeacher.name:= from[1];
    end;
    LearntSubject: begin
      nowLearntSubject.id:= from[0];
      nowLearntSubject.name:= from[1];
    end;
    Student: begin
      nowStudent.id:= from[0];
      nowStudent.year:= from[1];
      nowStudent.name:= from[2];
    end;
    Group: begin
      nowGroup.id:= from[0];
      nowGroup.numSemestr:= from[1];
      //from[2]:= 'nill';
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
      SetLength(result, 2);
      result[0]:= nowTeacher.id;
      result[1]:= nowTeacher.name;
    end;
    LearntSubject: begin
      SetLength(result, 2);
      result[0]:= nowLearntSubject.id;
      result[1]:= nowLearntSubject.name;
    end;
    Student: begin
      SetLength(result, 3);
      result[0]:= nowStudent.id;
      result[1]:= nowStudent.year;
      result[2]:= nowStudent.name;
    end;
    Group: begin
      SetLength(result, 3);
      result[0]:= nowGroup.id;
      result[1]:= nowGroup.numSemestr;
      result[2]:= 'nill';
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

function BaseClass<T>.makeTitle(): Sarr;
begin
  case listType of
    Teacher: begin
      SetLength(result, 2);
      result[0]:= 'Id';
      result[1]:= 'Должность и ФИО';
    end;
    LearntSubject: begin
      SetLength(result, 2);
      result[0]:= 'Id';
      result[1]:= 'Название предмета';
    end;
    Student: begin
      SetLength(result, 3);
      result[0]:= 'Id';
      result[1]:= 'год поступления';
      result[2]:= 'ФИО';
    end;
    Group: begin
      SetLength(result, 3);
      result[0]:= 'Номер группы';
      result[1]:= 'Семестр';
      result[2]:= 'id предмета и id преподователя';
    end;
    Specialty: begin
      SetLength(result, 3);
      result[0]:= 'Id спец.';
      result[1]:= 'id факультета';
      result[2]:= 'Имя специальности';
    end;
    LearntForm: begin
      SetLength(result, 2);
      result[0]:= 'Id';
      result[1]:= 'Форма обучения';
    end;
    Faculty: begin
      SetLength(result, 3);
      result[0]:= 'Id';
      result[1]:= 'Факультет';
      result[2]:= 'Имя декана';
    end;
  end;
end;

constructor BaseClass<T>.Create(listTypeNow: TallType);
begin
  inherited Create;
  listType:= listTypeNow;
  if (headList = nil) then begin
    new(headList);
    headList^.Next:= nil;
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

procedure BaseClass<T>.pushList(inf: T);
var
  Node: AdrNode;
begin
  if (headList <> nil) then begin
    new(Node);
    Node^.inf:= inf;
    Node^.Next:= headList^.Next;
    headList^.Next:= Node;
  end;
end;

procedure BaseClass<T>.deleteNode(inf: integer{; func: Tcompare<T>});
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
      dispose(delNode);
    end
    else begin
      preNode:= curNode;
      curNode:= curNode^.Next;
    end;
  end;
  createPageShowList; //отрисовка заново
end;

procedure BaseClass<T>.createPageShowList({func: TAllToString<T>});
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
  {lbl:= TLabel.Create(MainForm.ScrollBoxInfo);
  lbl.Parent:= MainForm.ScrollBoxInfo;
  lbl.Caption:= textForOut;
  lbl.Font.Size:= 14;
  lbl.Left:= 40;
  lbl.Top:= 10;
  lbl.Height:= 40;}

  titles:= makeTitle;
  widths:= [70, 400, 200];
  LV:= MainForm.LVShowData;
  LV.Columns.Clear;
  for i:= 0 to length(titles)-1 do begin
    col:= LV.Columns.Add;
    col.Caption:= titles[i];
    col.Width:= widths[i];
  end;
  col.Width:= -2;

  Lv.Items.Clear;
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
  end;

  {with LV.Columns.Add do begin
    Caption:= 'проверак';
    width:= 100;
  end;}

  {
  width:= MainForm.LVShowData.ClientWidth;
  while (temp <> nil) do
  begin
    Btn := TBitBtn.Create(MainForm.ScrollBoxInfo);
    Btn.Parent := MainForm.ScrollBoxInfo;
    Btn.Left := 30;
    Btn.Top := I * 45 + 60;
    Btn.Width := width;
    Btn.Height := 40;
    Btn.Caption := func(temp^.inf);
    btn.Layout:= blGlyphLeft;
    Btn.Margin := 4; // Отступ от левого края
    Btn.OnClick:= MainForm.PatternButtonAction;
    temp:= temp^.Next;
    inc(i);
  end;}
end;




//записывает все файлы txt из папки pattarn в массив result
function loadPattern(): TarrPattern;
const
  path: string = '.\Pattern\*.txt';
var
  searchResult: TSearchRec;
  i: integer;
begin
  {if DirectoryExists(path) then begin

  end
  else showMessage('no data to read');}
  SetLength(result, 10);
  i:= 0;
  if (FindFirst(path, FaAnyFile, searchResult) = 0) then begin
    try
      repeat
        if (i >= length(result)) then SetLength(result, length(result)*2);
        //result[i].id:= i;
        result[i]:= searchResult.Name;
        inc(i);
        //showMessage(searchResult.Name);
      until FindNext(searchResult) <> 0;
    finally
      FindClose(searchResult);
    end;
  end;

end;

Procedure loadFileTTeacher();
var
   myFile: File of TTeacher;
   temp: TTeacher;
begin
  AssignFile(myFile, 'Data\Teacher');
  reSet(myFile);
  objTTeacher:= BaseClass<TTeacher>.Create(Teacher);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTTeacher.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTLearntSubject();
var
   myFile: File of TLearntSubject;
   temp: TLearntSubject;
begin
  AssignFile(myFile, 'Data\Subject');
  reSet(myFile);
  objTLearntSubject:= BaseClass<TLearntSubject>.Create(LearntSubject);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTLearntSubject.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTStudent();
var
   myFile: File of TStudent;
   temp: TStudent;
begin
  AssignFile(myFile, 'Data\Student');
  reSet(myFile);
  objTStudent:=  BaseClass<TStudent>.Create(Student);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTStudent.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTGroup();
var
   myFile: File of TGroup;
   temp: TGroup;
begin
  AssignFile(myFile, 'Data\Group');
  reSet(myFile);
  objTGroup:=  BaseClass<TGroup>.Create(Group);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTGroup.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTSpecialty();
var
   myFile: File of TSpecialty;
   temp: TSpecialty;
begin
  AssignFile(myFile, 'Data\Specialty');
  reSet(myFile);
  objTSpecialty:=  BaseClass<TSpecialty>.Create(Specialty);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTSpecialty.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTLearntForm();
var
   myFile: File of TLearntForm;
   temp: TLearntForm;
begin
  AssignFile(myFile, 'Data\LearntForm');
  reSet(myFile);
  objTLearntForm:=  BaseClass<TLearntForm>.Create(LearntForm);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTLearntForm.pushList(temp);
  end;
  CloseFile(myFile);
end;

Procedure loadFileTFaculty();
var
   myFile: File of TFaculty;
   temp: TFaculty;
begin
  AssignFile(myFile, 'Data\Faculty');
  reSet(myFile);
  objTFaculty:=  BaseClass<TFaculty>.Create(Faculty);
  while (not EOF(myFile)) do begin
    Read(myFile, temp);
    objTFaculty.pushList(temp);
  end;
  CloseFile(myFile);
end;

procedure loadData();
begin
  arrPattern:= loadPattern();
  loadFileTTeacher();
  loadFileTStudent();
  loadFileTLearntSubject();
  loadFileTSpecialty();
  loadFileTGroup();
  loadFileTLearntForm();
  loadFileTFaculty();
end;

end.
