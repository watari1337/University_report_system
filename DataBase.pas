unit DataBase;

interface

uses System.SysUtils;

procedure loadData();

type
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
      year: integer;
      id: integer;  //группа + 2 цифры (номер студента )
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

    Tcompare<T> = function (first, second: T): boolean;

    BaseClass<T> = class
      private
        type
          ListNode = Record   //создание узла связного списка для любого указаного при создании типа T
            inf: T;
            Next: ^ListNode;
          End;
      private
        headList: ^ListNode;
        textForOut: string;
      public
        constructor Create(strForOut: string);
        destructor Destroy();
        procedure pushList(inf: T);
        procedure deleteNode(inf: T; func: Tcompare<T>);
        procedure createPageShowList();
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

implementation

uses mainCodeForm, Vcl.Dialogs, Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls;

constructor BaseClass<T>.Create(strForOut: string);
begin
  //inherited;
  textForOut:= strForOut;
  if (headList = nil) then begin
    new(headList);
    headList^.Next:= nil;
  end;
end;

destructor BaseClass<T>.Destroy();
var
  Node: ^ListNode;
begin
  while (headList <> nil) do begin
    Node:= headList;
    headList:= headList^.Next;
    dispose(Node);
  end;
  //inherited;
end;

procedure BaseClass<T>.pushList(inf: T);
var
  Node: ^ListNode;
begin
  if (headList <> nil) then begin
    new(Node);
    Node^.inf:= inf;
    Node^.Next:= headList^.Next;
    headList^.Next:= Node;
  end;
end;

procedure BaseClass<T>.deleteNode(inf: T; func: Tcompare<T>);
var
  curNode, preNode, delNode: ^ListNode;
begin
  curNode:= headList;
  while (curNode <> nil) do begin
    preNode:= curNode;
    curNode:= curNode^.Next;
    if (func(curNode^.inf, inf)) then begin
      preNode^.Next:= curNode^.Next;
      delNode:= curNode;
      dispose(delNode);
    end;
  end;
end;

procedure BaseClass<T>.createPageShowList();
var
  btn: TButton;
  lbl: TLabel;
  i: integer;
  temp: ^ListNode;
begin
  lbl:= TLabel.Create(MainForm.ScrollBoxInfo);
  lbl.Parent:= MainForm.ScrollBoxInfo;
  lbl.Caption:= textForOut;
  lbl.Font.Size:= 14;
  lbl.Left:= 20;
  lbl.Top:= 10;
  lbl.Height:= 40;

  i:= 0;
  temp:= headList;
  while (temp <> nil) do
  begin
    Btn := TButton.Create(MainForm.ScrollBoxInfo);
    Btn.Parent := MainForm.ScrollBoxInfo;
    Btn.Left := 20;
    Btn.Top := I * 45 + 60;
    Btn.Width := MainForm.ScrollBoxInfo.ClientWidth - 20;
    Btn.Height := 40;
    //Btn.Caption := temp^.inf;
    Btn.OnClick:= MainForm.PatternButtonAction;
    temp:= temp^.Next;
    inc(i);
  end;
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
  objTTeacher:= BaseClass<TTeacher>.Create('Id       Должность и ФИО');
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
  objTLearntSubject:= BaseClass<TLearntSubject>.Create('Id       Название предмета');
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
  objTStudent:=  BaseClass<TStudent>.Create('Id    Поступил       ФИО');
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
  objTGroup:=  BaseClass<TGroup>.Create('Id    Семестр       id предмета и id преподователя');
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
  objTSpecialty:=  BaseClass<TSpecialty>.Create('Id    id факультета      Имя декана');
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
  objTLearntForm:=  BaseClass<TLearntForm>.Create('Id    Форма обучения');
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
  objTFaculty:=  BaseClass<TFaculty>.Create('Id    Факультет      Имя декана');
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
