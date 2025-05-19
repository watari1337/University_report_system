unit SaveData;

interface

procedure SaveDataFile();

implementation

uses dataBase;

Procedure SaveFileTTeacher();
var
   myFile: File of TTeacher;
   temp: TTeacher;
   node: BaseClass<TTeacher>.AdrNode;
begin
  AssignFile(myFile, 'Data\Teacher');
  reWrite(myFile);
  node:= objTTeacher.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node:= node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTLearntSubject();
var
   myFile: File of TLearntSubject;
   node: BaseClass<TLearntSubject>.AdrNode;
begin
  AssignFile(myFile, 'Data\Subject');
  Rewrite(myFile);
  node := objTLearntSubject.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTStudent();
var
   myFile: File of TStudent;
   node: BaseClass<TStudent>.AdrNode;
begin
  AssignFile(myFile, 'Data\Student');
  Rewrite(myFile);
  node := objTStudent.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTGroup();
var
   myFile: File of TGroup;
   node: BaseClass<TGroup>.AdrNode;
begin
  AssignFile(myFile, 'Data\Group');
  Rewrite(myFile);
  node := objTGroup.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTSpecialty();
var
   myFile: File of TSpecialty;
   node: BaseClass<TSpecialty>.AdrNode;
begin
  AssignFile(myFile, 'Data\Specialty');
  Rewrite(myFile);
  node := objTSpecialty.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTLearntForm();
var
   myFile: File of TLearntForm;
   node: BaseClass<TLearntForm>.AdrNode;
begin
  AssignFile(myFile, 'Data\LearntForm');
  Rewrite(myFile);
  node := objTLearntForm.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

Procedure SaveFileTFaculty();
var
   myFile: File of TFaculty;
   node: BaseClass<TFaculty>.AdrNode;
begin
  AssignFile(myFile, 'Data\Faculty');
  Rewrite(myFile);
  node := objTFaculty.headList^.Next;
  while (node <> nil) do begin
    Write(myFile, node^.inf);
    node := node^.Next;
  end;
  CloseFile(myFile);
end;

procedure SaveDataFile();
begin
  SaveFileTTeacher();
  SaveFileTStudent();
  SaveFileTLearntSubject();
  SaveFileTSpecialty();
  SaveFileTGroup();
  SaveFileTLearntForm();
  SaveFileTFaculty();
end;

end.
