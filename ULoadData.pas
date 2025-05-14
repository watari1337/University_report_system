unit ULoadData;

interface

procedure loadDataFile();
procedure reLoadPattern();

implementation

uses DataBase, System.SysUtils;

//записывает все файлы txt из папки pattarn в массив result
function loadPattern(): TarrPattern;
const
  path: string = '.\Pattern\*.txt';
var
  searchResult: TSearchRec;
  i: integer;
begin
  SetLength(result, 10);
  i:= 0;
  if (FindFirst(path, FaAnyFile, searchResult) = 0) then begin
    try
      repeat
        if (i >= length(result)) then SetLength(result, length(result)*2);
        result[i]:= searchResult.Name;
        inc(i);
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

procedure reLoadPattern();
begin
  arrPattern:= loadPattern();
end;

procedure loadDataFile();
begin
  reLoadPattern();
  loadFileTTeacher();
  loadFileTStudent();
  loadFileTLearntSubject();
  loadFileTSpecialty();
  loadFileTGroup();
  loadFileTLearntForm();
  loadFileTFaculty();
end;

end.
